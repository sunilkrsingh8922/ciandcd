import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'ball.dart';

/// Baseball goal/target component
class Goal extends PositionComponent with HasGameReference, CollisionCallbacks {
  static const double goalSize = 60.0;
  
  final Paint goalPaint = Paint()
    ..color = Colors.yellow
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;
  
  final Paint fillPaint = Paint()
    ..color = Colors.yellow.withValues(alpha: 0.2)
    ..style = PaintingStyle.fill;
  
  bool wasHit = false;
  Function()? onGoalHit;

  @override
  Future<void> onLoad() async {
    size = Vector2(goalSize, goalSize);
    // Position goal at top center
    position = Vector2(game.size.x / 2 - goalSize / 2, 30);
    anchor = Anchor.center;
    
    // Add collision shape
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    // Draw goal as a square target
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    
    // Fill
    canvas.drawRect(rect, fillPaint);
    
    // Border
    canvas.drawRect(rect, goalPaint);
    
    // Draw crosshair in center
    canvas.drawLine(
      Offset(size.x / 2, 0),
      Offset(size.x / 2, size.y),
      goalPaint,
    );
    canvas.drawLine(
      Offset(0, size.y / 2),
      Offset(size.x, size.y / 2),
      goalPaint,
    );
    
    // Draw "GOAL" text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'GOAL',
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2),
    );
  }
  
  @override
  bool onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // Check if ball hits the goal
    if (other is Ball && !wasHit) {
      wasHit = true;
      // Stop the ball immediately
      other.stop();
      onGoalHit?.call();
      // Reset hit status after a moment
      Future.delayed(const Duration(milliseconds: 500), () {
        wasHit = false;
      });
    }
    return true;
  }
  
  void reset() {
    wasHit = false;
  }
}

