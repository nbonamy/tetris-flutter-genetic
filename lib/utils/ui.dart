
import 'package:flutter/material.dart';
import 'package:stanley/stanley.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/utils/consts.dart';

class UIUtils {

  static Text text(String text, {
    double size,
    bool bold,
  }) {

    return UIHelper.text(
      text,
      family: Consts.kFontFamily,
      color: Consts.kTextColor,
      size: size,
      bold: bold,
    );
  }

  static Color tetrominoColor(TetrominoType type) {

    switch (type) {

      case TetrominoType.o:
        return Colors.yellow;
      case TetrominoType.i:
        return Colors.cyan;
      case TetrominoType.t:
        return Colors.purple;
      case TetrominoType.s:
        return Colors.green;
      case TetrominoType.z:
        return Colors.red;
      case TetrominoType.j:
        return Colors.blue;
      case TetrominoType.l:
        return Colors.orange;
      default:
        return Colors.white;
    }



  }
}
