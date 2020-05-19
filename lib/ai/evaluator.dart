
import 'package:darwin/darwin.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/genetic.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/ai/smart.dart';
import 'package:tetris/model/game.dart';

class TetrisEvaluator extends PhenotypeEvaluator<TetrisPhenotype, double, SingleObjectiveResult> {

  Game game;
  TetrisPhenotype _phenotype;
  MovePlaying callback;
  List<int> scores = List();
  int bestScore = 0;

  @override
  Future<SingleObjectiveResult> evaluate(TetrisPhenotype phenotype) async {

    // reset
    scores.clear();
    _phenotype = phenotype;

    // run 10 games
    Smart ai = Smart(phenotype: phenotype);
    while (true) {
      await Future.delayed(Duration(milliseconds: 5), () {
        ai.play(game, callback);
      });
      if (scores.length == Genetic.kRunsPerMember) {
        break;
      }
    }

    // return inverse of average as algorithm take the lowest
    final result = SingleObjectiveResult();
    result.value = 1000.0 / (1.0 + scores.reduce((a, b) => a + b).toDouble() / scores.length);
    return Future.value(result);
  }

  void gameFinished(Game game) {
    scores.add(game.linesCompleted);
    if (game.linesCompleted > bestScore) {
      print('BEST SO FAR : ${game.linesCompleted} with ${_phenotype.genes}');
      bestScore = game.linesCompleted;
    }
  }

}

