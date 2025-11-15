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
    // Update UI periodically to show score
    _startScoreUpdateTimer();
  }

  void _startScoreUpdateTimer() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {});
        _startScoreUpdateTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ball Catch Game'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(game.isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: () {
              setState(() {
                game.togglePause();
              });
            },
            tooltip: game.isPaused ? 'Resume' : 'Pause',
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              setState(() {
                game.stopGame();
              });
            },
            tooltip: 'Stop',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Request focus when tapped
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Focus(
          autofocus: true,
          child: GameWidget<MainGame>.controlled(
            gameFactory: () => game,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Player 2 Goals: ${game.player2.goals}',
                      style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Player 3 Goals: ${game.player3.goals}',
                      style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Total Hits: ${game.hits}',
                      style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total Misses: ${game.misses}',
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Player 2 (Green)',
                      style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Goals: ${game.player2.goals}',
                      style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'WASD Keys',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: game.isPaused ? null : () {
                    game.handleThrowKey();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('THROW', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Column(
                  children: [
                    Text(
                      'Player 3 (Orange)',
                      style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Goals: ${game.player3.goals}',
                      style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'IJKL Keys',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              game.isPaused 
                ? 'Game Paused - Click Play button to resume'
                : 'Aim for the YELLOW GOAL! If you miss, the other player can catch and throw!',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

