import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/base.dart';
import 'components/bird.dart';
import 'components/game_over.dart';
import 'components/pipe.dart';

class FlappyGame extends FlameGame with HasCollisionDetection, TapDetector {
  final world = World();
  late final CameraComponent cameraComponent;

  final double gameSpeed = 50;

  late double baseHeight = 0;
  late Timer timer;

  final double timeCreateNextPipes = 3.7;

  bool isGameOver = false;
  late Bird _bird;

  @override
  void onLoad() async {
    super.onLoad();
    await images.loadAll([
      'background.png',
      'base.png',
      'pipe_body.png',
      'pipe_head.png',
      'midflap.png',
      'downflap.png',
      'upflap.png',
      'message.png',
    ]);
    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    world.addAll(_initialComponent());

    timer = Timer(
      timeCreateNextPipes,
      repeat: true,
      onTick: () {
        world.add(
          Pipes(
            abovePipePosition: Vector2(canvasSize.x, 0),
          ),
        );
      },
    );
    addAll([
      cameraComponent,
      world,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
    List<Base> listBase = world.children.whereType<Base>().toList();
    if (listBase.length < 2) {
      world.removeWhere((component) => component is Base);
      world.addAll(_createListBase());
    }
    if (isGameOver) {
      timer.stop();

      world.removeWhere((component) => component is Pipes || component is Bird);
    }
  }

  @override
  void onTap() {
    super.onTap();
    if (isGameOver) {
      timer.reset();
      timer.start();
      _bird = Bird();
      world.add(_bird);

      isGameOver = false;

      return;
    }
    _bird.onTap();
  }

  List<Base> _createListBase() => [
        Base(0),
        Base(canvasSize.x),
      ];

  List<Component> _initialComponent() {
    final component = Pipes(
      abovePipePosition: Vector2(canvasSize.x, 0),
    );
    _bird = Bird();

    return [
      Background(),
      ..._createListBase(),
      component,
      _bird,
      GameOver(),
    ];
  }
}
