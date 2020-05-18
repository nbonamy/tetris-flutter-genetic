
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/model/tetromino.dart';

class PieceL extends Tetromino {

  @override
  PieceType get type => PieceType.l;

  @override
  Color get color => Colors.yellow;

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
    switch (this.rotation) {
      case Rotation.ThreeOClock:
        return [ [true,true], [false,true], [false,true] ];
      case Rotation.SixOClock:
        return [ [false,false,true], [true,true,true] ];
      case Rotation.NineOClock:
        return [ [true,false], [true,false], [true,true] ];
      default:
        return [ [true,true,true], [true,false,false] ];
    }
  }


}
