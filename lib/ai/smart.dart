
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';

class Smart extends Pajitnov {

  static const int kGenesCount = 5;

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
    //moves.shuffle();
    for (Move move in moves) {

      // play
      //int initialLines = game.linesCompleted;
      Game result = playMove(game, move, true, null);
      Stats stats = Stats.from(game: result);
      //int linesCompleted = result.linesCompleted - initialLines;

      // calc score
      int i = 0;
      double score =
        //phenotype.genes[i++] * linesCompleted +
        phenotype.genes[i++] * stats.numHoles +
        phenotype.genes[i++] * stats.avgHeight +
        phenotype.genes[i++] * stats.maxHeight +
        phenotype.genes[i++] * stats.maxDiffHeight +
        phenotype.genes[i++] * stats.heightSD;

      // best
      if (bestScore == null || score < bestScore) {
        bestMove = move;
        bestScore = score;
      }

    }

    // done
    return bestMove;
  }

}
