import 'dart:math' as math;

import 'package:tetris/core/ui/identica.dart';

enum TetrominoShapes {
  I._(
    shape: [
      [1, 1, 1, 1],
    ],
    origin: [
      [1, -1],
      [-1, 1],
    ],
    startXy: [3, 0],
  ),
  L._(
    shape: [
      [0, 0, 1],
      [1, 1, 1],
    ],
    origin: [
      [0, 0],
      [1, 0],
      [0, -1],
      [-1, 1],
    ],
    startXy: [4, -1],
  ),
  J._(
    shape: [
      [1, 0, 0],
      [1, 1, 1],
    ],
    origin: [
      [0, 0],
      [-1, 0],
      [0, -1],
      [1, 1],
    ],
    startXy: [4, -1],
  ),
  Z._(
    shape: [
      [1, 1, 0],
      [0, 1, 1],
    ],
    origin: [
      [0, 0],
      [1, 0],
      [0, -1],
      [-1, 1],
    ],
    startXy: [4, -1],
  ),
  S._(
    shape: [
      [0, 1, 1],
      [1, 1, 0],
    ],
    origin: [
      [0, 0],
      [1, 0],
      [0, -1],
      [-1, 1],
    ],
    startXy: [4, -1],
  ),
  O._(
    shape: [
      [1, 1],
      [1, 1],
    ],
    origin: [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
    ],
    startXy: [4, -1],
  ),
  T._(
    shape: [
      [0, 1, 0],
      [1, 1, 1],
    ],
    origin: [
      [0, 0],
      [1, 0],
      [0, -1],
      [-1, 1],
    ],
    startXy: [4, -1],
  );

  const TetrominoShapes._({
    required this.shape,
    required this.origin,
    required this.startXy,
  });

  final List<List<int>> shape;
  final List<List<int>> origin;
  final List<int> startXy;
}

class Tetromino {
  Tetromino(this.type, this.xyPosition, this.rotateIndex) {
    identica = _generateIdentica();
  }

  Tetromino._withIdentica(
    this.type,
    this.xyPosition,
    this.rotateIndex,
    this.identica,
  );

  factory Tetromino.getRandom() {
    final int i = math.Random().nextInt(TetrominoShapes.values.length);
    return Tetromino.fromType(TetrominoShapes.values[i]);
  }

  factory Tetromino.fromType(TetrominoShapes type) =>
      Tetromino(type, type.startXy, 0);

  final TetrominoShapes type;
  final List<int> xyPosition;
  final int rotateIndex;
  late final Identica identica;

  // Уникальное состояние для каждого тетромино
  final int _uniqueState =
      DateTime.now().millisecondsSinceEpoch + math.Random().nextInt(1000000);

  // Приватный метод для генерации идентики
  Identica _generateIdentica() {
    // Этот seed гарантирует, что один тетромино всегда получит одну и ту же идентику
    final math.Random random = math.Random(_uniqueState);
    return Identica.allIdenticas[random.nextInt(Identica.allIdenticas.length)];
  }

  Tetromino fall({int step = 1}) => Tetromino._withIdentica(
        type,
        [xyPosition[0], xyPosition[1] + step],
        rotateIndex,
        identica,
      );

  Tetromino right() => Tetromino._withIdentica(
        type,
        [xyPosition[0] + 1, xyPosition[1]],
        rotateIndex,
        identica,
      );

  Tetromino left() => Tetromino._withIdentica(
        type,
        [xyPosition[0] - 1, xyPosition[1]],
        rotateIndex,
        identica,
      );

  Tetromino rotate() {
    // Вычисляем новую позицию с учетом origin
    final List<int> nextXy = [
      xyPosition[0] + type.origin[rotateIndex][0],
      xyPosition[1] + type.origin[rotateIndex][1],
    ];

    final int nextRotateIndex =
        rotateIndex + 1 >= type.origin.length ? 0 : rotateIndex + 1;

    return Tetromino._withIdentica(
      type,
      nextXy,
      nextRotateIndex,
      identica,
    );
  }

  bool isValidInMatrix(
    List<List<int>> matrix, {
    required int gameFieldHeight,
    required int gameFieldWidth,
  }) {
    // Проверяем границы с учетом поворота
    int maxWidth = type.shape[0].length;
    int maxHeight = type.shape.length;

    // Для повернутых тетромино размеры могут поменяться местами
    if (rotateIndex == 1 || rotateIndex == 3) {
      // При повороте на 90° или 270° размеры меняются местами
      maxWidth = type.shape.length;
      maxHeight = type.shape[0].length;
    }

    if (xyPosition[1] + maxHeight > gameFieldHeight ||
        xyPosition[0] < 0 ||
        xyPosition[0] + maxWidth > gameFieldWidth) {
      return false;
    }

    // Проверяем коллизии с учетом поворота
    for (int i = 0; i < matrix.length; i++) {
      final List<int> line = matrix[i];
      for (int j = 0; j < line.length; j++) {
        if (line[j] == 1 && get(j, i) == 1) {
          return false;
        }
      }
    }
    return true;
  }

  ///return null if do not show at [x][y]
  ///return 1 if show at [x,y]
  int? get(int x, int y) {
    final int x0 = x - xyPosition[0];
    final int y0 = y - xyPosition[1];

    // Применяем поворот в зависимости от rotateIndex
    int rotatedX = x0;
    int rotatedY = y0;

    // Теперь у всех тетромино 4 поворота
    switch (rotateIndex) {
      case 0: // Исходная форма
        rotatedX = x0;
        rotatedY = y0;
        break;
      case 1: // Поворот на 90° по часовой стрелке
        rotatedX = y0;
        rotatedY = type.shape.length - 1 - x0;
        break;
      case 2: // Поворот на 180°
        rotatedX = type.shape[0].length - 1 - x0;
        rotatedY = type.shape.length - 1 - y0;
        break;
      case 3: // Поворот на 270° по часовой стрелке
        rotatedX = type.shape[0].length - 1 - y0;
        rotatedY = x0;
        break;
    }

    // Проверяем границы после поворота
    if (rotatedX < 0 ||
        rotatedX >= type.shape[0].length ||
        rotatedY < 0 ||
        rotatedY >= type.shape.length) {
      return null;
    }

    return type.shape[rotatedY][rotatedX] == 1 ? 1 : null;
  }
}
