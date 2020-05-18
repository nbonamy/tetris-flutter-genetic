
import 'dart:math' as math;

import 'package:scidart/numdart.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';
import 'package:tetris/utils/number.dart';

class BruteForce extends Pajitnov {

  List<int> _linesCount = List();

  @override
  Move selectMove(Game game, List<Move> moves) {

    // init
    Move bestMove;
    int bestLines = 0;
    int bestDiffHeight = game.board.height;
    int bestHoles = game.board.width * game.board.height + 1;

    // test each move
    moves.shuffle();
    for (Move move in moves) {

      // play
      int initialLines = game.linesCompleted;
      Game result = playMove(game, move, true, null);
      Stats stats = Stats.from(game: result);
      int linesCompleted = result.linesCompleted - initialLines;

      // select
      bool best = false;
      if (linesCompleted > bestLines) {
        best = true;
      } else if (linesCompleted == bestLines) {
        if (stats.numHoles < bestHoles) {
          best = true;
        } else if (stats.numHoles == bestHoles) {
          if (stats.heightDiff <= bestDiffHeight) {
            best = true;
          }
        }
      }

      // select
      if (best) {
        bestHoles = stats.numHoles;
        bestDiffHeight = stats.heightDiff;
        bestLines = linesCompleted;
        bestMove = move;
      }

    }

    // done
    return bestMove;
  }

  @override
  void onGameFinished(Game game) {
    _linesCount.add(game.linesCompleted);
  }

  @override
  String getInfo() {

    // need data
    if (_linesCount.isEmpty) {
      return null;
    }

    // get some values
    int lastValue = _linesCount.last;
    int worstValue = _linesCount.reduce(math.min);
    int bestValue = _linesCount.reduce(math.max);
    double avgValue = NumberUtils.toPrecision(_linesCount.reduce((a, b) => a + b) / _linesCount.length, 2);
    double medianValue = median(Array(List.generate(_linesCount.length, (i) => _linesCount[i].toDouble())));

    // done
    return 'last: $lastValue\nhigh: $bestValue\n low: $worstValue\n avg: $avgValue\n med: $medianValue';

  }

}
