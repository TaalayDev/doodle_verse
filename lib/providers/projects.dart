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
    final dbProjects = repo.fetchProjects();
    return dbProjects;
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

  Future<void> deleteProject(int projectId) async {
    await repo.deleteProject(projectId);
  }

  void updateProjectName(int projectId, String name) {
    repo.renameProject(projectId, name);
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

  // Layer methods
  void setActiveLayerByIndex(int layerId) {
    final project = state.valueOrNull;
    if (project != null) {
      // TODO: Implement setActiveLayerByIndex
    }
  }

  void setLayerVisibility(int layerId, bool isVisible) {
    final project = state.valueOrNull;
    if (project != null) {
      final updatedLayers = project.layers.map((layer) {
        if (layer.id == layerId) {
          return layer.copyWith(isVisible: isVisible);
        }
        return layer;
      }).toList();
      final updatedProject = project.copyWith(layers: updatedLayers);
      updateProject(updatedProject);
    }
  }

  Future<LayerModel> addLayer(LayerModel layer) async {
    final id = await repo.createLayer(projectId, layer);

    final project = await future;

    final updatedLayers = List<LayerModel>.from(project.layers)
      ..add(layer.copyWith(id: id));
    final updatedProject = project.copyWith(layers: updatedLayers);

    state = AsyncData(updatedProject);

    return layer.copyWith(id: id);
  }

  void updateLayer(LayerModel layer) {
    repo.updateLayer(projectId, layer);

    final project = state.valueOrNull;
    if (project == null) return;

    final updatedLayers = project.layers.map((l) {
      if (l.id == layer.id) {
        return layer;
      }
      return l;
    }).toList();
    final updatedProject = project.copyWith(layers: updatedLayers);
    state = AsyncData(updatedProject);
  }

  void deleteLayer(int layerId) {
    repo.deleteLayer(projectId, layerId);

    final project = state.valueOrNull;
    if (project == null) return;

    final updatedLayers = project.layers.where((l) => l.id != layerId).toList();
    final updatedProject = project.copyWith(layers: updatedLayers);
    state = AsyncData(updatedProject);
  }
}
