import 'dart:convert';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../core/canvas/tools_manager.dart';
import '../../data.dart';
import '../models/drawing_path.dart';

part 'project_database.g.dart';

class ProjectsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get canvasWidth => integer().withDefault(const Constant(1080))();
  IntColumn get canvasHeight => integer().withDefault(const Constant(1920))();
  RealColumn get zoomLevel => real().withDefault(const Constant(1.0))();
  RealColumn get lastViewportX => real().nullable()();
  RealColumn get lastViewportY => real().nullable()();
  BlobColumn get cachedImage => blob().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get lastModified => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class LayersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(ProjectsTable, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isBackground => boolean().withDefault(const Constant(false))();
  RealColumn get opacity => real().withDefault(const Constant(1.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LayerStatesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get layerId => integer().references(LayersTable, #id)();
  IntColumn get projectId => integer().references(ProjectsTable, #id)();
  IntColumn get order => integer().nullable()();
  TextColumn get points => text()(); // JSON string of points
  IntColumn get brushId => integer()();
  IntColumn get colorValue => integer()();
  RealColumn get width => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [ProjectsTable, LayersTable, LayerStatesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());
  static final AppDatabase instance = AppDatabase._();

  factory AppDatabase() => instance;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'doodle_verse_.db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            debugPrint(
              'Using ${result.chosenImplementation} due to unsupported '
              'browser features: ${result.missingFeatures}',
            );
          }
        },
      ),
    );
  }

  Stream<List<ProjectModel>> getAllProjects() {
    return select(projectsTable).watch().asyncMap((projectRows) async {
      final projects = <ProjectModel>[];

      for (final projectRow in projectRows) {
        final project = await getProject(projectRow.id);
        if (project != null) {
          projects.add(project);
        }
      }

      return projects;
    });
  }

  Future<ProjectModel?> getProject(int projectId) async {
    final projectRow = await (select(projectsTable)
          ..where((tbl) => tbl.id.equals(projectId)))
        .getSingleOrNull();

    if (projectRow == null) {
      return null;
    }

    final layerRows = await (select(layersTable)
          ..where((tbl) => tbl.projectId.equals(projectId)))
        .get();

    final layerModels = await Future.wait(layerRows.map((layerRow) async {
      final layerStateRow = await (select(layerStatesTable)
            ..where((tbl) =>
                tbl.layerId.equals(layerRow.id) &
                tbl.projectId.equals(projectId)))
          .get();

      List<LayerStateModel> layerStates = [];
      for (final stateRow in layerStateRow) {
        final pointsList = jsonDecode(stateRow.points) as List<dynamic>;
        final points = pointsList
            .map((point) => Offset(
                  point['x']?.toDouble() ?? 0.0,
                  point['y']?.toDouble() ?? 0.0,
                ))
            .toList();

        final drawingPath = DrawingPath(
          Path()
            ..addPolygon(
              points,
              false,
            ),
          points: points,
          brush: ToolsManager().getBrush(stateRow.brushId),
          color: Color(stateRow.colorValue),
          width: stateRow.width,
        );

        layerStates.add(LayerStateModel(
          id: stateRow.id,
          drawingPath: drawingPath,
        ));
      }

      return LayerModel(
        id: layerRow.id,
        name: layerRow.name,
        isVisible: layerRow.isVisible,
        isLocked: layerRow.isLocked,
        isBackground: layerRow.isBackground,
        opacity: layerRow.opacity,
        states: layerStates,
      );
    }).toList());

    return ProjectModel(
      id: projectRow.id,
      name: projectRow.name,
      layers: layerModels,
      cachedImage: projectRow.cachedImage,
      createdAt: projectRow.createdAt,
      lastModified: projectRow.lastModified,
      canvasSize: Size(
        projectRow.canvasWidth.toDouble(),
        projectRow.canvasHeight.toDouble(),
      ),
      zoomLevel: projectRow.zoomLevel,
      lastViewportPosition:
          projectRow.lastViewportX != null && projectRow.lastViewportY != null
              ? Offset(projectRow.lastViewportX!, projectRow.lastViewportY!)
              : null,
    );
  }

  Future<int> insertProject(ProjectModel project) async {
    return await into(projectsTable)
        .insert(ProjectsTableCompanion(
      // id will be auto-incremented
      name: Value(project.name),
      canvasWidth: Value(project.canvasSize.width.toInt()),
      canvasHeight: Value(project.canvasSize.height.toInt()),
      zoomLevel: Value(project.zoomLevel),
      lastViewportX: Value(project.lastViewportPosition?.dx),
      lastViewportY: Value(project.lastViewportPosition?.dy),
      cachedImage: Value(project.cachedImage),
      createdAt: Value(project.createdAt),
      lastModified: Value(project.lastModified),
    ))
        .then((projectId) async {
      project = project.copyWith(id: projectId);

      for (var layer in project.layers) {
        await into(layersTable)
            .insert(LayersTableCompanion(
          // id will be auto-incremented
          projectId: Value(project.id),
          name: Value(layer.name),
          isVisible: Value(layer.isVisible),
          isLocked: Value(layer.isLocked),
          isBackground: Value(layer.isBackground),
          opacity: Value(layer.opacity),
        ))
            .then((layerId) async {
          layer = layer.copyWith(id: layerId);

          for (final state in layer.states) {
            final drawingPath = state.drawingPath;
            final pointsJson = jsonEncode(drawingPath.points
                .map((point) => {
                      'x': point.dx,
                      'y': point.dy,
                    })
                .toList());

            await into(layerStatesTable).insert(LayerStatesTableCompanion(
              layerId: Value(layer.id),
              projectId: Value(project.id),
              points: Value(pointsJson),
              brushId: Value(drawingPath.brush.id),
              colorValue: Value(drawingPath.color.value),
              width: Value(drawingPath.width),
            ));
          }
        });
      }

      return projectId;
    });
  }

  Future<void> updateProject(ProjectModel project) async {
    await update(projectsTable).replace(ProjectsTableCompanion(
      id: Value(project.id),
      name: Value(project.name),
      canvasWidth: Value(project.canvasSize.width.toInt()),
      canvasHeight: Value(project.canvasSize.height.toInt()),
      zoomLevel: Value(project.zoomLevel),
      lastViewportX: Value(project.lastViewportPosition?.dx),
      lastViewportY: Value(project.lastViewportPosition?.dy),
      cachedImage: Value(project.cachedImage),
      createdAt: Value(project.createdAt),
      lastModified: Value(project.lastModified),
    ));

    // Delete existing layers and their states
    final existingLayerIds = await (select(layersTable)
          ..where((tbl) => tbl.projectId.equals(project.id)))
        .get()
        .then((rows) => rows.map((row) => row.id).toList());

    for (final layerId in existingLayerIds) {
      await (delete(layerStatesTable)
            ..where((tbl) => tbl.layerId.equals(layerId)))
          .go();

      await (delete(layersTable)..where((tbl) => tbl.id.equals(layerId))).go();
    }

    // Insert updated layers and their states
    for (var layer in project.layers) {
      await into(layersTable)
          .insert(LayersTableCompanion(
        // id will be auto-incremented
        projectId: Value(project.id),
        name: Value(layer.name),
        isVisible: Value(layer.isVisible),
        isLocked: Value(layer.isLocked),
        isBackground: Value(layer.isBackground),
        opacity: Value(layer.opacity),
      ))
          .then((layerId) async {
        layer = layer.copyWith(id: layerId);

        for (final state in layer.states) {
          final drawingPath = state.drawingPath;
          final pointsJson = jsonEncode(drawingPath.points
              .map((point) => {
                    'x': point.dx,
                    'y': point.dy,
                  })
              .toList());

          await into(layerStatesTable).insert(LayerStatesTableCompanion(
            layerId: Value(layer.id),
            projectId: Value(project.id),
            points: Value(pointsJson),
            brushId: Value(drawingPath.brush.id),
            colorValue: Value(drawingPath.color.value),
            width: Value(drawingPath.width),
          ));
        }
      });
    }
  }

  Future<void> deleteProject(int projectId) async {
    final layerIds = await (select(layersTable)
          ..where((tbl) => tbl.projectId.equals(projectId)))
        .get()
        .then((rows) => rows.map((row) => row.id).toList());

    for (final layerId in layerIds) {
      await (delete(layerStatesTable)
            ..where((tbl) => tbl.layerId.equals(layerId)))
          .go();
    }

    await (delete(layersTable)..where((tbl) => tbl.projectId.equals(projectId)))
        .go();

    await (delete(projectsTable)..where((tbl) => tbl.id.equals(projectId)))
        .go();
  }

  Future<void> renameProject(int projectId, String name) async {
    (update(projectsTable)
      ..where((tbl) => tbl.id.equals(projectId))
      ..write(ProjectsTableCompanion(name: Value(name))));
  }

  Future<int> insertLayer(int projectId, LayerModel layer) async {
    return into(layersTable)
        .insert(LayersTableCompanion(
      // id will be auto-incremented
      projectId: Value(projectId),
      name: Value(layer.name),
      isVisible: Value(layer.isVisible),
      isLocked: Value(layer.isLocked),
      isBackground: Value(layer.isBackground),
      opacity: Value(layer.opacity),
    ))
        .then((layerId) async {
      layer = layer.copyWith(id: layerId);

      for (final state in layer.states) {
        final drawingPath = state.drawingPath;
        final pointsJson = jsonEncode(drawingPath.points
            .map((point) => {
                  'x': point.dx,
                  'y': point.dy,
                })
            .toList());

        await into(layerStatesTable).insert(LayerStatesTableCompanion(
          layerId: Value(layer.id),
          projectId: Value(projectId),
          points: Value(pointsJson),
          brushId: Value(drawingPath.brush.id),
          colorValue: Value(drawingPath.color.value),
          width: Value(drawingPath.width),
        ));
      }

      return layerId;
    });
  }

  Future<void> updateLayer(int projectId, LayerModel layer) async {
    await update(layersTable).replace(LayersTableCompanion(
      id: Value(layer.id),
      projectId: Value(projectId),
      name: Value(layer.name),
      isVisible: Value(layer.isVisible),
      isLocked: Value(layer.isLocked),
      isBackground: Value(layer.isBackground),
      opacity: Value(layer.opacity),
    ));

    // Delete existing states
    await (delete(layerStatesTable)
          ..where((tbl) =>
              tbl.layerId.equals(layer.id) & tbl.projectId.equals(projectId)))
        .go();

    // Insert updated states
    for (final state in layer.states) {
      final drawingPath = state.drawingPath;
      final pointsJson = jsonEncode(drawingPath.points
          .map((point) => {
                'x': point.dx,
                'y': point.dy,
              })
          .toList());

      await into(layerStatesTable).insert(LayerStatesTableCompanion(
        layerId: Value(layer.id),
        projectId: Value(projectId),
        points: Value(pointsJson),
        brushId: Value(drawingPath.brush.id),
        colorValue: Value(drawingPath.color.value),
        width: Value(drawingPath.width),
      ));
    }
  }

  Future<void> deleteLayer(int layerId) async {
    // Delete layer state
    await (delete(layerStatesTable)
          ..where((tbl) => tbl.layerId.equals(layerId)))
        .go();

    // Delete layer
    await (delete(layersTable)..where((tbl) => tbl.id.equals(layerId))).go();
  }
}
