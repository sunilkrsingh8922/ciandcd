import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'main_game.dart';

/// Component to handle throw key presses
class ThrowHandler extends Component with HasGameReference<MainGame>, KeyboardHandler {
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Handle key down events
    if (event is KeyDownEvent) {
      // Check for space or enter key
      if (event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        game.handleThrowKey();
        return true;
      }
    }
    return false;
  }
}

