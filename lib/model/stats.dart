import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/model/game.dart';

class Stats {
  int _holes;
  int _minHeight;
  int _maxHeight;
  double _avgHeight;
  double _heightSD;

  int get numHoles => _holes;
  int get minHeight => _minHeight;
  int get maxHeight => _maxHeight;
  double get avgHeight => _avgHeight;
  double get heightSD => _heightSD;

  Stats.from({
    @required Game game,
  }) {
    // based on
    List<List<Color>> state = game.getBoardState(false);

    // holes
    List<int> holes = List.generate(game.board.width, (_) => null);
    for (int j = 0; j < game.board.height; j++) {
      List<Color> row = state[j];
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
      List<Color> row = state[j];
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

    // now cald sd
    double sumDiff2 = 0;
    for (int height in heights) {
      sumDiff2 = pow(height - _avgHeight, 2);
    }
    _heightSD = sqrt(sumDiff2 / heights.length).toPrecision(4);
  }
}

extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}
