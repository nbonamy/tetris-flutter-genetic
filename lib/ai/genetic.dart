import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/evaluator.dart';
import 'package:tetris/ai/evaluator_mt.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/ai/result.dart';
import 'package:tetris/model/game.dart';

import '../utils/consts.dart';

class GeneticInfo {
  final int currGeneration;
  final int currIndividual;
  final int currExperiment;
  final int lastScoreInd;
  final int bestScoreInd;
  final int bestScoreGen;
  final int bestScoreEver;

  GeneticInfo({
    required this.currGeneration,
    required this.currIndividual,
    required this.currExperiment,
    required this.lastScoreInd,
    required this.bestScoreInd,
    required this.bestScoreGen,
    required this.bestScoreEver,
  });
}

abstract class TetrisEvaluatorAbstract<TetrisPhenotype, double,
    TetrisLinesResult> {
  set game(Game _);
  set callback(MovePlaying? _);
  List<int>? get scores;
  void gameFinished(Game game) {}
  void kill() {}
}

class Genetic extends Pajitnov with MovePlayer {
  GeneticAlgorithm? _algorithm;
  late Generation<TetrisPhenotype, double, TetrisLinesResult> _firstGeneration;
  late TetrisEvaluatorAbstract _evaluator;
  late GenerationBreeder<TetrisPhenotype, double, TetrisLinesResult> _breeder;

  String _csvReport = '';

  PrintFunction printf = print;

  Genetic(bool multithread) {
    // init 1st generation
    _firstGeneration = Generation<TetrisPhenotype, double, TetrisLinesResult>()
      ..members.addAll(List.generate(
          Consts.kMembersPerGeneration, (i) => TetrisPhenotype.random(i)));

    // evaluator
    if (multithread) {
      _evaluator = TetrisEvaluatorMT();
    } else {
      _evaluator = TetrisEvaluator();
    }

    // breeder
    _breeder = GenerationBreeder<TetrisPhenotype, double, TetrisLinesResult>(
        () => TetrisPhenotype())
      ..elitismCount =
          max(1, (Consts.kMembersPerGeneration * Consts.kElitism).round())
      ..mutationRate = Consts.kMutationRate
      ..crossoverProbability = Consts.kCrossoverProbability;

    // init
    _csvReport = '\n';
  }

  @override
  void play(Game game, MovePlaying? callback) async {
    // record for evaluator
    _evaluator.game = game;
    _evaluator.callback = callback;

    // we need to do this only once
    if (_algorithm == null) {
      // create
      _algorithm = GeneticAlgorithm<TetrisPhenotype, double, TetrisLinesResult>(
        _firstGeneration,
        [
          _evaluator
              as PhenotypeEvaluator<TetrisPhenotype, double, TetrisLinesResult>
        ],
        _breeder,
        printf: (_) {},
        statusf: (_) {},
      );

      // report
      _algorithm!.onGenerationEvaluated.listen((gen) {
        // aborted
        if (_algorithm!.maxExperiments == 1) {
          return;
        }

        // print our own status
        printf('\n');
        printf('Generation #${_algorithm!.currentGeneration}');
        printf(
            '  - AVG ALL = ${TetrisLinesResult.fitnessToLines(gen.averageFitness!.toDouble())}');
        printf(
            '  - AVG BEST = ${TetrisLinesResult.fitnessToLines(gen.bestFitness!.toDouble())}');
        printf('  - BEST GEN = ${TetrisLinesResult.bestScoreGeneration}');
        printf('  - BEST EVER = ${TetrisLinesResult.bestScoreEver}');
        printf('  - ELITE = ${gen.best!.genes}');
        printf('\n');

        // csv
        _csvReport +=
            '${_algorithm!.currentGeneration},${TetrisLinesResult.fitnessToLines(gen.averageFitness!.toDouble())},${TetrisLinesResult.fitnessToLines(gen.bestFitness!.toDouble())},${TetrisLinesResult.bestScoreGeneration},${TetrisLinesResult.bestScoreEver}\n';

        // reset
        TetrisLinesResult.bestScoreGeneration = 0;
      });

      // log
      print('START = ${DateTime.now()}');
      print('ELITE = ${_breeder.elitismCount}');

      // run
      _algorithm!.runUntilDone();
    }
  }

  @override
  void kill() {
    print('CSV REPORT$_csvReport');
    _algorithm?.maxExperiments = 1;
    _evaluator.kill();
  }

  @override
  Move? selectMove(Game game, List<Move> moves) {
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

    // done
    return ' gen: ${info.currGeneration}\n ind: ${info.currIndividual}\n exp: ${(info.currExperiment) + 1}\nlast: ${info.lastScoreInd}\n+ind: ${info.bestScoreInd}\n+gen: ${info.bestScoreGen}\n+evr: ${info.bestScoreEver}';
  }

  GeneticInfo getGeneticInfo() {
    // need some work to get current individual
    int experiments = _algorithm?.currentExperiment ?? -1 + 1;
    int individuals = experiments -
        (experiments ~/ Consts.kMembersPerGeneration) *
            Consts.kMembersPerGeneration;

    // build
    return GeneticInfo(
      currGeneration: _algorithm?.currentGeneration ?? -1 + 1,
      currIndividual: individuals,
      currExperiment: _evaluator.scores?.length ?? 0,
      lastScoreInd: _evaluator.scores == null || _evaluator.scores!.isEmpty
          ? 0
          : _evaluator.scores!.last,
      bestScoreInd: _evaluator.scores == null || _evaluator.scores!.isEmpty
          ? 0
          : _evaluator.scores!.reduce(max),
      bestScoreGen: TetrisLinesResult.bestScoreGeneration,
      bestScoreEver: TetrisLinesResult.bestScoreEver,
    );
  }
}
