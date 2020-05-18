
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/model/tetromino.dart';

class PieceI extends Tetromino {

  @override
  PieceType get type => PieceType.i;

  @override
  Color get color => Colors.red;

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
  List<List<bool>> get blocks {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
      return [ [true,true,true,true] ];
    } else {
      return [ [true], [true], [true], [true] ];
    }
  }

  @override
  rotate() {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
      this.x++;
    } else {
      this.x--;
    }
    super.rotate();
  }

}
