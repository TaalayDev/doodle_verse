import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'drawing_path.dart';

import '../../core/canvas/tools_manager.dart';
part 'project_model.freezed.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();
  const factory ProjectModel({
    required int id,
    required String name,
    required List<LayerModel> layers,
    Uint8List? cachedImage,
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
      cachedImage: json['cachedImage'] != null
          ? Uint8List.fromList(List<int>.from(json['cachedImage']))
          : null,
      createdAt: json['createdAt'],
      lastModified: json['lastModified'],
      canvasSize: Size(
        json['canvasWidth'],
        json['canvasHeight'],
      ),
      zoomLevel: json['zoomLevel'],
      lastViewportPosition: json['lastViewportPosition'] != null
          ? Offset(
              json['lastViewportPosition']['dx'],
              json['lastViewportPosition']['dy'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'layers': layers.map((layer) => layer.toMap()).toList(),
      'cachedImage': cachedImage,
      'createdAt': createdAt,
      'lastModified': lastModified,
      'canvasWidth': canvasSize.width,
      'canvasHeight': canvasSize.height,
      'zoomLevel': zoomLevel,
      'lastViewportPosition': lastViewportPosition != null
          ? {
              'dx': lastViewportPosition!.dx,
              'dy': lastViewportPosition!.dy,
            }
          : null,
    };
  }
}

@freezed
class LayerModel with _$LayerModel {
  const LayerModel._();
  const factory LayerModel({
    required int id,
    required String name,
    @Default(true) bool isVisible,
    @Default(false) bool isLocked,
    @Default(false) bool isBackground,
    @Default(1.0) double opacity,
    @Default([]) final List<LayerStateModel> states,
  }) = _LayerModel;

  static LayerModel fromMap(Map<String, dynamic> json) {
    return LayerModel(
      id: json['id'],
      name: json['name'],
      isVisible: json['isVisible'] == 1,
      isLocked: json['isLocked'] == 1,
      isBackground: json['isBackground'] == 1,
      opacity: json['opacity'] ?? 1.0,
      states: (json['states'] as List)
          .map((stateJson) => LayerStateModel.fromJson(stateJson))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isVisible': isVisible,
      'isLocked': isLocked,
      'isBackground': isBackground,
      'opacity': opacity,
      'states': states.map((state) => state.toJson()).toList(),
    };
  }
}

@freezed
class LayerStateModel with _$LayerStateModel {
  const LayerStateModel._();
  const factory LayerStateModel({
    required int id,
    required DrawingPath drawingPath,
  }) = _LayerStateModel;

  factory LayerStateModel.fromJson(Map<String, dynamic> json) {
    final points =
        json['points'] is String ? jsonDecode(json['points']) : json['points'];

    return LayerStateModel(
      id: json['id'],
      drawingPath: DrawingPath(
        points: (points as List)
            .map(
              (pointJson) => Offset(pointJson['x'], pointJson['y']),
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
      'id': id,
      'points': drawingPath.points
          .map(
            (point) => {
              'x': point.dx,
              'y': point.dy,
            },
          )
          .toList(),
      'brush': drawingPath.brush.id,
      'color': drawingPath.color.value,
      'width': drawingPath.width,
    };
  }
}
