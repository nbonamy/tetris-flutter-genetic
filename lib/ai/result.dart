import 'dart:math';

import 'package:darwin/darwin.dart';

class TetrisLinesResult extends FitnessResult {

  static double linesToFitness(double lines) {
    return 1000.0 / (1.0 + lines);
  }

  static int fitnessToLines(double fitness) {
    return (1000.0 / fitness).round() - 1;
  }

  List<int> scores = List();
  static int bestScoreGeneration = 0;
  static int bestScoreEver = 0;

  double get value {
    double totalLinesCompleted = scores.reduce((a, b) => a + b).toDouble();
    return linesToFitness(totalLinesCompleted / scores.length);
  }

  @override
  int compareTo(covariant TetrisLinesResult other) {
    return value.compareTo(other.value);
  }

  @override
  double evaluate() => value;

}

TetrisLinesResult tetrisLinesResultCombinator(TetrisLinesResult a, TetrisLinesResult b) {
  final result = new TetrisLinesResult();
  result.scores.addAll(a.scores);
  result.scores.addAll(b.scores);
  result.scores.forEach((score) => _updateBestScores(score));
  return result;
}

void _updateBestScores(int score) {
  TetrisLinesResult.bestScoreGeneration = max(score, TetrisLinesResult.bestScoreGeneration);
  TetrisLinesResult.bestScoreEver = max(score, TetrisLinesResult.bestScoreEver);
}
