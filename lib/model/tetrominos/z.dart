
import 'package:tetris/model/tetromino.dart';

class TetrominoZ extends Tetromino {

  @override
  TetrominoType get type => TetrominoType.z;

  @override
  int get height {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
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
  List<List<TetrominoType>> get blocks {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
      return [ [type,type,null], [null,type,type] ];
    } else {
      return [ [null,type], [type,type], [type,null] ];
    }
  }

}
