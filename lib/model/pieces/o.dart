
import 'package:flutter/material.dart';
import 'package:tetris/model/piece.dart';

class PieceO extends Piece {

  @override
  PieceType get type => PieceType.o;

  @override
  Color get color => Colors.blue;

  @override
  int get height => 2;

  @override
  int get width => 2;

  @override
  List<List<bool>> get blocks {
    return [ [true,true], [true,true] ];
  }

}