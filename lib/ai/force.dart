
import 'package:tetris/ai/ai.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';

class BruteForce extends Pajitnov {

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

}
