
import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/force.dart';
import 'package:tetris/ai/genetic.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/ai/smart.dart';
import 'package:tetris/model/game.dart';

class TetrisEvaluator extends PhenotypeEvaluator<TetrisPhenotype, double, SingleObjectiveResult> {

  Game game;
  MovePlaying callback;
  List<int> scores = List();
  int bestScore = 0;

  @override
  Future<SingleObjectiveResult> evaluate(TetrisPhenotype phenotype) async {

    // reset
    scores.clear();

    // run 10 games
    Smart ai = Smart(phenotype: phenotype);
    while (true) {
      await Future.delayed(Duration(milliseconds: 1), () {
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
    bestScore = max(game.linesCompleted, bestScore);
  }

}

