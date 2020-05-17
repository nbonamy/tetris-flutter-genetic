
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/model/piece.dart';

class PieceJ extends Piece {

  @override
  PieceType get type => PieceType.j;

  @override
  Color get color => Colors.pink;

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
        return [ [false,true], [false,true], [true,true] ];
      case Rotation.SixOClock:
        return [ [true,false,false], [true,true,true] ];
      case Rotation.NineOClock:
        return [ [true,true], [true,false], [true,false] ];
      default:
        return [ [true,true,true], [false,false,true] ];
    }
  }

}
