
import 'package:tetris/model/tetromino.dart';

class TetrominoI extends Tetromino {

  @override
  TetrominoType get type => TetrominoType.i;

  @override
  int get height {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
      return 1;
    } else {
      return 4;
    }
  }

  @override
  int get width {
    return 5 - this.height;
  }

  @override
  List<List<TetrominoType>> get blocks {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
      return [ [type,type,type,type] ];
    } else {
      return [ [type], [type], [type], [type] ];
    }
  }

  @override
  void rotate() {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
      this.x++;
    } else {
      this.x--;
    }
    super.rotate();
  }

}
