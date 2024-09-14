import 'dart:ui' as ui;

import '../../config/const.dart';

class ShaderManager {
  static final ShaderManager _instance = ShaderManager._internal();
  factory ShaderManager() => _instance;
  ShaderManager._internal();

  final Map<String, ui.FragmentProgram> _shaders = {};

  Future<void> loadShaders() async {
    for (final shader in Shaders.all) {
      _shaders[shader] = await ui.FragmentProgram.fromAsset(shader);
    }
  }

  ui.FragmentProgram? getShader(String name) => _shaders[name];
}
