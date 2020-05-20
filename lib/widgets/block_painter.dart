
import 'package:flutter/widgets.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/utils/ui.dart';

class BlockPainter extends CustomPainter {

  final List<List<TetrominoType>> blocks;
  final Tetromino currentTetromino;
  final double cellSize;
  final double spacing;
  BlockPainter({
    @required this.blocks,
    this.currentTetromino,
    @required this.cellSize,
    this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // check
    if (blocks == null) {
      return;
    }

    // calc spacing
    double _spacing = spacing;
    if (_spacing == null) {
      _spacing = cellSize / 25;
    }

    // first draw each block
    for (int j=0; j<blocks.length; j++) {
      List<TetrominoType> row = blocks[j];
      for (int i=0; i<row.length; i++) {
        if (row[i] != null) {
          Paint paint = new Paint()..color = UIUtils.tetrominoColor(row[i]);
          Rect rect = new Rect.fromLTWH(
            i * cellSize + _spacing,
            j * cellSize + _spacing,
            cellSize - 2 * _spacing,
            cellSize - 2 * _spacing,
          );

          canvas.drawRect(rect, paint);

        }
      }
    }

    // current tetromino guidelines
    if (currentTetromino != null) {

      // aint
      Paint paint = new Paint()..color = UIUtils.tetrominoColor(currentTetromino.type).withOpacity(0.5);

      // get blocks
      int leftOffset = 0;
      int rightOffset = 0;
      bool leftFound = false;
      bool rightFound = false;
      List<List<TetrominoType>> blocks = currentTetromino.blocks;
      for (int j=blocks.length-1; j>=0; j--) {
        if (blocks[j][0] != null) { leftFound = true; }
        else if (leftFound == false) { leftOffset--; }
        if (blocks[j][blocks[j].length-1] != null) { rightFound = true; }
        else if (rightFound == false) { rightOffset--; }
      }

      // left line
      Offset p1 = Offset(currentTetromino.x * cellSize, (currentTetromino.y + currentTetromino.height + leftOffset) * cellSize);
      Offset p2 = Offset(p1.dx, 20 * cellSize);
      canvas.drawLine(p1, p2, paint);

      // right line
      Offset p3 = Offset((currentTetromino.x + currentTetromino.width) * cellSize, (currentTetromino.y + currentTetromino.height + rightOffset) * cellSize);
      Offset p4 = Offset(p3.dx, p2.dy);
      canvas.drawLine(p3, p4, paint);

    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
