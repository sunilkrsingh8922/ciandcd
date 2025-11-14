import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'player.dart';
import 'world.dart' as game_world;

/// Main game class using Flame 2D engine
class MainGame extends FlameGame with HasCollisionDetection {
  late Player player;
  late game_world.GameWorld gameWorld;

  @override
  Future<void> onLoad() async {
    // Initialize the game world
    gameWorld = game_world.GameWorld();
    add(gameWorld);

    // Initialize the player
    player = Player();
    add(player);

    // Set camera to follow player
    camera.follow(player);
  }

  @override
  Color backgroundColor() => const Color(0xFF1a1a2e);
}

