import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();
  const factory ProjectModel({
    required String id,
    required String name,
    required List<LayerModel> layers,
    String? cachedImageUrl,
    required int createdAt,
    required int lastModified,
    @Default(Size(1080, 1920)) Size canvasSize,
    @Default(1.0) double zoomLevel,
    Offset? lastViewportPosition,
  }) = _ProjectModel;

  static ProjectModel fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      layers: (json['layers'] as List)
          .map((layerJson) => LayerModel.fromMap(layerJson))
          .toList(),
      cachedImageUrl: json['cachedImageUrl'],
      createdAt: json['createdAt'],
      lastModified: json['lastModified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cachedImageUrl': cachedImageUrl,
      'createdAt': createdAt,
      'lastModified': lastModified,
    };
  }

  File? get cachedImageFile {
    if (cachedImageUrl == null) return null;
    return File(cachedImageUrl!);
  }
}

@freezed
class LayerModel with _$LayerModel {
  const LayerModel._();
  const factory LayerModel({
    required String id,
    required String name,
    @Default(true) bool isVisible,
    @Default(false) bool isLocked,
    @Default(false) bool isBackground,
    @Default(1.0) double opacity,
    String? cachedImageUrl,
    @Default([]) final List<LayerStateModel> prevStates,
    @Default([]) final List<LayerStateModel> redoStates,
  }) = _LayerModel;

  static LayerModel fromMap(Map<String, dynamic> json) {
    return LayerModel(
      id: json['id'],
      name: json['name'],
      isVisible: json['isVisible'] == 1,
      isLocked: json['isLocked'] == 1,
      isBackground: json['isBackground'] == 1,
      opacity: json['opacity'],
      cachedImageUrl: json['cachedImageUrl'],
      prevStates: (json['prevLayerStates'] as List)
          .map((stateJson) => LayerStateModel.fromMap(stateJson))
          .toList(),
      redoStates: (json['redoLayerStates'] as List)
          .map((stateJson) => LayerStateModel.fromMap(stateJson))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isVisible': isVisible ? 1 : 0,
      'isLocked': isLocked ? 1 : 0,
      'isBackground': isBackground ? 1 : 0,
      'opacity': opacity,
      'cachedImageUrl': cachedImageUrl,
    };
  }
}

@freezed
class LayerStateModel with _$LayerStateModel {
  const LayerStateModel._();
  const factory LayerStateModel({
    required String cachedBitmapFileName,
    required double opacity,
  }) = _LayerStateModel;

  static LayerStateModel fromMap(Map<String, dynamic> json) {
    return LayerStateModel(
      cachedBitmapFileName: json['cachedBitmapFileName'],
      opacity: json['opacity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cachedBitmapFileName': cachedBitmapFileName,
      'opacity': opacity,
    };
  }
}
