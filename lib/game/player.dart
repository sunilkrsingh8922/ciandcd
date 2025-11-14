import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Player component for the 2D game
class Player extends PositionComponent with HasGameReference, KeyboardHandler {
  static const double speed = 200.0;
  static const double playerSize = 40.0;

  Vector2 velocity = Vector2.zero();
  final Paint paint = Paint()..color = Colors.blue;

  @override
  Future<void> onLoad() async {
    size = Vector2(playerSize, playerSize);
    position = game.size / 2;
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    // Draw player as a circle
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
    
    // Draw a simple face
    canvas.drawCircle(
      Offset(size.x / 2 - 8, size.y / 2 - 5),
      3,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(size.x / 2 + 8, size.y / 2 - 5),
      3,
      Paint()..color = Colors.white,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update position based on velocity
    position += velocity * dt;
    
    // Keep player within bounds
    position.x = position.x.clamp(size.x / 2, game.size.x - size.x / 2);
    position.y = position.y.clamp(size.y / 2, game.size.y - size.y / 2);
    
    // Apply friction
    velocity *= 0.9;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      velocity.x -= speed;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      velocity.x += speed;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      velocity.y -= speed;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      velocity.y += speed;
    }

    return true;
  }
}

