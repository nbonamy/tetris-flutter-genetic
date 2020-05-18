
enum TetrominoType {
  o,
  i,
  t,
  s,
  z,
  j,
  l
}

enum Rotation {
  Normal,
  ThreeOClock,
  SixOClock,
  NineOClock,
}

abstract class Tetromino {

  int x;
  int y;
  Rotation _rotation;

  Tetromino({
    this.x = 0,
    this.y = 0,
  }) {
    this._rotation = Rotation.Normal;
  }

  TetrominoType get type;
  int get width;
  int get height;

  List<List<TetrominoType>> get blocks;

  Rotation get rotation => _rotation;

  set rotation(Rotation rot) {
    this._rotation = rot;
  }

  static Rotation rotateCW(Rotation rotation) {
    switch (rotation) {
      case Rotation.Normal:
        return Rotation.ThreeOClock;
      case Rotation.ThreeOClock:
        return Rotation.SixOClock;
      case Rotation.SixOClock:
        return Rotation.NineOClock;
      default:
        return Rotation.Normal;
    }
  }

}
