
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
  String _csvReport;

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
        print('Generation #${_algorithm.currentGeneration}');
        print('  - AVG ALL = ${TetrisEvaluator.fitnessToLines(gen.averageFitness)}');
        print('  - AVG BEST = ${TetrisEvaluator.fitnessToLines(gen.bestFitness)}');
        print('  - BEST GEN = ${_evaluator.bestScoreGeneration}');
        print('  - BEST EVER = ${_evaluator.bestScoreEver}');
        print('  - ELITE = ${gen.best.genes}');

        // csv
        _csvReport += '${_algorithm.currentGeneration},${TetrisEvaluator.fitnessToLines(gen.averageFitness)},${TetrisEvaluator.fitnessToLines(gen.bestFitness)},${_evaluator.bestScoreGeneration},${_evaluator.bestScoreEver}\n';

        // reset
        _evaluator.bestScoreGeneration = 0;

      });

      // run
      _algorithm.runUntilDone();

    }
  }

  @override
  void kill() {
    print('CSV REPORT${_csvReport}');
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
    int bestGeneration = _evaluator.bestScoreGeneration;
    int bestEver = _evaluator.bestScoreEver;

    // done
    return ' gen: $generation\n ind: $member\n exp: $experiment\nlast: $lastScore\n★ind: $maxScore\n★gen: $bestGeneration\n★evr: $bestEver';

  }

}
