
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/model/piece.dart';

class PieceT extends Piece {

  @override
  PieceType get type => PieceType.t;

  @override
  Color get color => Colors.grey;

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
        return [ [true,false], [true,true], [true,false] ];
      case Rotation.SixOClock:
        return [ [true,true,true], [false,true,false] ];
      case Rotation.NineOClock:
        return [ [false,true], [true,true], [false,true] ];
      default:
      return [ [false,true,false], [true,true,true] ];
    }
  }

}
