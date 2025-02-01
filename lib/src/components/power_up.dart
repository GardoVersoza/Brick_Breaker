import 'package:brick_breaker/src/components/brick.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import 'bat.dart';

enum PowerUpType { increaseBatSize, multipleBall }

class PowerUp extends PositionComponent with HasGameRef<BrickBreaker>, CollisionCallbacks {
  final PowerUpType type;
  final Vector2 velocity;

  PowerUp({
    required Vector2 position,
    required this.type,
    required this.velocity,
  }) : super(position: position, size: Vector2.all(20));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Add collision detection
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = _getPowerUpColor(type)
      ..style = PaintingStyle.fill;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(velocity * dt);

    // Remove the power-up when it goes off-screen
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Only apply effect if the power-up collides with the Bat
    if (other is Bat) {
      _applyEffect();
      removeFromParent(); // Remove the power-up after applying its effect
    }
    // Prevent the power-up from interacting with bricks or other components
    else if (other is Brick) {
      // Ignore collision with bricks
      return;
    }
  }

  void _applyEffect() {
    switch (type) {
      case PowerUpType.increaseBatSize:
        final bats = gameRef.world.children.query<Bat>();
        for (final bat in bats) {
          final originalSize = bat.size.x;
          bat.size.x += 100; // Increase bat size

          gameRef.add(
            TimerComponent(
              period: 5, // Duration of the effect in seconds
              repeat: false,
              onTick: () {
                if (bat.isMounted) {
                  // Reset the bat size to its original value after 5 seconds
                  bat.size.x = originalSize;
                }
              },
            ),
          );
        }
        break;
      case PowerUpType.multipleBall:
        gameRef.splitBalls(); // Split the ball into multiple balls
        break;
    }
  }

  Color _getPowerUpColor(PowerUpType type) {
    switch (type) {
      case PowerUpType.increaseBatSize:
        return Colors.green;
      case PowerUpType.multipleBall:
        return Colors.yellow;
    }
  }
}
