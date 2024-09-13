import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data.dart';
import 'common.dart';

part 'projects.g.dart';

@riverpod
class Projects extends _$Projects {
  late final DatabaseHelper database = ref.read(databaseProvider);

  @override
  Future<List<ProjectModel>> build() async {
    final dbProjects = await database.getAllProjects();

    return dbProjects;
  }

  void refresh() async {
    final dbProjects = await database.getAllProjects();
    state = AsyncValue.data(dbProjects);
  }

  Future<void> addProject(ProjectModel project) async {
    await database.saveProject(project);
    refresh();
  }
}

@riverpod
class Project extends _$Project {
  late final DatabaseHelper database = ref.read(databaseProvider);

  @override
  Future<ProjectModel> build(String projectId) async {
    try {
      final dbProject = await database.loadProject(projectId);

      if (dbProject == null) {
        final newProject = ProjectModel(
          id: projectId,
          name: 'New Project',
          layers: [
            const LayerModel(
              id: '1',
              name: 'Background',
              isBackground: true,
            ),
          ],
          createdAt: DateTime.now().millisecondsSinceEpoch,
          lastModified: DateTime.now().millisecondsSinceEpoch,
        );
        await database.saveProject(newProject);
        ref.read(projectsProvider.notifier).refresh();
        return newProject;
      }

      return dbProject;
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }

  Future<void> saveProject() async {
    final project = state.valueOrNull;
    if (project != null) {
      await database.saveProject(project.copyWith(
        lastModified: DateTime.now().millisecondsSinceEpoch,
      ));
      ref.read(projectsProvider.notifier).refresh();
    }
  }

  void updateProject(ProjectModel updatedProject) {
    state = AsyncValue.data(updatedProject);
    saveProject();
  }

  // Update methods
  void updateName(String name) {
    final project = state.valueOrNull;
    if (project != null) {
      final updatedProject = project.copyWith(name: name);
      updateProject(updatedProject);
    }
  }

  void updateLayers(List<LayerModel> layers) {
    final project = state.valueOrNull;
    if (project != null) {
      final updatedProject = project.copyWith(layers: layers);
      updateProject(updatedProject);
    }
  }

  void updateCanvasSize(Size size) {
    final project = state.valueOrNull;
    if (project != null) {
      final updatedProject = project.copyWith(canvasSize: size);
      updateProject(updatedProject);
    }
  }

  void updateZoomLevel(double zoomLevel) {
    final project = state.valueOrNull;
    if (project != null) {
      final updatedProject = project.copyWith(zoomLevel: zoomLevel);
      updateProject(updatedProject);
    }
  }

  void updateLastViewportPosition(Offset position) {
    final project = state.valueOrNull;
    if (project != null) {
      final updatedProject = project.copyWith(lastViewportPosition: position);
      updateProject(updatedProject);
    }
  }

  Future<void> updateCachedImage(Uint8List image) async {
    final project = state.valueOrNull;
    if (project != null) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${project.id}_thumbnail.png');
      await file.writeAsBytes(image);

      final updatedProject = project.copyWith(cachedImageUrl: file.path);
      updateProject(updatedProject);
    }
  }
}
