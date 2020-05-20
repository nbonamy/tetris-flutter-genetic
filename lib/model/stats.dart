import 'dart:math';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/utils/number.dart';

const String kStatsMinHeight = 'minHeight';
const String kStatsMaxHeight = 'maxHeight';
const String kStatsAvgHeight = 'avgHeight';
const String kStatsTotalHeightDiff = 'totalHeightDiff';
const String kStatsMaxHeightDiff = 'maxHeightDiff';
const String kStatsHeightStdDev = 'stdHeight';
const String kStatsTotalBlocks = 'totalBlocks';
const String kStatsWeightedBlocks = 'weightedBlocks';
const String kStatsTotalHoles = 'totalHoles';
const String kStatsWeightedHoles = 'weightedHoles';
const String kStatsConnectedHoles = 'connectedHoles';
const String kStatsMaxWell = 'maxWell';
const String kStatsSumWells = 'sumWells';

class Stats {
  // https://pdfs.semanticscholar.org/b0fe/1ed14404db2eb1db6a777961440723d6e06f.pdf?_ga=2.183710566.1551116755.1589937221-487702206.1589937221

  Map _values;

  num get minHeight => _values[kStatsMinHeight];
  num get maxHeight => _values[kStatsMaxHeight];
  num get maxDiffHeight => _values[kStatsMaxHeightDiff];
  num get avgHeight => _values[kStatsAvgHeight];
  num get heightSD => _values[kStatsHeightStdDev];
  num get totalBlocks => _values[kStatsTotalBlocks];
  num get weightedBlocks => _values[kStatsWeightedBlocks];
  num get totalHoles => _values[kStatsTotalHoles];
  num get weightedHoles => _values[kStatsWeightedHoles];
  num get connectedHoles => _values[kStatsConnectedHoles];
  num get maxWell => _values[kStatsMaxWell];
  num get sumWells => _values[kStatsSumWells];

  num getValue(String name) {
    return _values[name];
  }

  setValue(String name, num value) {
    _values[name] = value;
  }

  Stats.from({
    Game game,
  }) {
    // init
    _values = Map();

    // based on
    List<List<TetrominoType>> state = game.getBoardState(false);

    // holes
    int totalBlocks = 0;
    int weightedBlocks = 0;
    int totalHoles = 0;
    int weightedHoles = 0;
    int connectedHoles = 0;
    for (int i = 0; i < game.board.width; i++) {
      bool topFound = false;
      bool blockFound = false;
      for (int j = 0; j < game.board.height; j++) {
        int height = game.board.height - j;
        if (state[j][i] != null) {
          topFound = true;
          blockFound = true;
          totalBlocks++;
          weightedBlocks += height;
        } else if (topFound) {
          totalHoles++;
          weightedHoles += height;
          if (blockFound) {
            connectedHoles++;
          }
          blockFound = false;
        }
      }
    }

    // store
    _values[kStatsTotalBlocks] = totalBlocks;
    _values[kStatsWeightedBlocks] = weightedBlocks;
    _values[kStatsTotalHoles] = totalHoles;
    _values[kStatsWeightedHoles] = weightedHoles;
    _values[kStatsConnectedHoles] = connectedHoles;

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
    _values[kStatsTotalHeightDiff] = _values[kStatsMaxHeight] - _values[kStatsMinHeight];

    // calc max diff
    _values[kStatsMaxHeightDiff] = 0;
    for (int i = 1; i < heights.length; i++) {
      int diff = (heights[i] - heights[i - 1]).abs();
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

    // now wells
    _values[kStatsMaxWell] = 0;
    _values[kStatsSumWells] = 0;
    for (int i = 0; i < heights.length; i++) {

      int height = heights[i];
      int left = (i==0) ? heights[i] : heights[i-1];
      int right = (i==heights.length-1) ? heights[i] : heights[i+1];
      int well = min(height - left, height - right);
      if (well < 0) {
        _values[kStatsSumWells] -= well;
        if (-well > _values[kStatsMaxWell]) {
          _values[kStatsMaxWell] = -well;
        }
      }
    }

  }
}
