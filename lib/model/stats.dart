import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/utils/number.dart';

const String kStatsCountHoles = 'countHoles';
const String kStatsMinHeight = 'minHeight';
const String kStatsMaxHeight = 'maxHeight';
const String kStatsAvgHeight = 'avgHeight';
const String kStatsMaxHeightDiff = 'maxHeightDiff';
const String kStatsHeightStdDev = 'stdHeight';

class Stats {

  // https://pdfs.semanticscholar.org/b0fe/1ed14404db2eb1db6a777961440723d6e06f.pdf?_ga=2.183710566.1551116755.1589937221-487702206.1589937221

  Map _values;

  num get numHoles => _values[kStatsCountHoles];
  num get minHeight => _values[kStatsMinHeight];
  num get maxHeight => _values[kStatsMaxHeight];
  num get maxDiffHeight => _values[kStatsMaxHeightDiff];
  num get avgHeight => _values[kStatsAvgHeight];
  num get heightSD => _values[kStatsHeightStdDev];

  num getValue(String name) {
    return _values[name];
  }

  setValue(String name, num value) {
    _values[name] = value;
  }

  Stats.from({
    @required Game game,
  }) {

    // init
    _values = Map();

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
    _values[kStatsCountHoles] = holes.reduce((a, b) => (a ?? 0) + (b ?? 0));

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
    _values[kStatsMinHeight] = heights.reduce(min);
    _values[kStatsMaxHeight] = heights.reduce(max);
    _values[kStatsAvgHeight] = heights.reduce((a, b) => a + b) / heights.length;

    // calc max diff
    _values[kStatsMaxHeightDiff] = 0;
    for (int i=1; i<heights.length; i++) {
      int diff = (heights[i]-heights[i-1]).abs();
      if (diff > _values[kStatsMaxHeightDiff]) {
        _values[kStatsMaxHeightDiff] = diff;
      }
    }

    // now cald sd
    double sumDiff2 = 0;
    for (int height in heights) {
      sumDiff2 = pow(height - _values[kStatsAvgHeight], 2);
    }
    _values[kStatsHeightStdDev] = NumberUtils.toPrecision(sqrt(sumDiff2 / heights.length), 4);
  }
}
