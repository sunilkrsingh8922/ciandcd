import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'player.dart';

/// Ball component that bounces off walls
class Ball extends CircleComponent with HasGameReference, CollisionCallbacks {
  static const double ballRadius = 15.0;
  static const double ballSpeed = 300.0;

  Vector2 ballVelocity = Vector2.zero();
  Player? isHeldBy;
  bool get isMoving => ballVelocity.length > 0.1;
  
  @override
  Paint get paint => Paint()..color = Colors.red;

  Ball() : super(radius: ballRadius);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Add collision shape
    add(CircleHitbox());
    
    // Set initial position (center)
    position = Vector2(game.size.x / 2, game.size.y / 2);
    
    // Ball starts stationary
    ballVelocity = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    // Draw the ball
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );
    
    // Draw a highlight
    canvas.drawCircle(
      Offset(radius - 3, radius - 3),
      radius / 3,
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // If held by a player, follow the player
    if (isHeldBy != null && !isMoving) {
      position = isHeldBy!.position;
      return;
    }
    
    // Update position based on velocity
    position += ballVelocity * dt;
    
    // If ball goes out of bounds, let game handle it (for miss detection)
    // Don't bounce off walls - let it go out for miss detection
    if (isMoving) {
      // Slow down over time (gravity/air resistance effect)
      ballVelocity *= 0.998;
    }
  }
  
  /// Throw the ball towards a target position
  void throwTo(Vector2 targetPosition) {
    if (isHeldBy != null) {
      // Calculate direction from current position to target
      final direction = (targetPosition - position);
      if (direction.length > 0.1) {
        ballVelocity = direction.normalized() * ballSpeed;
        isHeldBy = null;
      } else {
        // If too close, throw in a default direction
        ballVelocity = Vector2(1, 0).normalized() * ballSpeed;
        isHeldBy = null;
      }
    }
  }
  
  /// Stop the ball (when caught)
  void stop() {
    ballVelocity = Vector2.zero();
  }

}

