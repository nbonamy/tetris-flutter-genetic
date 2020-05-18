import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/model/game.dart';

class Stats {
  int _minHeight;
  int _maxHeight;
  double _avgHeight;
  double _heightSD;

  int get minHeight => _minHeight;
  int get maxHeight => _maxHeight;
  double get avgHeight => _avgHeight;
  double get heightSD => _heightSD;

  Stats.from({
    @required Game game,
  }) {
    // height of each column
    List<int> heights = List.generate(game.board.width, (_) => 0);

    // based on
    List<List<Color>> state = game.getBoardState(false);
    for (int j = state.length - 1; j >= 0; j--) {
      List<Color> row = state[j];
      for (int i = 0; i < row.length; i++) {
        if (row[i] != null) {
          heights[i] = game.board.height - j;
        }
      }
    }

    // now get
    _minHeight = heights.reduce(min);
    _maxHeight = heights.reduce(max);
    _avgHeight = heights.reduce((a, b) => a + b) / heights.length;

    // now cald sd
    double sumDiff2 = 0;
    for (int height in heights) {
      sumDiff2 = pow(height - _avgHeight, 2);
    }
    _heightSD = sqrt(sumDiff2 / heights.length);
  }
}
