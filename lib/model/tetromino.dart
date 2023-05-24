import 'package:tetris/model/tetrominos/i.dart';
import 'package:tetris/model/tetrominos/j.dart';
import 'package:tetris/model/tetrominos/l.dart';
import 'package:tetris/model/tetrominos/o.dart';
import 'package:tetris/model/tetrominos/s.dart';
import 'package:tetris/model/tetrominos/t.dart';
import 'package:tetris/model/tetrominos/z.dart';

enum TetrominoType { o, i, t, s, z, j, l }

enum Rotation {
  Normal,
  ThreeOClock,
  SixOClock,
  NineOClock,
}

abstract class Tetromino {
  int x;
  int y;
  Rotation rotation;

  Tetromino({
    this.x = 0,
    this.y = 0,
    this.rotation = Rotation.Normal,
  });

  static List<Tetromino> all() {
    return [
      TetrominoO(),
      TetrominoI(),
      TetrominoT(),
      TetrominoS(),
      TetrominoZ(),
      TetrominoJ(),
      TetrominoL(),
    ];
  }

  TetrominoType get type;
  int get width;
  int get height;

  Tetromino? clone() {
    Tetromino clone;
    switch (this.type) {
      case TetrominoType.o:
        clone = TetrominoO();
        break;
      case TetrominoType.i:
        clone = TetrominoI();
        break;
      case TetrominoType.t:
        clone = TetrominoT();
        break;
      case TetrominoType.s:
        clone = TetrominoS();
        break;
      case TetrominoType.z:
        clone = TetrominoZ();
        break;
      case TetrominoType.j:
        clone = TetrominoJ();
        break;
      case TetrominoType.l:
        clone = TetrominoL();
        break;
      default:
        return null;
    }

    // copy
    clone.x = this.x;
    clone.y = this.y;
    clone.rotation = this.rotation;

    // done
    return clone;
  }

  List<List<TetrominoType?>> get blocks;

  void rotate() {
    switch (this.rotation) {
      case Rotation.Normal:
        this.rotation = Rotation.ThreeOClock;
        break;
      case Rotation.ThreeOClock:
        this.rotation = Rotation.SixOClock;
        break;
      case Rotation.SixOClock:
        this.rotation = Rotation.NineOClock;
        break;
      case Rotation.NineOClock:
        this.rotation = Rotation.Normal;
        break;
    }
  }
}
