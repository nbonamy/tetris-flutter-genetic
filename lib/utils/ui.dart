
import 'package:flutter/material.dart';
import 'package:stanley/stanley.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/utils/consts.dart';

class UIUtils {

  static Text text(String text, {
    TextAlign align,
    double size,
    bool bold,
  }) {

    return UIHelper.text(
      text,
      family: Consts.kFontFamily,
      color: Consts.kTextColor,
      align: align,
      size: size,
      bold: bold,
    );
  }

  static Widget monoText(String text, {
    double size,
    bool bold,
  }) {

    return UIUtils.text(text, size: size, bold: bold);

    List<Widget> rows = List();
    List<String> lines = text.split('\n');
    for (String line in lines) {
      List<Widget> widgets = List();
      for (int i=0; i<line.length; i++) {
        widgets.add(
          Decorator(
            paddingVert: 2,
            width: (size ?? 14) * 0.85,
            alignment: Alignment.center,
            child: UIUtils.text(line.substring(i, i+1), align: TextAlign.center, size: size, bold: bold,),
          )
        );
      }
      rows.add(Row(children: widgets,));
    }
    return Column(children: rows,);
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
