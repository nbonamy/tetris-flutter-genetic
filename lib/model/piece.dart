
import 'package:flutter/material.dart';

enum PieceType {
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

abstract class Piece {

  int x;
  int y;
  Rotation rotation;

  Piece({
    this.x = 0,
    this.y = 0,
    this.rotation = Rotation.Normal,
  });

  PieceType get type;
  Color get color;
  int get width;
  int get height;

  List<List<bool>> get blocks;

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
