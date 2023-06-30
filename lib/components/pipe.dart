import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

import '../flappy_game.dart';
import 'bird.dart';

class Pipes extends Component with HasGameRef<FlappyGame>, CollisionCallbacks {
  final Vector2 abovePipePosition;
  final double space = 200;
  final double minHeightPipe = 50;

  late Vector2 velocity = Vector2.zero();

  Pipes({
    required this.abovePipePosition,
  });

  @override
  void onLoad() {
    super.onLoad();
    double abovePipeHeight =
        minHeightPipe + Random().nextDouble() * game.canvasSize.y / 2;
    double baseHeight = game.baseHeight;
    double heightExceptBase = game.canvasSize.y - baseHeight;

    double belowPipeHeight = heightExceptBase - space - abovePipeHeight;
    if (belowPipeHeight < minHeightPipe) {
      belowPipeHeight = minHeightPipe;
      abovePipeHeight = heightExceptBase - space - belowPipeHeight;
    }
    final pipe = _Pipe(
      pipeHeight: abovePipeHeight,
      basePosition: abovePipePosition,
    );
    add(pipe);
    final belowPipe = _BelowPipe(
      pipeHeight: belowPipeHeight,
      basePosition: Vector2(
        abovePipePosition.x,
        heightExceptBase - belowPipeHeight,
      ),
    );
    add(belowPipe);
  }
}

class _Pipe extends SpriteComponent
    with HasGameRef<FlappyGame>, CollisionCallbacks {
  final double pipeHeight;
  final Vector2 basePosition;
  final double space = 100;

  late Vector2 velocity = Vector2.zero();

  _Pipe({
    required this.basePosition,
    this.pipeHeight = 100,
  }) : assert(basePosition.y == 0, 'basePosition must has y = 0');

  @override
  void onLoad() async {
    Image image = await createPipe();
    sprite = Sprite(image);
    position = basePosition;
    add(RectangleHitbox());
  }

  Future<Image> createPipe() async {
    Image pipeBodyImage = game.images.fromCache('pipe_body.png');
    Image pipeHeadImage = game.images.fromCache('pipe_head.png');
    double pipeBodyHeight = pipeHeight - pipeHeadImage.height;
    pipeBodyImage = await pipeBodyImage.resize(
      Vector2(
        pipeBodyImage.size.x,
        pipeBodyHeight,
      ),
    );
    ImageComposition composition = ImageComposition()
      ..add(
        pipeBodyImage,
        Vector2((pipeHeadImage.width - pipeBodyImage.width) / 2, 0),
      )
      ..add(pipeHeadImage, Vector2(0, pipeBodyHeight));
    return await composition.compose();
  }

  @override
  void update(double dt) {
    velocity.x = game.gameSpeed;
    position -= velocity * dt;

    if (position.x < -sprite!.image.width) removeFromParent();
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

class _BelowPipe extends SpriteComponent
    with HasGameRef<FlappyGame>, CollisionCallbacks {
  final double pipeHeight;
  final Vector2 basePosition;
  late Vector2 velocity = Vector2.zero();
  _BelowPipe({
    required this.basePosition,
    this.pipeHeight = 100,
  });

  @override
  void onLoad() async {
    Image image = await createPipe();
    sprite = Sprite(image);
    position = basePosition;
    add(RectangleHitbox());
  }

  Future<Image> createPipe() async {
    Image pipeBodyImage = game.images.fromCache('pipe_body.png');
    Image pipeHeadImage = game.images.fromCache('pipe_head.png');
    double pipeBodyHeight = pipeHeight - pipeHeadImage.height;
    pipeBodyImage = await pipeBodyImage.resize(
      Vector2(
        pipeBodyImage.size.x,
        pipeBodyHeight,
      ),
    );
    ImageComposition composition = ImageComposition()
      ..add(pipeHeadImage, Vector2(0, 0))
      ..add(
        pipeBodyImage,
        Vector2((pipeHeadImage.width - pipeBodyImage.width) / 2,
            pipeHeadImage.size.y),
      );
    return await composition.compose();
  }

  @override
  void update(double dt) {
    velocity.x = game.gameSpeed;
    position -= velocity * dt;
    if (position.x < -sprite!.image.width) removeFromParent();
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
