
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';

const kStatsLinesCompleted = 'linesCompleted';

class Smart extends Pajitnov {

  static const List kFeatures = [
    kStatsCountHoles,
    kStatsAvgHeight,
    kStatsMaxHeight,
    kStatsMaxHeightDiff,
    kStatsHeightStdDev
  ];

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
      int initialLines = game.linesCompleted;
      Game result = playMove(game, move, true, null);
      Stats stats = Stats.from(game: result);

      // lines completed
      stats.setValue(kStatsLinesCompleted, result.linesCompleted - initialLines);

      // calc score
      double score = 0;
      for (int i=0; i<kFeatures.length; i++) {
        score += phenotype.genes[i] * stats.getValue(kFeatures[i]);
      }

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
