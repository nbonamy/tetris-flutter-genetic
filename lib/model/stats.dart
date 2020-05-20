import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/utils/number.dart';

class Stats {
  int _holes;
  int _minHeight;
  int _maxHeight;
  int _maxDiffHeight;
  double _avgHeight;
  double _heightSD;

  int get numHoles => _holes;
  int get minHeight => _minHeight;
  int get maxHeight => _maxHeight;
  int get maxDiffHeight => _maxDiffHeight;
  double get avgHeight => _avgHeight;
  double get heightSD => _heightSD;

  Stats.from({
    @required Game game,
  }) {
    // based on
    List<List<TetrominoType>> state = game.getBoardState(false);

    // holes
    List<int> holes = List.generate(game.board.width, (_) => null);
    for (int j = 0; j < game.board.height; j++) {
      List<TetrominoType> row = state[j];
      for (int i = 0; i < row.length; i++) {
        if (row[i] == null) {
          if (holes[i] != null) {
            holes[i]++;
          }
        } else if (holes[i] == null) {
          holes[i] = 0;
        }
      }
    }

    // calc holes
    _holes = holes.reduce((a, b) => (a ?? 0) + (b ?? 0));

    // height of each column
    List<int> heights = List.generate(game.board.width, (_) => 0);
    for (int j = 0; j < game.board.height; j++) {
      List<TetrominoType> row = state[j];
      for (int i = 0; i < row.length; i++) {
        if (row[i] != null && heights[i] == 0) {
          heights[i] = game.board.height - j;
        }
      }
    }

    // now get
    _minHeight = heights.reduce(min);
    _maxHeight = heights.reduce(max);
    _avgHeight = heights.reduce((a, b) => a + b) / heights.length;

    // calc max diff
    _maxDiffHeight = 0;
    for (int i=1; i<heights.length; i++) {
      int diff = (heights[i]-heights[i-1]).abs();
      if (diff > _maxDiffHeight) {
        _maxDiffHeight = diff;
      }
    }

    // now cald sd
    double sumDiff2 = 0;
    for (int height in heights) {
      sumDiff2 = pow(height - _avgHeight, 2);
    }
    _heightSD = NumberUtils.toPrecision(sqrt(sumDiff2 / heights.length), 4);
  }
}
