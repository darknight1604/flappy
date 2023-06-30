import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../flappy_game.dart';
import 'bird.dart';

class Base extends SpriteComponent
    with HasGameRef<FlappyGame>, CollisionCallbacks {
  final Vector2 velocity = Vector2.zero();
  final double basePosition;

  Base(this.basePosition);

  @override
  void onLoad() {
    super.onLoad();
    Image image = game.images.fromCache('base.png');
    sprite = Sprite(image);
    position = Vector2(basePosition, game.canvasSize.y - image.height);
    double baseHeight = image.height.toDouble();
    size = Vector2(game.canvasSize.x, baseHeight);
    game.baseHeight = baseHeight;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    velocity.x = game.gameSpeed;
    position -= velocity * dt;
    if (sprite == null) return;
    if (position.x <= -size.x) removeFromParent();
    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is! Bird) return;
    game.isGameOver = true;
  }
}
