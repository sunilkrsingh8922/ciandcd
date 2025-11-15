import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ball.dart';

class Player extends PositionComponent with HasGameReference, KeyboardHandler, CollisionCallbacks {
  static const double speed = 200.0;
  static const double playerSize = 40.0;

  Vector2 velocity = Vector2.zero();
  final Paint paint;
  final String playerName;
  final int playerNumber; // 1, 2, or 3
  
  // Callback for when ball is caught
  Function(Player)? onBallCaught;
  
  // Whether this player has the ball
  bool hasBall = false;
  
  // Number of goals scored by this player
  int goals = 0;
  
  Player({
    required this.paint,
    required this.playerName,
    required this.playerNumber,
  });

  @override
  Future<void> onLoad() async {
    size = Vector2(playerSize, playerSize);
    // Position players on opposite sides (away from goal)
    switch (playerNumber) {
      case 2:
        position = Vector2(game.size.x * 0.25, game.size.y * 0.7); // Bottom left
        break;
      case 3:
        position = Vector2(game.size.x * 0.75, game.size.y * 0.7); // Bottom right
        break;
      default:
        position = Vector2(game.size.x / 2, game.size.y / 2);
    }
    anchor = Anchor.center;
    
    // Add collision shape
    add(CircleHitbox());
  }
  
  @override
  bool onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // Check if colliding with ball
    // Only catch if ball is moving slowly (missed the goal and slowed down)
    if (other is Ball && !hasBall && other.isHeldBy != this) {
      // Only catch if ball has slowed down significantly (missed the goal)
      // Access ballVelocity through the ball's public property
      final ball = other;
      if (ball.ballVelocity.length < 50.0) {
        // Ball caught! (ball has slowed down after missing)
        hasBall = true;
        ball.isHeldBy = this;
        ball.stop(); // Stop the ball when caught
        onBallCaught?.call(this);
      }
    }
    return true;
  }
  

  @override
  void render(Canvas canvas) {
    // Draw player as a circle
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
    
    // Draw a border if player has the ball
    if (hasBall) {
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        size.x / 2 + 3,
        Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
    
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
    
    // Draw player name
    final textPainter = TextPainter(
      text: TextSpan(
        text: playerName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.x - textPainter.width) / 2, size.y + 5),
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

    switch (playerNumber) {
      case 1:
        // Player 1 controls: Arrow Keys
        if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
          velocity.x -= speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
          velocity.x += speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
          velocity.y -= speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
          velocity.y += speed;
        }
        break;
      case 2:
        // Player 2 controls: WASD
        if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
          velocity.x -= speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
          velocity.x += speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
          velocity.y -= speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
          velocity.y += speed;
        }
        break;
      case 3:
        // Player 3 controls: IJKL
        if (keysPressed.contains(LogicalKeyboardKey.keyJ)) {
          velocity.x -= speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.keyL)) {
          velocity.x += speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.keyI)) {
          velocity.y -= speed;
        }
        if (keysPressed.contains(LogicalKeyboardKey.keyK)) {
          velocity.y += speed;
        }
        break;
    }

    return true;
  }
}

