
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/model/tetromino.dart';

class TetrominoT extends Tetromino {

  @override
  TetrominoType get type => TetrominoType.t;

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
  List<List<TetrominoType>> get blocks {
    switch (this.rotation) {
      case Rotation.ThreeOClock:
        return [ [type,null], [type,type], [type,null] ];
      case Rotation.SixOClock:
        return [ [type,type,type], [null,type,null] ];
      case Rotation.NineOClock:
        return [ [null,type], [type,type], [null,type] ];
      default:
      return [ [null,type,null], [type,type,type] ];
    }
  }

}
