
import 'dart:collection';
import 'package:tetris/model/piece.dart';

class Board {

  final int width;
  final int height;

  List<Piece> _pieces;

  Board({
    this.width = 10,
    this.height = 20,
  }) {
    this._pieces = List();
  }

  UnmodifiableListView<Piece> get pieces {
    return UnmodifiableListView(this._pieces);
  }

}
