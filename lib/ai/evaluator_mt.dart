import 'dart:io';
import 'dart:math';

import 'package:console/console.dart';
import 'package:darwin/isolate_worker.dart';
import 'package:darwin/src/evaluator_multithreaded.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/genetic.dart';
import 'package:tetris/ai/phenotype.dart';
import 'package:tetris/ai/result.dart';
import 'package:tetris/ai/smart.dart';
import 'package:tetris/model/game.dart';

class TetrisEvaluatorMT extends MultithreadedPhenotypeSerialEvaluator<
    TetrisPhenotype,
    double,
    TetrisLinesResult> implements TetrisEvaluatorAbstract {
  set game(Game _) {}
  set callback(MovePlaying? _) {}
  List<int>? get scores {
    return null;
  }

  void gameFinished(Game _) {}
  void kill() {}

  TetrisEvaluatorMT()
      : super((TetrisPhenotype phenotype, int index) {
          // need to run
          if (index < Genetic.kRunsPerMember) {
            return new TetrisTask(
              index: index,
              phenotype: phenotype,
            );
          }

          // last run
          return new TetrisTask(index: -1);
        }, tetrisLinesResultCombinator, TetrisLinesResult());

  @override
  Future<TetrisLinesResult> evaluate(TetrisPhenotype phenotype) async {
    // normal
    TetrisLinesResult result = await super.evaluate(phenotype);

    // some reporting
    int maxLinesCompleted = result.scores.reduce(max);
    double avgLinesCompleted =
        result.scores.reduce((a, b) => a + b).toDouble() / result.scores.length;
    print(
        'Best = ${maxLinesCompleted.toString().padLeft(8)}, Average = ${avgLinesCompleted.toStringAsFixed(2)}');

    // done
    return result;
  }
}

class TetrisTask extends IsolateTask<TetrisPhenotype, TetrisLinesResult> {
  final int index;
  final TetrisPhenotype? phenotype;
  TetrisTask({
    required this.index,
    this.phenotype,
  });

  @override
  TetrisLinesResult execute() {
    // check
    if (phenotype == null) {
      return TetrisLinesResult();
    }

    // init
    Console.moveToColumn(index);
    Console.write('◦');
    Console.moveToColumn(Genetic.kRunsPerMember + 1);
    Smart ai = Smart(phenotype: phenotype!);

    // run game
    Game game = Game();
    while (true) {
      ai.play(game, null);
      if (game.isFinished) {
        Console.moveToColumn(index);
        stdout.write('•');
        Console.moveToColumn(Genetic.kRunsPerMember + 1);
        final result = TetrisLinesResult();
        result.scores.add(game.linesCompleted);
        return result;
      }
    }
  }
}
