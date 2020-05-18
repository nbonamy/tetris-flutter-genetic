
import 'package:flutter/widgets.dart';
import 'package:tetris/model/piece.dart';

class BlockPainter extends CustomPainter {

  final List<List<Color>> blocks;
  final Piece currentPiece;
  final double cellSize;
  BlockPainter({
    this.blocks,
    this.currentPiece,
    this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // first draw each block
    for (int j=0; j<blocks.length; j++) {
      List<Color> row = blocks[j];
      for (int i=0; i<row.length; i++) {
        if (row[i] != null) {
          Paint paint = new Paint()..color = row[i];
          Rect rect = new Rect.fromLTWH(
            i * cellSize+1,
            j * cellSize+1,
            cellSize-2,
            cellSize-2,
          );

          canvas.drawRect(rect, paint);

        }
      }
    }

    // current piece guidelines
    if (currentPiece != null) {

      // aint
      Paint paint = new Paint()..color = currentPiece.color.withOpacity(0.5);

      // get blocks
      int leftOffset = 0;
      int rightOffset = 0;
      bool leftFound = false;
      bool rightFound = false;
      List<List<bool>> blocks = currentPiece.blocks;
      for (int j=blocks.length-1; j>=0; j--) {
        if (blocks[j][0] == true) { leftFound = true; }
        else if (leftFound == false) { leftOffset--; }
        if (blocks[j][blocks[j].length-1] == true) { rightFound = true; }
        else if (rightFound == false) { rightOffset--; }
      }

      // left line
      Offset p1 = Offset(currentPiece.x * cellSize, (currentPiece.y + currentPiece.height + leftOffset) * cellSize);
      Offset p2 = Offset(p1.dx, 20 * cellSize);
      canvas.drawLine(p1, p2, paint);

      // right line
      Offset p3 = Offset((currentPiece.x + currentPiece.width) * cellSize, (currentPiece.y + currentPiece.height + rightOffset) * cellSize);
      Offset p4 = Offset(p3.dx, p2.dy);
      canvas.drawLine(p3, p4, paint);

    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
