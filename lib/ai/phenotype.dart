
import 'dart:math';

import 'package:darwin/darwin.dart';
import 'package:tetris/ai/smart.dart';

class TetrisPhenotype extends Phenotype<double, SingleObjectiveResult> {

  Random _random = Random();

  List _gattaca = [
    [0.9881622179163104, -0.33462370153442356, 0.3113100775895259, 0.6374487817951761, 0.7479502315755103],
    [4.030069082756542, 0.9194645703407156, 3.8625879587388665, 1.1275858077604561, -0.8655354662606629],
    [3.700173548370169, -1.4526545823847592, 2.781206977208377, 0.7775896618244404, 3.024785421591565],
    [3.0432928019505168,-1.4526545823847592,1.6349890023922202,0.7775896618244404,0.23474198746778252],
  ];

  TetrisPhenotype();

  TetrisPhenotype.random(int index) {
    if (index < _gattaca.length) {
      genes = _gattaca[index];
    } else {
      genes = List.generate(Smart.kFeatures.length, (_) => (_random.nextDouble()-0.5) * 10.0);
    }
  }

  @override
  double mutateGene(double gene, num strength) {
    double mutated = gene * (1.0 + (_random.nextDouble()-0.5) / 2 * strength);
    return mutated;
  }

}
