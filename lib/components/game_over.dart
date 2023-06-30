import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flappy/flappy_game.dart';

class GameOver extends SpriteComponent with HasGameRef<FlappyGame> {
  @override
  void onLoad() {
    super.onLoad();
    Image image = game.images.fromCache('message.png');
    sprite = Sprite(image);
    position = Vector2(game.canvasSize.x / 4, game.canvasSize.y / 4);
    size = Vector2(game.canvasSize.x / 2, game.canvasSize.y / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) {
      priority = 5;
      return;
    }
    priority = -1;
  }
}
