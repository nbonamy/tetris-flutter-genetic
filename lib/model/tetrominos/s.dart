
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/model/tetromino.dart';

class PieceS extends Tetromino {

  @override
  PieceType get type => PieceType.s;

  @override
  Color get color => Colors.orange;

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
  List<List<bool>> get blocks {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
      return [ [false,true,true], [true,true,false] ];
    } else {
      return [ [true,false], [true,true], [false,true] ];
    }
  }

}
