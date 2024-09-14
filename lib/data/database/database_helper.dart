import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/project_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('doodle_verse_.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects(
        id TEXT PRIMARY KEY,
        name TEXT,
        cachedImageUrl TEXT,
        createdAt INTEGER,
        lastModified INTEGER,
        canvasWidth REAL,
        canvasHeight REAL,
        zoomLevel REAL,
        viewportX REAL,
        viewportY REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE layers(
        id TEXT PRIMARY KEY,
        projectId TEXT,
        name TEXT,
        isVisible INTEGER,
        isLocked INTEGER,
        isBackground INTEGER,
        opacity REAL,
        imagePath TEXT,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE layer_states(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        layerId TEXT,
        points TEXT,
        brush INTEGER,
        color INTEGER,
        width REAL,
        isUndo INTEGER,
        FOREIGN KEY (layerId) REFERENCES layers (id) ON DELETE CASCADE
      )
    ''');
  }

  // Loading a project
  Future<ProjectModel?> loadProject(String id) async {
    final db = await instance.database;

    final projectMaps = await db.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (projectMaps.isNotEmpty) {
      final projectMap = projectMaps.first;
      final layers = await loadLayers(id);

      return ProjectModel.fromJson({
        ...projectMap,
        'layers': layers
            .map((l) => {
                  ...l.toMap(),
                  'prevLayerStates':
                      l.prevStates.map((s) => s.toJson()).toList(),
                  'redoLayerStates':
                      l.redoStates.map((s) => s.toJson()).toList(),
                })
            .toList(),
      });
    }

    return null;
  }

  // Saving a project
  Future<void> saveProject(ProjectModel project) async {
    final db = await instance.database;

    // Upsert the project
    await db.insert(
      'projects',
      _projectToMap(project),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Save layers
    for (var layer in project.layers) {
      await saveLayer(layer, project.id);
    }
  }

  Map<String, dynamic> _projectToMap(ProjectModel project) {
    return {
      'id': project.id,
      'name': project.name,
      'cachedImageUrl': project.cachedImageUrl,
      'createdAt': project.createdAt,
      'lastModified': project.lastModified,
      'canvasWidth': project.canvasSize.width,
      'canvasHeight': project.canvasSize.height,
      'zoomLevel': project.zoomLevel,
      'viewportX': project.lastViewportPosition?.dx,
      'viewportY': project.lastViewportPosition?.dy,
    };
  }

// Saving a layer
  Future<void> saveLayer(LayerModel layer, String projectId) async {
    final db = await instance.database;

    // Upsert the layer
    await db.insert(
      'layers',
      _layerToMap(layer, projectId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Save layer states
    await db.delete(
      'layer_states',
      where: 'layerId = ?',
      whereArgs: [layer.id],
    );

    for (var state in layer.prevStates) {
      await saveLayerState(state, layer.id, isUndo: true);
    }
    for (var state in layer.redoStates) {
      await saveLayerState(state, layer.id, isUndo: false);
    }
  }

  Map<String, dynamic> _layerToMap(LayerModel layer, String projectId) {
    return {
      'id': layer.id,
      'projectId': projectId,
      'name': layer.name,
      'isVisible': layer.isVisible ? 1 : 0,
      'isLocked': layer.isLocked ? 1 : 0,
      'isBackground': layer.isBackground ? 1 : 0,
      'opacity': layer.opacity,
      'imagePath': layer.imagePath,
    };
  }

  // Loading layers
  Future<List<LayerModel>> loadLayers(String projectId) async {
    final db = await instance.database;

    final layerMaps = await db.query(
      'layers',
      where: 'projectId = ?',
      whereArgs: [projectId],
    );

    final layers = <LayerModel>[];

    for (var layerMap in layerMaps) {
      final layerId = layerMap['id'] as String;
      final prevStates = await loadLayerStates(layerId, isUndo: true);
      final redoStates = await loadLayerStates(layerId, isUndo: false);

      layers.add(
        LayerModel.fromMap({
          ...layerMap,
          'prevLayerStates': prevStates.map((s) => s.toJson()).toList(),
          'redoLayerStates': redoStates.map((s) => s.toJson()).toList(),
        }),
      );
    }

    return layers;
  }

  // Saving a layer state
  Future<void> saveLayerState(
    LayerStateModel state,
    String layerId, {
    required bool isUndo,
  }) async {
    final db = await instance.database;

    await db.insert(
      'layer_states',
      {
        'layerId': layerId,
        'points': jsonEncode(state.drawingPath.points
            .map((p) => {
                  'x': p.offset.dx,
                  'y': p.offset.dy,
                })
            .toList()),
        'brush': state.drawingPath.brush.id,
        'color': state.drawingPath.color.value,
        'width': state.drawingPath.width,
        'isUndo': isUndo ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Loading layer states
  Future<List<LayerStateModel>> loadLayerStates(
    String layerId, {
    required bool isUndo,
  }) async {
    final db = await instance.database;

    final stateMaps = await db.query(
      'layer_states',
      where: 'layerId = ? AND isUndo = ?',
      whereArgs: [layerId, isUndo ? 1 : 0],
    );

    return stateMaps.map((stateMap) {
      return LayerStateModel.fromJson(stateMap);
    }).toList();
  }

  Future<List<ProjectModel>> getAllProjects() async {
    final db = await instance.database;
    final projectMaps = await db.query(
      'projects',
      orderBy: 'lastModified DESC',
    );

    return Future.wait(projectMaps.map((projectJson) async {
      final projectId = projectJson['id'] as String;
      final layers = await loadLayers(projectId);

      return ProjectModel.fromJson({
        ...projectJson,
        'layers': layers
            .map(
              (l) => {
                ...l.toMap(),
                'prevLayerStates': l.prevStates.map((s) => s.toJson()).toList(),
                'redoLayerStates': l.redoStates.map((s) => s.toJson()).toList(),
              },
            )
            .toList(),
      });
    }));
  }

  Future<int> updateProject(ProjectModel project) async {
    final db = await instance.database;
    await Future.wait(project.layers.map((layer) => updateLayer(layer)));
    return db.update(
      'projects',
      project.toJson(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  Future<int> updateLayer(LayerModel layer) async {
    final db = await instance.database;
    await db
        .delete('layer_states', where: 'layerId = ?', whereArgs: [layer.id]);
    await Future.wait([
      ...layer.prevStates
          .map((state) => saveLayerState(state, layer.id, isUndo: true)),
      ...layer.redoStates
          .map((state) => saveLayerState(state, layer.id, isUndo: false)),
    ]);
    return db.update(
      'layers',
      layer.toMap(),
      where: 'id = ?',
      whereArgs: [layer.id],
    );
  }

  Future<int> deleteProject(String id) async {
    final db = await instance.database;
    return db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
