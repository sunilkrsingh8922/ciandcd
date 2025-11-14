import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/main_game.dart';

/// Page that displays the Flame 2D game
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late MainGame game;

  @override
  void initState() {
    super.initState();
    game = MainGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flame 2D Game'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Focus(
        autofocus: true,
        child: GameWidget<MainGame>.controlled(
          gameFactory: () => game,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black87,
        child: const Text(
          'Use Arrow Keys or WASD to move',
          style: TextStyle(color: Colors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

