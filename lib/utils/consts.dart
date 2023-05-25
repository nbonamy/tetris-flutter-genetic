import 'package:flutter/material.dart';

class Consts {
  static const String kFontFamily = 'PixelMix';
  static const Color kTextColor = Colors.white;

  static const int kBoardWidth = 10;
  static const int kBoardHeight = 20;

  static const int kRandomBagSize = 7;
  static const double kInitialSpeed = 1000;
  static const int kIncreaseLevelEvery = 20;
  static const int kTetrominoMovedPoint = 1;
  static const int kTetrominoDroppedPoint = 10;
  static const List<int> kLinesCompletedLines = [1, 3, 5, 8];

  static const int kMembersPerGeneration = 50;
  static const int kRunsPerMember = 10;

  static const double kElitism = 0.05;
  static const double kMutationRate = 0.01;
  static const double kCrossoverProbability = 0.8;

  static const int kPauseMicroseconds = 1;

  static const List kGattaca = [
    [
      0.7917380099937565,
      2.3495113892145927,
      4.330230888679764,
      4.7885443526174996,
      -2.0513053475529586,
      1.5764165621164339,
      3.748346631797733,
      0.26869941082824367,
      0.9429526215308859,
      0.02211973711519044,
      3.2273756957542954
    ],
    [
      -3.9919717231655416,
      4.466658545192065,
      2.4975418512729486,
      1.1684136455563898,
      0.7239951720319548,
      -0.2841979326054289,
      4.368227897440348,
      2.825708794440571,
      4.510302772026135,
      1.1346535221162846,
      4.96291149411589
    ]

    //[0.9881622179163104, -0.33462370153442356, 0.3113100775895259, 0.6374487817951761, 0.7479502315755103],
    //[4.030069082756542, 0.9194645703407156, 3.8625879587388665, 1.1275858077604561, -0.8655354662606629],
    //[3.700173548370169, -1.4526545823847592, 2.781206977208377, 0.7775896618244404, 3.024785421591565],
    //[3.0432928019505168,-1.4526545823847592,1.6349890023922202,0.7775896618244404,0.23474198746778252],
  ];
}
