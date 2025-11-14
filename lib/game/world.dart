import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// World component for the game environment
class GameWorld extends Component with HasGameRef {
  final Paint gridPaint = Paint()
    ..color = Colors.white.withOpacity(0.1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  void render(Canvas canvas) {
    // Draw a simple grid pattern
    const gridSize = 50.0;
    
    // Vertical lines
    for (double x = 0; x < gameRef.size.x; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, gameRef.size.y),
        gridPaint,
      );
    }
    
    // Horizontal lines
    for (double y = 0; y < gameRef.size.y; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(gameRef.size.x, y),
        gridPaint,
      );
    }
  }
}

