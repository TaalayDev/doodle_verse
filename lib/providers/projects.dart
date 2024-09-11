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
}

@riverpod
class Project extends _$Project {
  late final DatabaseHelper database = ref.read(databaseProvider);

  @override
  Future<ProjectModel> build(String projectId) async {
    try {
      final dbProject = await database.getProject(projectId);

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
        await database.insertProject(newProject);
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

  void updateName(String name) {
    final project = state.valueOrNull;
    if (project != null) {
      state = AsyncValue.data(project.copyWith(name: name));
    }

    final dbProject = project?.copyWith(name: name);
    if (dbProject != null) {
      database.updateProject(dbProject);
    }
  }

  void updateLayers(List<LayerModel> layers) {
    state.whenData((project) {
      state = AsyncValue.data(project.copyWith(layers: layers));
      database.updateProject(state.requireValue);
    });
  }

  void updateCanvasSize(Size size) {
    state.whenData((project) {
      state = AsyncValue.data(project.copyWith(canvasSize: size));
      database.updateProject(state.requireValue);
    });
  }

  void updateZoomLevel(double zoomLevel) {
    state.whenData((project) {
      state = AsyncValue.data(project.copyWith(zoomLevel: zoomLevel));
      database.updateProject(state.requireValue);
    });
  }

  void updateLastViewportPosition(Offset position) {
    state.whenData((project) {
      state = AsyncValue.data(project.copyWith(lastViewportPosition: position));
      database.updateProject(state.requireValue);
    });
  }

  void updateCachedImage(Uint8List image) async {
    final project = state.valueOrNull;
    if (project != null) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${project.id}_thumbnail.png');
      await file.writeAsBytes(image);

      state = AsyncValue.data(project.copyWith(cachedImageUrl: file.path));
      database.updateProject(state.requireValue);

      ref.read(projectsProvider.notifier).refresh();
    }
  }
}
