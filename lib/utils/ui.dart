
import 'package:flutter/material.dart';
import 'package:stanley/stanley.dart';
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
}
