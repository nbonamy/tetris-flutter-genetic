
import 'package:tetris/model/tetromino.dart';

class TetrominoJ extends Tetromino {

  @override
  TetrominoType get type => TetrominoType.j;

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
    switch (this.rotation) {
      case Rotation.ThreeOClock:
        return [ [null,type], [null,type], [type,type] ];
      case Rotation.SixOClock:
        return [ [type,null,null], [type,type,type] ];
      case Rotation.NineOClock:
        return [ [type,type], [type,null], [type,null] ];
      default:
        return [ [type,type,type], [null,null,type] ];
    }
  }

}
