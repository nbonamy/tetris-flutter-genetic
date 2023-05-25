import 'package:darwin/darwin.dart';

import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/genetic.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/ai/result.dart';

import 'package:tetris/ai/smart.dart';
import 'package:tetris/model/game.dart';

class TetrisEvaluator
    extends PhenotypeEvaluator<TetrisPhenotype, double, TetrisLinesResult>
    implements TetrisEvaluatorAbstract {
  late Game game;
  bool _cancel = false;
  MovePlaying? callback;
  List<int> scores = [];

  @override
  Future<TetrisLinesResult> evaluate(TetrisPhenotype phenotype) async {
    // reset
    scores.clear();

    // run 10 games
    Smart ai = Smart(phenotype: phenotype);
    while (true) {
      await Future.delayed(Duration(microseconds: 100), () {
        ai.play(game, callback);
      });
      if (scores.length == Genetic.kRunsPerMember) {
        break;
      }
      if (_cancel) {
        final result = TetrisLinesResult();
        return Future.value(result);
      }
    }

    // return inverse of average as algorithm take the lowest
    final result = TetrisLinesResult();
    result.scores.addAll(scores);
    return Future.value(result);
  }

  void gameFinished(Game game) {
    scores.add(game.linesCompleted);
    if (game.linesCompleted > TetrisLinesResult.bestScoreEver) {
      //print('NEW BEST! ${game.linesCompleted} with ${_phenotype.genes}');
      TetrisLinesResult.bestScoreEver = game.linesCompleted;
    }
    if (game.linesCompleted > TetrisLinesResult.bestScoreGeneration) {
      TetrisLinesResult.bestScoreGeneration = game.linesCompleted;
    }
  }

  void kill() {
    _cancel = true;
  }
}
