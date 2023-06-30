import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'flappy_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const GameWidget<FlappyGame>.controlled(
      gameFactory: FlappyGame.new,
    ),
  );
}
