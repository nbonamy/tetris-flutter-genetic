
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/model/piece.dart';

class PieceZ extends Piece {

  @override
  PieceType get type => PieceType.z;

  @override
  Color get color => Colors.green;

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
      return [ [true,true,false], [false,true,true] ];
    } else {
      return [ [false,true], [true,true], [true,false] ];
    }
  }

}
