import 'dart:math';

import 'package:tetris/ai/ai.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';
import 'package:tetris/utils/number.dart';

class BruteForce extends Pajitnov with MovePlayer {
  List<int> _linesCount = [];

  @override
  Move? selectMove(Game game, List<Move> moves) {
    // init
    Move? bestMove;
    int bestLines = 0;
    int bestDiffHeight = game.board.height;
    int bestHoles = game.board.width * game.board.height + 1;

    // test each move
    moves.shuffle();
    for (Move move in moves) {
      // play
      int initialLines = game.linesCompleted;
      Game? result = playMove(game, move, true, null);
      Stats stats = Stats.from(game: result!);
      int linesCompleted = result.linesCompleted - initialLines;

      // select
      bool best = false;
      if (linesCompleted > bestLines) {
        best = true;
      } else if (linesCompleted == bestLines) {
        if (stats.totalHoles < bestHoles) {
          best = true;
        } else if (stats.totalHoles == bestHoles) {
          if (stats.maxDiffHeight <= bestDiffHeight) {
            best = true;
          }
        }
      }

      // select
      if (best) {
        bestHoles = stats.totalHoles.toInt();
        bestDiffHeight = stats.maxDiffHeight.toInt();
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
    super.onGameFinished(game);
  }

  @override
  String getInfo() {
    // need data
    if (_linesCount.isEmpty) {
      return '';
    }

    // get some values
    int numScores = _linesCount.length;
    int lastScore = _linesCount.last;
    int worstScore = _linesCount.reduce(min);
    int bestScore = _linesCount.reduce(max);
    double avgScore = NumberUtils.toPrecision(
        _linesCount.reduce((a, b) => a + b) / _linesCount.length, 2);

    // done
    return ' cnt: $numScores\nlast: $lastScore\nhigh: $bestScore\n low: $worstScore\n avg: $avgScore';
  }
}
