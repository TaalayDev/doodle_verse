import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:doodle_verse/core/canvas/tools_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'drawing_path.dart';

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
      canvasSize: Size(
        json['canvasWidth'],
        json['canvasHeight'],
      ),
      zoomLevel: json['zoomLevel'],
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
    String? imagePath, // File path to the layer image
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
      opacity: json['opacity'] ?? 1.0,
      imagePath: json['imagePath'],
      prevStates: (json['prevLayerStates'] as List)
          .map((stateJson) => LayerStateModel.fromJson(stateJson))
          .toList(),
      redoStates: (json['redoLayerStates'] as List)
          .map((stateJson) => LayerStateModel.fromJson(stateJson))
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
      'imagePath': imagePath,
    };
  }
}

@freezed
class LayerStateModel with _$LayerStateModel {
  const LayerStateModel._();
  const factory LayerStateModel({
    required DrawingPath drawingPath,
  }) = _LayerStateModel;

  factory LayerStateModel.fromJson(Map<String, dynamic> json) {
    final points =
        json['points'] is String ? jsonDecode(json['points']) : json['points'];

    return LayerStateModel(
      drawingPath: DrawingPath(
        points: (points as List)
            .map(
              (pointJson) => DrawingPoint(
                offset: Offset(pointJson['x'], pointJson['y']),
              ),
            )
            .toList(),
        brush: ToolsManager().getBrush(json['brush']),
        color: Color(json['color']),
        width: json['width'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': drawingPath.points
          .map(
            (point) => {
              'x': point.offset.dx,
              'y': point.offset.dy,
            },
          )
          .toList(),
      'brush': drawingPath.brush.id,
      'color': drawingPath.color.value,
      'width': drawingPath.width,
    };
  }
}
