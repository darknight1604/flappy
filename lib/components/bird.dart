import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../flappy_game.dart';

class Bird extends SpriteAnimationComponent with HasGameRef<FlappyGame> {
  final double _gravity = .25;

  bool _isJump = false;
  double _baseMovement = 0;

  @override
  void onLoad() {
    super.onLoad();
    Image downflapImage = game.images.fromCache('downflap.png');
    Image midflapImage = game.images.fromCache('midflap.png');
    Image upflapImage = game.images.fromCache('upflap.png');
    animation = SpriteAnimation.spriteList(
      stepTime: 0.2,
      [
        Sprite(downflapImage),
        Sprite(midflapImage),
        Sprite(upflapImage),
      ],
    );
    position = Vector2(20, game.canvasSize.y / 2);
    anchor = Anchor.centerLeft;
    angle = -45;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isJump) {
      _isJump = false;
      _baseMovement = -6;
    } else {
      _baseMovement += _gravity;
    }
    if (_baseMovement < 0) {
      angle = -45;
    } else {
      angle = 45;
    }
    position.translate(0, _baseMovement);
  }

  void onTap() {
    _isJump = true;
  }
}
