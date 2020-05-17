import 'package:flutter/widgets.dart';

class BlockPainter extends CustomPainter {

  final List<List<Color>> blocks;
  final double cellSize;
  BlockPainter({
    this.blocks,
    this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {

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

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
