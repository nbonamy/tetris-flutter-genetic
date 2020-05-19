
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';

class Smart extends Pajitnov {

  static const int kGenesCount = 6;

  final TetrisPhenotype phenotype;
  Smart({
    this.phenotype,
  });

  @override
  Move selectMove(Game game, List<Move> moves) {

    // init
    Move bestMove;
    double bestScore;

    // test each move
    moves.shuffle();
    for (Move move in moves) {

      // play
      int initialLines = game.linesCompleted;
      Game result = playMove(game, move, true, null);
      Stats stats = Stats.from(game: result);
      int linesCompleted = result.linesCompleted - initialLines;

      // calc score
      double score =
        phenotype.genes[0] * linesCompleted +
        phenotype.genes[1] * stats.numHoles +
        phenotype.genes[2] * stats.minHeight +
        phenotype.genes[3] * stats.maxHeight +
        phenotype.genes[4] * stats.heightDiff +
        phenotype.genes[5] * stats.heightSD;

      // best
      if (bestScore == null || score > bestScore) {
        bestMove = move;
        bestScore = score;
      }

    }

    // done
    return bestMove;
  }

}
