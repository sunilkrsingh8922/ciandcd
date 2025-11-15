import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'main_game.dart';

/// Keyboard handler component for the game
class GameKeyboardHandler extends Component with HasGameReference<MainGame>, KeyboardHandler {
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Space bar or Enter to throw ball
    if (event is KeyDownEvent) {
      final isSpace = event.logicalKey == LogicalKeyboardKey.space;
      final isEnter = event.logicalKey == LogicalKeyboardKey.enter;
      
      if (isSpace || isEnter) {
        final mainGame = game;
        mainGame.handleThrowKey();
        return true;
      }
    }
    return false;
  }
}

