
import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:tetris/ai/smart.dart';

class TetrisPhenotype extends Phenotype<double, SingleObjectiveResult> {

  Random _random = Random();

  TetrisPhenotype();

  TetrisPhenotype.random() {
    genes = List.generate(Smart.kGenesCount, (_) => (_random.nextDouble()-0.5) * 3.0);
  }

  @override
  double mutateGene(double gene, num strength) {
    double mutated = gene * (1.0 + (_random.nextDouble()-0.5) / 2 * strength);
    return mutated;
  }

}
