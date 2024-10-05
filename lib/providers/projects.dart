import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/drawing_path.dart';
import '../data.dart';
import 'common.dart';

part 'projects.g.dart';

@riverpod
class Projects extends _$Projects {
  late final ProjectRepo repo = ref.read(projectRepo);

  @override
  Stream<List<ProjectModel>> build() {
    try {
      final dbProjects = repo.fetchProjects();
      return dbProjects;
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }

  Future<int> addProject(ProjectModel project) async {
    return repo.createProject(project);
  }

  Future<void> updateProject(ProjectModel project) async {
    state = AsyncValue.data(state.valueOrNull!.map((p) {
      if (p.id == project.id) {
        return project;
      }
      return p;
    }).toList());
  }
}

@riverpod
class Project extends _$Project {
  late final ProjectRepo repo = ref.read(projectRepo);

  @override
  Future<ProjectModel> build(int projectId) async {
    final dbProject = await repo.fetchProject(projectId);

    if (dbProject == null) {
      final newProject = ProjectModel(
        id: projectId,
        name: 'New Project',
        layers: [
          const LayerModel(
            id: 1,
            name: 'Background',
            isBackground: true,
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
        lastModified: DateTime.now().millisecondsSinceEpoch,
      );
      await repo.createProject(newProject);
      return newProject;
    }

    return dbProject;
  }

  Future<void> saveProject(ProjectModel model) async {
    await repo.updateProject(model.copyWith(
      lastModified: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void updateProject(ProjectModel updatedProject) {
    state = AsyncValue.data(updatedProject);
    saveProject(updatedProject);
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
    final project = await future;

    final updatedProject = project.copyWith(cachedImage: image);
    updateProject(updatedProject);
  }

  Future<void> addNewState(int layerId, DrawingPath path) async {
    final project = state.valueOrNull;
    if (project != null) {
      final layerIndex = project.layers.indexWhere((l) => l.id == layerId);
      if (layerIndex != -1) {
        final layer = project.layers[layerIndex];
        final newLayer = layer.copyWith(
          states: [
            ...layer.states,
            LayerStateModel(id: 0, drawingPath: path),
          ],
        );

        await repo.updateLayer(project.id, newLayer);

        final updatedLayers = List<LayerModel>.from(project.layers);
        updatedLayers[layerIndex] = newLayer;

        final updatedProject = project.copyWith(layers: updatedLayers);
        state = AsyncValue.data(updatedProject);
      }
    }
  }
}
