import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stanley/stanley.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/widgets/block_painter.dart';

class BoardWidget extends StatelessWidget {

  final Game game;
  final double borderSize;
  const BoardWidget({
    Key key,
    this.game,
    this.borderSize = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width * 0.6;
    double height = MediaQuery.of(context).size.height * 0.6;
    double cellSize = min(width / game.board.width, height / game.board.height);

    return Decorator(
      width: game.board.width * cellSize + 2 * borderSize,
      height: game.board.height * cellSize + 1 * borderSize,
      borderLeft: borderSize,
      borderRight: borderSize,
      borderBottom: borderSize,
      borderColor: Colors.red,
      child: CustomPaint(
        foregroundPainter: BlockPainter(
          blocks: game.getBoardState(true),
          currentPiece: game.currentPiece,
          cellSize: cellSize,
        ),
      ),
    );
  }

}


