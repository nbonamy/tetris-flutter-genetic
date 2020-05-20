
import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/evaluator.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/model/game.dart';

class GeneticInfo {
  int currGeneration;
  int currIndividual;
  int currExperiment;
  int lastScoreInd;
  int bestScoreInd;
  int bestScoreGen;
  int bestScoreEver;
}

class Genetic extends Pajitnov {

  static const int kMembersPerGeneration = 5;
  static const int kRunsPerMember = 5;

  GeneticAlgorithm _algorithm;
  Generation _firstGeneration;
  TetrisEvaluator _evaluator;
  GenerationBreeder _breeder;
  String _csvReport;

  PrintFunction printf = print;

  Genetic() {

    // init 1st generation
    _firstGeneration = Generation<TetrisPhenotype, double, SingleObjectiveResult>()
      ..members.addAll(List.generate(kMembersPerGeneration, (i) => TetrisPhenotype.random(i)));

    // evaluator
    _evaluator = TetrisEvaluator();

    // breeder
    _breeder = GenerationBreeder<TetrisPhenotype, double, SingleObjectiveResult>(
      () => TetrisPhenotype())
      ..elitismCount = max(1, (kMembersPerGeneration * 0.05).round())
      ..crossoverPropability = 0.8;

    // init
    _csvReport = '\n';

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
        printf: (_) {},
        statusf: (_) {},
      );

      // report
      _algorithm.onGenerationEvaluated.listen((gen) {

        // aborted
        if (_algorithm.MAX_EXPERIMENTS == 1) {
          return;
        }

        // print our own status
        printf('Generation #${_algorithm.currentGeneration}');
        printf('  - AVG ALL = ${TetrisEvaluator.fitnessToLines(gen.averageFitness)}');
        printf('  - AVG BEST = ${TetrisEvaluator.fitnessToLines(gen.bestFitness)}');
        printf('  - BEST GEN = ${_evaluator.bestScoreGeneration}');
        printf('  - BEST EVER = ${_evaluator.bestScoreEver}');
        printf('  - ELITE = ${gen.best.genes}');

        // csv
        _csvReport += '${_algorithm.currentGeneration},${TetrisEvaluator.fitnessToLines(gen.averageFitness)},${TetrisEvaluator.fitnessToLines(gen.bestFitness)},${_evaluator.bestScoreGeneration},${_evaluator.bestScoreEver}\n';

        // reset
        _evaluator.bestScoreGeneration = 0;

      });

      // log
      printf('START = ${DateTime.now()}');
      printf('ELITE = ${_breeder.elitismCount}');

      // run
      _algorithm.runUntilDone();

    }
  }

  @override
  void kill() {
    print('CSV REPORT$_csvReport');
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

    // check
    GeneticInfo info = getGeneticInfo();
    if (info == null) {
      return '';
    }

    // done
    return ' gen: ${info.currGeneration ?? '-'}\n ind: ${info.currIndividual ?? '-'}\n exp: ${info.currExperiment+1}\nlast: ${info.lastScoreInd ?? '-'}\n★ind: ${info.bestScoreInd ?? '-'}\n★gen: ${info.bestScoreGen ?? '-'}\n★evr: ${info.bestScoreEver ?? '-'}';

  }

  GeneticInfo getGeneticInfo() {

    // check
    if (_algorithm == null) {
      return null;
    }

    // build
    GeneticInfo info = GeneticInfo();
    info.currGeneration = (_algorithm.currentGeneration ?? -1) + 1;
    info.currIndividual = (_algorithm.memberIndex ?? - 1) + 1;
    info.currExperiment = _evaluator.scores.length;
    info.lastScoreInd =  _evaluator.scores.isEmpty ? null : _evaluator.scores.last;
    info.bestScoreInd = _evaluator.scores.isEmpty ? null : _evaluator.scores.reduce(max);
    info.bestScoreGen = _evaluator.bestScoreGeneration;
    info.bestScoreEver = _evaluator.bestScoreEver;
    return info;

  }

}
