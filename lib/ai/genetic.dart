import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/evaluator.dart';
import 'package:tetris/ai/evaluator_mt.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/ai/result.dart';
import 'package:tetris/model/game.dart';

class GeneticInfo {
  int? currGeneration;
  int? currIndividual;
  int? currExperiment;
  int? lastScoreInd;
  int? bestScoreInd;
  int? bestScoreGen;
  int? bestScoreEver;
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
  static const int kMembersPerGeneration = 25;
  static const int kRunsPerMember = 5;

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
          kMembersPerGeneration, (i) => TetrisPhenotype.random(i)));

    // evaluator
    if (multithread) {
      _evaluator = TetrisEvaluatorMT();
    } else {
      _evaluator = TetrisEvaluator();
    }

    // breeder
    _breeder = GenerationBreeder<TetrisPhenotype, double, TetrisLinesResult>(
            () => TetrisPhenotype())
          ..elitismCount = max(1, (kMembersPerGeneration * 0.05).round())
        //..crossoverPropability = 0.8
        ;

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
    return ' gen: ${info.currGeneration ?? '-'}\n ind: ${info.currIndividual ?? '-'}\n exp: ${(info.currExperiment ?? 0) + 1}\nlast: ${info.lastScoreInd ?? '-'}\n+ind: ${info.bestScoreInd ?? '-'}\n+gen: ${info.bestScoreGen ?? '-'}\n+evr: ${info.bestScoreEver ?? '-'}';
  }

  GeneticInfo getGeneticInfo() {
    // build
    GeneticInfo info = GeneticInfo();
    info.currGeneration = (_algorithm?.currentGeneration ?? -1) + 1;
    info.currIndividual = (_algorithm?.currentExperiment ?? -1) + 1;
    info.currExperiment = _evaluator.scores?.length ?? 0;
    info.lastScoreInd = _evaluator.scores == null || _evaluator.scores!.isEmpty
        ? 0
        : _evaluator.scores!.last;
    info.bestScoreInd = _evaluator.scores == null || _evaluator.scores!.isEmpty
        ? 0
        : _evaluator.scores!.reduce(max);
    info.bestScoreGen = TetrisLinesResult.bestScoreGeneration;
    info.bestScoreEver = TetrisLinesResult.bestScoreEver;
    return info;
  }
}
