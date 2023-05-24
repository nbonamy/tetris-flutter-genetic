import 'package:tetris/model/tetromino.dart';

class TetrominoL extends Tetromino {
  @override
  TetrominoType get type => TetrominoType.l;

  @override
  int get height {
    if (this.rotation == Rotation.Normal ||
        this.rotation == Rotation.SixOClock) {
      return 2;
    } else {
      return 3;
    }
  }

  @override
  int get width {
    return 5 - this.height;
  }

  @override
  List<List<TetrominoType?>> get blocks {
    switch (this.rotation) {
      case Rotation.ThreeOClock:
        return [
          [type, type],
          [null, type],
          [null, type]
        ];
      case Rotation.SixOClock:
        return [
          [null, null, type],
          [type, type, type]
        ];
      case Rotation.NineOClock:
        return [
          [type, null],
          [type, null],
          [type, type]
        ];
      default:
        return [
          [type, type, type],
          [type, null, null]
        ];
    }
  }
}
