import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';
import 'power_up.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  final bool isIndestructible;

  final int maxHits;
  int currentHits = 0;

  Brick({
    required super.position,
    required Color color,
    this.isIndestructible = false,
    this.maxHits = 0,
  }) : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (isIndestructible) {
      return;
    }

    currentHits++;
    
    if (currentHits >= maxHits) {
      removeFromParent();
      game.score.value++;
      _maybeSpawnPowerUp();
    } else {
      // Fade the brick color to indicate damage
      paint.color = paint.color.withOpacity(1 - (currentHits / maxHits));
    }

    final remainingBricks = game.world.children
        .whereType<Brick>()
        .where((brick) => !brick.isIndestructible)
        .toList();

    if (remainingBricks.isEmpty) {
      game.playState = PlayState.won;
      game.world.removeAll(game.world.children.whereType<Ball>());
      game.world.removeAll(game.world.children.whereType<Bat>());
    }
  }

  void _maybeSpawnPowerUp() {
    if (isIndestructible) return; // No power-ups from indestructible bricks

    final random = Random();
    if (random.nextDouble() < 0.6) {
      final powerUpType =
          PowerUpType.values[random.nextInt(PowerUpType.values.length)];
      final powerUp = PowerUp(
        position: position,
        type: powerUpType,
        velocity: Vector2(0, 150),
      );
      game.world.add(powerUp); // ✅ Corrected from gameRef.world.add
    }
  }
}

// Function to generate bricks with a mix of indestructible and destructible bricks
List<Brick> generateBricks(int rows, int columns) {
  final List<Brick> bricks = [];
  final random = Random();

  const brickColors = [
    Color(0xffFF206E), // Vivid Neon Pink
    Color(0xffFBFF12), // Bright Cyber Yellow
    Color(0xff00F5D4), // Electric Aqua
    Color(0xff8338EC), // Bold Deep Purple
    Color(0xffFF5700), // Futuristic Orange
    Color(0xff06D6A0), // Neon Mint Green
    Color(0xff3A86FF), // Vibrant Royal Blue
    Color(0xffEF233C), // Striking Crimson Red
    Color(0xff8D99AE), // Cool Modern Gray
    Color(0xffFFD166), // Soft Warm Gold
  ];

  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < columns; col++) {
      bool isIndestructible = random.nextDouble() < 0.2; // 20% chance for indestructible

      final position = Vector2(
        col * (brickWidth + 10),
        row * (brickHeight + 5),
      );

      final color = brickColors[random.nextInt(brickColors.length)];
      final maxHits = _getMaxHitsForColor(color);

      bricks.add(Brick(
        position: position,
        color: color,
        isIndestructible: isIndestructible,
        maxHits: maxHits,
      ));
    }
  }
  return bricks;
}

int _getMaxHitsForColor(Color color) {
  // ignore: deprecated_member_use
  switch (color.value) {
    case 0xffFF206E: // Vivid Neon Pink
      return 3;
    case 0xffFBFF12: // Bright Cyber Yellow
      return 3;
    case 0xff00F5D4: // Electric Aqua
      return 2;
    case 0xff8338EC: // Bold Deep Purple
      return 1;
    case 0xffFF5700: // Futuristic Orange
      return 3;
    case 0xff06D6A0: // Neon Mint Green
      return 1;
    case 0xff3A86FF: // Vibrant Royal Blue
      return 3;
    case 0xffEF233C: // Striking Crimson Red
      return 3;
    case 0xff8D99AE: // Cool Modern Gray
      return 2;
    case 0xffFFD166: // Soft Warm Gold
      return 1;
    default:
      return 3;
  }
}

