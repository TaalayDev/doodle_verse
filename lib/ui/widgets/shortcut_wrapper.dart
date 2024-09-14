import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutsWrapper extends StatelessWidget {
  const ShortcutsWrapper({
    super.key,
    required this.child,
    required this.onUndo,
    required this.onRedo,
    this.focusNode,
  });

  final Widget child;
  final Function() onUndo;
  final Function() onRedo;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final controlKey = defaultTargetPlatform == TargetPlatform.macOS
        ? LogicalKeyboardKey.meta
        : LogicalKeyboardKey.control;

    return isDesktopOrWeb()
        ? Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(
                controlKey,
                LogicalKeyboardKey.keyZ,
              ): const UndoIntent(),
              LogicalKeySet(
                controlKey,
                LogicalKeyboardKey.keyY,
              ): const RedoIntent(),
              LogicalKeySet(
                controlKey,
                LogicalKeyboardKey.shift,
                LogicalKeyboardKey.keyZ,
              ): const RedoIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                UndoIntent: CallbackAction<UndoIntent>(
                  onInvoke: (UndoIntent intent) => onUndo(),
                ),
                RedoIntent: CallbackAction<RedoIntent>(
                  onInvoke: (RedoIntent intent) => onRedo(),
                ),
              },
              child: Focus(
                focusNode: focusNode,
                autofocus: true,
                child: child,
              ),
            ),
          )
        : child;
  }

  bool isDesktopOrWeb() {
    return kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }
}

class UndoIntent extends Intent {
  const UndoIntent();
}

class RedoIntent extends Intent {
  const RedoIntent();
}
