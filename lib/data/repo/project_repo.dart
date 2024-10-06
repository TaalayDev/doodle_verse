import 'dart:async';

import '../../core/utils/queue_manager.dart';
import '../database/project_database.dart';
import '../models/project_model.dart';

abstract class ProjectRepo {
  Stream<List<ProjectModel>> fetchProjects();
  Future<ProjectModel?> fetchProject(int projectId);
  Future<int> createProject(ProjectModel project);
  Future<void> updateProject(ProjectModel project);
  Future<void> renameProject(int projectId, String name);
  Future<void> deleteProject(int projectId);
  Future<int> createLayer(int projectId, LayerModel layer);
  Future<void> updateLayer(int projectId, LayerModel layer);
  Future<void> deleteLayer(int projectId, int layerId);
}

class ProjectLocalRepo extends ProjectRepo {
  final AppDatabase db;
  final QueueManager queueManager;

  ProjectLocalRepo(this.db, this.queueManager);
  @override
  Stream<List<ProjectModel>> fetchProjects() => db.getAllProjects();

  @override
  Future<ProjectModel?> fetchProject(int projectId) => db.getProject(projectId);

  @override
  Future<int> createProject(ProjectModel project) => db.insertProject(project);

  @override
  Future<void> updateProject(ProjectModel project) async {
    return _addTask(() async {
      await db.updateProject(project);
    });
  }

  @override
  Future<void> renameProject(int projectId, String name) async {
    return _addTask(() async {
      await db.renameProject(projectId, name);
    });
  }

  @override
  Future<void> deleteProject(int projectId) async {
    return _addTask(() async {
      await db.deleteProject(projectId);
    });
  }

  @override
  Future<int> createLayer(int projectId, LayerModel layer) async {
    return _addTask(() async {
      return db.insertLayer(projectId, layer);
    });
  }

  @override
  Future<void> updateLayer(int projectId, LayerModel layer) async {
    return _addTask(() async {
      await db.updateLayer(projectId, layer);
    });
  }

  @override
  Future<void> deleteLayer(int projectId, int layerId) async {
    return _addTask(() async {
      await db.deleteLayer(layerId);
    });
  }

  Future<T> _addTask<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    queueManager.add(() async {
      final result = await task();
      completer.complete(result);
    });

    return completer.future;
  }
}
