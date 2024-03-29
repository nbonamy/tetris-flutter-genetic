import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stanley/stanley.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/utils/ui.dart';
import 'package:tetris/widgets/block_painter.dart';

class BoardWidget extends StatelessWidget {
  final Game game;
  final double borderSize;
  final bool drawGuidelines;
  const BoardWidget({
    Key? key,
    required this.game,
    this.borderSize = 4,
    this.drawGuidelines = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    double height = MediaQuery.of(context).size.height * 0.55;
    double cellSize = min(width / game.board.width, height / game.board.height);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _buildRowIds(cellSize),
        ),
        Decorator(
          marginLeft: 8,
          width: game.board.width * cellSize + 2 * borderSize,
          height: game.board.height * cellSize + 1 * borderSize,
          borderLeft: borderSize,
          borderRight: borderSize,
          borderBottom: borderSize,
          borderColor: Colors.white,
          child: CustomPaint(
            foregroundPainter: BlockPainter(
              blocks: game.getBoardState(drawGuidelines),
              currentTetromino: drawGuidelines ? game.currentTetromino : null,
              cellSize: cellSize,
            ),
          ),
        ),
      ],
    );
  }

  _buildRowIds(cellSize) {
    List<Widget> ids = [];
    for (int i = game.board.height - 1; i >= 0; i--) {
      ids.add(Decorator(
        height: cellSize,
        child: UIUtils.text('${i + 1}', size: 12),
      ));
    }
    return ids;
  }
}
