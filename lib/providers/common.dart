import 'package:doodle_verse/core/canvas/tools_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core.dart';
import '../data.dart';

part 'common.g.dart';

final localStorageProvider = Provider((ref) => LocalStorage());
final databaseProvider = Provider((ref) => AppDatabase());
final queueManagerProvider = Provider((ref) => QueueManager());
final projectRepo = Provider<ProjectRepo>((ref) => ProjectLocalRepo(
      ref.read(databaseProvider),
      ref.read(queueManagerProvider),
    ));

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
