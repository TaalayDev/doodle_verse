import 'package:doodle_verse/core/canvas/tools_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data.dart';

part 'common.g.dart';

final localStorageProvider = Provider((ref) => LocalStorage());
final databaseProvider = Provider((ref) => DatabaseHelper.instance);

typedef ToolsData = ({
  BrushData defaultBrush,
  BrushData pencil,
  BrushData eraser,
  List<BrushData> brushes,
  List<BrushData> figures,
});

@riverpod
class Tools extends _$Tools {
  @override
  ToolsData build() {
    return (
      defaultBrush: ToolsManager().defaultBrush,
      pencil: ToolsManager().pencil,
      eraser: ToolsManager().eraser,
      brushes: ToolsManager().brushes,
      figures: ToolsManager().figures,
    );
  }
}
