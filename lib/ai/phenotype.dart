import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:tetris/ai/result.dart';
import 'package:tetris/ai/smart.dart';

import '../utils/consts.dart';

class TetrisPhenotype extends Phenotype<double, TetrisLinesResult> {
  Random _random = Random();

  TetrisPhenotype();

  TetrisPhenotype.random(int index) {
    if (index < Consts.kGattaca.length) {
      genes = Consts.kGattaca[index];
    } else {
      genes = List.generate(
          Smart.kFeatures.length, (_) => (_random.nextDouble() - 0.5) * 10.0);
    }
  }

  @override
  double mutateGene(double gene, num strength) {
    double mutated = gene * (1.0 + (_random.nextDouble() - 0.5) / 2 * strength);
    return mutated;
  }
}
