import 'dart:ui';

import 'package:flame/components.dart';

import '../flappy_game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyGame> {
  @override
  void onLoad() {
    super.onLoad();
    Image image = game.images.fromCache('background.png');
    sprite = Sprite(image);
    position = Vector2(0, 0);
    size = Vector2(game.canvasSize.x, game.canvasSize.y);
  }
}
