
import 'package:flutter/material.dart';
import 'package:tetris/model/tetromino.dart';

class TetrominoO extends Tetromino {

  @override
  TetrominoType get type => TetrominoType.o;

  @override
  Color get color => Colors.blue;

  @override
  int get height => 2;

  @override
  int get width => 2;

  @override
  List<List<TetrominoType>> get blocks {
    return [ [type,type], [type,type] ];
  }

}
