import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// World component for the game environment
class GameWorld extends Component with HasGameReference {
  final Paint gridPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  void render(Canvas canvas) {
    // Draw a simple grid pattern
    const gridSize = 50.0;
    
    // Vertical lines
    for (double x = 0; x < game.size.x; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, game.size.y),
        gridPaint,
      );
    }
    
    // Horizontal lines
    for (double y = 0; y < game.size.y; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(game.size.x, y),
        gridPaint,
      );
    }
  }
}

