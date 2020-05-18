
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/model/tetromino.dart';

class TetrominoS extends Tetromino {

  @override
  TetrominoType get type => TetrominoType.s;

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
  List<List<TetrominoType>> get blocks {
    if (this.rotation == Rotation.Normal || this.rotation == Rotation.SixOClock) {
      return [ [null,type,type], [type,type,null] ];
    } else {
      return [ [type,null], [type,type], [null,type] ];
    }
  }

}
