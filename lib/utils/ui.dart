
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
        return Colors.blue;
      case TetrominoType.i:
        return Colors.red;
      case TetrominoType.t:
        return Colors.grey;
      case TetrominoType.s:
        return Colors.orange;
      case TetrominoType.z:
        return Colors.green;
      case TetrominoType.j:
        return Colors.pink;
      case TetrominoType.l:
        return Colors.yellow;
      default:
        return Colors.white;
    }



  }
}
