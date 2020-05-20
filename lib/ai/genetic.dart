
import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/evaluator.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/model/game.dart';

class Genetic extends Pajitnov {

  static const int kMembersPerGeneration = 25;
  static const int kRunsPerMember = 10;

  GeneticAlgorithm _algorithm;
  Generation _firstGeneration;
  TetrisEvaluator _evaluator;
  GenerationBreeder _breeder;

  Genetic() {

    // init 1st generation
    _firstGeneration = Generation<TetrisPhenotype, double, SingleObjectiveResult>()
      ..members.addAll(List.generate(kMembersPerGeneration, (i) => TetrisPhenotype.random(i)));

    // evaluator
    _evaluator = TetrisEvaluator();

    // breeder
    _breeder = GenerationBreeder<TetrisPhenotype, double, SingleObjectiveResult>(
      () => TetrisPhenotype())
      ..crossoverPropability = 0.8;

  }

  @override
  void play(Game game, MovePlaying callback) async {

    // record for evaluator
    _evaluator.game = game;
    _evaluator.callback = callback;

    // we need to do this only once
    if (_algorithm == null) {

      // create
      _algorithm = GeneticAlgorithm<TetrisPhenotype, double, SingleObjectiveResult>(
        _firstGeneration,
        _evaluator,
        _breeder,
      );

      // run
      _algorithm.runUntilDone();

    }
  }

  @override
  void kill() {
    _algorithm.MAX_EXPERIMENTS = 1;
    _evaluator.kill();
  }

  @override
  Move selectMove(Game game, List<Move> moves) {
    return null;
  }

  @override
  void onGameFinished(Game game) {
    _evaluator.gameFinished(game);
    super.onGameFinished(game);
  }

  @override
  String getInfo() {

    // get value
    int generation = (_algorithm.currentGeneration ?? -1) + 1;
    int member = (_algorithm.memberIndex ?? - 1) + 1;
    int experiment = _evaluator.scores.length + 1;
    String lastScore = _evaluator.scores.isEmpty ? '-' : _evaluator.scores.last.toString();
    String maxScore = _evaluator.scores.isEmpty ? '-' : _evaluator.scores.reduce(max).toString();
    int bestScore = _evaluator.bestScore;

    // done
    return ' gen: $generation\n ind: $member\n exp: $experiment\nlast: $lastScore\nbest: $maxScore\never: $bestScore';

  }

}
