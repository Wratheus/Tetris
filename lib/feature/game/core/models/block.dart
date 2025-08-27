import 'dart:math' as math;

import 'package:tetris/feature/game/widgets/controllers/game_controller.dart';

const tetrominoShapes = {
  TetrominoType.I: [
    [1, 1, 1, 1],
  ],
  TetrominoType.L: [
    [0, 0, 1],
    [1, 1, 1],
  ],
  TetrominoType.J: [
    [1, 0, 0],
    [1, 1, 1],
  ],
  TetrominoType.Z: [
    [1, 1, 0],
    [0, 1, 1],
  ],
  TetrominoType.S: [
    [0, 1, 1],
    [1, 1, 0],
  ],
  TetrominoType.O: [
    [1, 1],
    [1, 1],
  ],
  TetrominoType.T: [
    [0, 1, 0],
    [1, 1, 1],
  ],
};

const startXy = {
  TetrominoType.I: [3, 0],
  TetrominoType.L: [4, -1],
  TetrominoType.J: [4, -1],
  TetrominoType.Z: [4, -1],
  TetrominoType.S: [4, -1],
  TetrominoType.O: [4, -1],
  TetrominoType.T: [4, -1],
};

const origin = {
  TetrominoType.I: [
    [1, -1],
    [-1, 1],
  ],
  TetrominoType.L: [
    [0, 0],
  ],
  TetrominoType.J: [
    [0, 0],
  ],
  TetrominoType.Z: [
    [0, 0],
  ],
  TetrominoType.S: [
    [0, 0],
  ],
  TetrominoType.O: [
    [0, 0],
  ],
  TetrominoType.T: [
    [0, 0],
    [0, 1],
    [1, -1],
    [-1, 0],
  ],
};

enum TetrominoType { I, L, J, Z, S, O, T }

class Tetromino {
  Tetromino(this.type, this.shape, this.xy, this.rotateIndex);
  factory Tetromino.getRandom() {
    final i = math.Random().nextInt(TetrominoType.values.length);
    return Tetromino.fromType(TetrominoType.values[i]);
  }

  factory Tetromino.fromType(TetrominoType type) {
    final shape = tetrominoShapes[type];
    return Tetromino(type, shape!, startXy[type]!, 0);
  }
  final TetrominoType type;
  final List<List<int>> shape;
  final List<int> xy;
  final int rotateIndex;

  Tetromino fall({int step = 1}) =>
      Tetromino(type, shape, [xy[0], xy[1] + step], rotateIndex);

  Tetromino right() => Tetromino(type, shape, [xy[0] + 1, xy[1]], rotateIndex);

  Tetromino left() => Tetromino(type, shape, [xy[0] - 1, xy[1]], rotateIndex);

  Tetromino rotate() {
    final List<List<int>> result = List.filled(shape[0].length, const []);
    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (result[col].isEmpty) {
          result[col] = List.filled(shape.length, 0);
        }
        result[col][row] = shape[shape.length - 1 - row][col];
      }
    }
    final nextXy = [
      xy[0] + origin[type]![rotateIndex][0],
      xy[1] + origin[type]![rotateIndex][1],
    ];
    final nextRotateIndex =
        rotateIndex + 1 >= origin[type]!.length ? 0 : rotateIndex + 1;

    return Tetromino(type, result, nextXy, nextRotateIndex);
  }

  bool isValidInMatrix(List<List<int>> matrix) {
    if (xy[1] + shape.length > gamePadMatrixH ||
        xy[0] < 0 ||
        xy[0] + shape[0].length > gamePadMatrixW) {
      return false;
    }
    for (var i = 0; i < matrix.length; i++) {
      final line = matrix[i];
      for (var j = 0; j < line.length; j++) {
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
    final x0 = x - xy[0];
    final y0 = y - xy[1];

    if (x0 < 0 || x0 >= shape[0].length || y0 < 0 || y0 >= shape.length) {
      return null;
    }
    return shape[y0][x0] == 1 ? 1 : null;
  }
}
