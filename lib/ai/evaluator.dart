
import 'package:darwin/darwin.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/genetic.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/ai/smart.dart';
import 'package:tetris/model/game.dart';

class TetrisEvaluator extends PhenotypeEvaluator<TetrisPhenotype, double, SingleObjectiveResult> {

  Game game;
  bool _cancel = false;
  MovePlaying callback;
  TetrisPhenotype _phenotype;
  List<int> scores = List();
  int bestScoreGeneration = 0;
  int bestScoreEver = 0;

  static double linesToFitness(double lines) {
    return 1000.0 / (1.0 + lines);
  }

  static int fitnessToLines(double fitness) {
    return (1000.0 / fitness).round() - 1;
  }

  @override
  Future<SingleObjectiveResult> evaluate(TetrisPhenotype phenotype) async {

    // reset
    scores.clear();
    _phenotype = phenotype;

    // run 10 games
    Smart ai = Smart(phenotype: phenotype);
    while (true) {
      await Future.delayed(Duration(milliseconds: 10), () {
        ai.play(game, callback);
      });
      if (scores.length == Genetic.kRunsPerMember) {
        break;
      }
      if (_cancel) {
        final result = SingleObjectiveResult();
        result.value = 0;
        return Future.value(result);
      }
    }

    // return inverse of average as algorithm take the lowest
    final result = SingleObjectiveResult();
    result.value = TetrisEvaluator.linesToFitness(scores.reduce((a, b) => a + b).toDouble() / scores.length);
    return Future.value(result);
  }

  void gameFinished(Game game) {
    scores.add(game.linesCompleted);
    if (game.linesCompleted > bestScoreEver) {
      //print('NEW BEST! ${game.linesCompleted} with ${_phenotype.genes}');
      bestScoreEver = game.linesCompleted;
    }
    if (game.linesCompleted > bestScoreGeneration) {
      bestScoreGeneration = game.linesCompleted;
    }
  }

  void kill() {
    _cancel = true;
  }

}

