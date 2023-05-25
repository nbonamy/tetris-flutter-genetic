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

  static const int kMembersPerGeneration = 25;
  static const int kRunsPerMember = 5;
  static const double kElitism = 0.05;

  static const int kPauseMicroseconds = 100;
}
