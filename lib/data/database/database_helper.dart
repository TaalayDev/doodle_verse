import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/project_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('doodleVerse.db');
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
        lastModified INTEGER
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
        cachedImageUrl TEXT,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE layer_states(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        layerId TEXT,
        cachedImageUrl TEXT,
        opacity REAL,
        isUndo INTEGER,
        FOREIGN KEY (layerId) REFERENCES layers (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<String> insertProject(ProjectModel project) async {
    final db = await instance.database;
    final data = project.toJson();
    data.remove('layers');
    final id = await db.insert('projects', data);

    await Future.wait(
      project.layers.map((layer) => insertLayer(layer, project.id)),
    );

    return project.id;
  }

  Future<void> insertLayer(LayerModel layer, String projectId) async {
    final db = await instance.database;
    final layerJson = layer.toMap();

    layerJson['projectId'] = projectId;
    await db.insert('layers', layerJson);
    await Future.wait([
      ...layer.prevStates
          .map((state) => insertLayerState(state, layer.id, true)),
      ...layer.redoStates
          .map((state) => insertLayerState(state, layer.id, false)),
    ]);
  }

  Future<void> insertLayerState(
    LayerStateModel state,
    String layerId,
    bool isUndo,
  ) async {
    final db = await instance.database;
    final stateJson = state.toMap();
    stateJson['layerId'] = layerId;
    stateJson['isUndo'] = isUndo ? 1 : 0;
    await db.insert('layer_states', stateJson);
  }

  Future<ProjectModel?> getProject(String id) async {
    final db = await instance.database;
    final maps = List<Map<String, dynamic>>.from(
      await db.query('projects', where: 'id = ?', whereArgs: [id]),
    );

    if (maps.isNotEmpty) {
      final projectJson = maps.first;
      final layers = await getLayers(id);
      return ProjectModel.fromJson({
        ...projectJson,
        'layers': layers
            .map((l) => {
                  ...l.toMap(),
                  'prevLayerStates':
                      l.prevStates.map((s) => s.toMap()).toList(),
                  'redoLayerStates':
                      l.redoStates.map((s) => s.toMap()).toList(),
                })
            .toList(),
      });
    }
    return null;
  }

  Future<List<LayerModel>> getLayers(String projectId) async {
    final db = await instance.database;
    final layerMaps = await db.query(
      'layers',
      where: 'projectId = ?',
      whereArgs: [projectId],
    );

    return Future.wait(layerMaps.map((layerJson) async {
      final layerId = layerJson['id'] as String;
      final prevStates = await getLayerStates(layerId, true);
      final redoStates = await getLayerStates(layerId, false);

      return LayerModel.fromMap({
        ...layerJson,
        'prevLayerStates': prevStates,
        'redoLayerStates': redoStates,
      });
    }));
  }

  Future<List<LayerStateModel>> getLayerStates(
    String layerId,
    bool isUndo,
  ) async {
    final db = await instance.database;
    final stateMaps = await db.query(
      'layer_states',
      where: 'layerId = ? AND isUndo = ?',
      whereArgs: [layerId, isUndo ? 1 : 0],
    );
    return stateMaps.map((json) => LayerStateModel.fromMap(json)).toList();
  }

  Future<List<ProjectModel>> getAllProjects() async {
    final db = await instance.database;
    final projectMaps = await db.query(
      'projects',
      orderBy: 'lastModified DESC',
    );

    return Future.wait(projectMaps.map((projectJson) async {
      final projectId = projectJson['id'] as String;
      final layers = await getLayers(projectId);

      return ProjectModel.fromJson({
        ...projectJson,
        'layers': layers
            .map(
              (l) => {
                ...l.toMap(),
                'prevLayerStates': l.prevStates.map((s) => s.toMap()).toList(),
                'redoLayerStates': l.redoStates.map((s) => s.toMap()).toList(),
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
          .map((state) => insertLayerState(state, layer.id, true)),
      ...layer.redoStates
          .map((state) => insertLayerState(state, layer.id, false)),
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
