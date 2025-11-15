import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'player.dart';
import 'ball.dart';
import 'goal.dart';
import 'world.dart' as game_world;
import 'throw_handler.dart';

/// Main game class using Flame 2D engine
class MainGame extends FlameGame with HasCollisionDetection {
  late Player player2;
  late Player player3;
  late Ball ball;
  late Goal goal;
  late game_world.GameWorld gameWorld;
  int passCount = 0;
  int hits = 0;
  int misses = 0;
  bool isPaused = false;
  Player? lastThrowingPlayer; // Track who last threw the ball
  
  List<Player> get allPlayers => [player2, player3];

  @override
  Future<void> onLoad() async {
    // Initialize the game world
    gameWorld = game_world.GameWorld();
    add(gameWorld);

    // Initialize Player 2 (Green, WASD)
    player2 = Player(
      paint: Paint()..color = Colors.green,
      playerName: 'Player 2',
      playerNumber: 2,
    );
    player2.onBallCaught = _onBallCaught;
    add(player2);

    // Initialize Player 3 (Orange, IJKL)
    player3 = Player(
      paint: Paint()..color = Colors.orange,
      playerName: 'Player 3',
      playerNumber: 3,
    );
    player3.onBallCaught = _onBallCaught;
    add(player3);

    // Initialize the goal
    goal = Goal();
    goal.onGoalHit = _onGoalHit;
    add(goal);
    
    // Initialize the ball
    ball = Ball();
    add(ball);
    
    // Add throw handler to world so it receives keyboard events
    world.add(ThrowHandler());
    
    // Give ball to Player 2 initially
    player2.hasBall = true;
    ball.isHeldBy = player2;
    ball.stop();
    
    // Wait a frame to ensure positions are set
    await Future.delayed(const Duration(milliseconds: 50));
    ball.position = player2.position;
  }
  
  /// Called when ball hits the goal
  void _onGoalHit() {
    hits++;
    // Award goal to the player who threw it
    if (lastThrowingPlayer != null) {
      lastThrowingPlayer!.goals++;
    }
    // Ball hit the goal! Reset for next player
    _resetBallForNextPlayer();
  }
  
  /// Reset ball when it goes out of bounds or misses
  void _checkBallOutOfBounds() {
    // Check if ball is way out of bounds (missed)
    if (ball.position.y < -100 || 
        ball.position.y > size.y + 100 ||
        ball.position.x < -100 ||
        ball.position.x > size.x + 100) {
      // Ball missed! Increment miss counter
      misses++;
      
      // Don't automatically give ball to next player
      // Instead, bring ball back into play area so the other player can catch it
      // Use the last throwing player to determine who should get the chance
      if (lastThrowingPlayer != null) {
        final otherPlayer = _getNextPlayer(lastThrowingPlayer!);
        // Bring ball back into play area, near the other player so they can catch it
        final newX = (otherPlayer.position.x).clamp(50.0, size.x - 50);
        final newY = (otherPlayer.position.y - 80).clamp(50.0, size.y - 50);
        ball.position = Vector2(newX, newY);
        // Slow down the ball significantly so it can be caught
        ball.ballVelocity *= 0.2;
      } else {
        // If we don't know who threw, bring ball to center
        ball.position = Vector2(size.x / 2, size.y * 0.6);
        ball.ballVelocity *= 0.2;
      }
    }
  }
  
  /// Reset ball for next player's turn
  void _resetBallForNextPlayer() {
    // Find current player with ball
    Player? currentPlayer;
    if (player2.hasBall) {
      currentPlayer = player2;
    } else if (player3.hasBall) {
      currentPlayer = player3;
    }
    
    if (currentPlayer != null) {
      // Move to next player
      final nextPlayer = _getNextPlayer(currentPlayer);
      currentPlayer.hasBall = false;
      nextPlayer.hasBall = true;
      ball.isHeldBy = nextPlayer;
      ball.stop();
      ball.position = nextPlayer.position;
    }
  }
  
  /// Handle keyboard events for throwing
  void handleThrowKey() {
    // Find which player has the ball and throw to the goal
    if (player2.hasBall && ball.isHeldBy == player2) {
      throwBallToGoal(player2);
    } else if (player3.hasBall && ball.isHeldBy == player3) {
      throwBallToGoal(player3);
    }
  }
  
  /// Throw ball to the goal
  void throwBallToGoal(Player fromPlayer) {
    if (fromPlayer.hasBall && ball.isHeldBy == fromPlayer) {
      fromPlayer.hasBall = false;
      // Track who is throwing
      lastThrowingPlayer = fromPlayer;
      // Throw towards goal with some randomness
      final goalCenter = goal.position + goal.size / 2;
      final randomOffset = Vector2(
        (DateTime.now().millisecondsSinceEpoch % 40) - 20,
        (DateTime.now().millisecondsSinceEpoch % 40) - 20,
      );
      ball.throwTo(goalCenter + randomOffset);
      passCount++;
    }
  }
  
  /// Get the next player in rotation (2->3->2)
  Player _getNextPlayer(Player currentPlayer) {
    if (currentPlayer == player2) return player3;
    return player2; // player3 -> player2
  }

  /// Called when a player catches the ball
  void _onBallCaught(Player catchingPlayer) {
    // Ball is already stopped in player's onCollisionStart
    
    // Clear all other players' ball status
    for (final player in allPlayers) {
      if (player != catchingPlayer) {
        player.hasBall = false;
      }
    }
    
    // The catching player now has the ball and can throw it
    catchingPlayer.hasBall = true;
    ball.isHeldBy = catchingPlayer;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    // Check if ball went out of bounds (missed the goal)
    if (ball.isMoving) {
      _checkBallOutOfBounds();
    }
  }

  /// Pause or resume the game
  void togglePause() {
    isPaused = !isPaused;
    if (isPaused) {
      pauseEngine();
    } else {
      resumeEngine();
    }
  }
  
  /// Stop the game completely
  void stopGame() {
    isPaused = true;
    pauseEngine();
  }
  
  /// Resume the game
  void resumeGame() {
    isPaused = false;
    resumeEngine();
  }

  @override
  Color backgroundColor() => const Color(0xFF1a1a2e);
}

