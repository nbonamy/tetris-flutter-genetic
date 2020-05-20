
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';
import 'package:tetris/model/tetromino.dart';

const kStatsLinesCompleted = 'linesCompleted';
const kStatsLastTetroHeight = 'tetrominoHeight';

class Smart extends Pajitnov {

  // https://pdfs.semanticscholar.org/b0fe/1ed14404db2eb1db6a777961440723d6e06f.pdf?_ga=2.183710566.1551116755.1589937221-487702206.1589937221
  static const List kFeatures = [
    kStatsMaxHeight,          // 1
    kStatsTotalHoles,         // 2
    kStatsConnectedHoles,     // 3
    kStatsLinesCompleted,     // 4
    kStatsTotalHeightDiff,    // 5
    kStatsMaxWell,            // 6
    kStatsSumWells,           // 7
    kStatsLastTetroHeight,    // 8
    kStatsTotalBlocks,        // 9
    kStatsWeightedBlocks,     // 10
    kStatsWeightedHoles,
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
      Tetromino currentTetromino = game.currentTetromino;
      Game result = playMove(game, move, true, null);
      Stats stats = Stats.from(game: result);

      // custom stats
      stats.setValue(kStatsLinesCompleted, result.linesCompleted - initialLines);
      stats.setValue(kStatsLastTetroHeight, currentTetromino.y);

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
