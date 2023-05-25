import 'dart:math';
import 'dart:collection';
import 'package:tetris/model/tetromino.dart';

class Randomizer {
  Queue<Tetromino> _bag = Queue();

  final int bagSize;
  Randomizer({
    required this.bagSize,
  });

  Tetromino next() {
    if (_bag.isEmpty) {
      _fillBag();
    }
    return _bag.removeFirst();
  }

  _fillBag() {
    // reset the bag
    _bag.clear();

    // fill it as needed
    int index = -1;
    List<Tetromino>? list;
    while (_bag.length < max(1, bagSize)) {
      // make sure the list if filled
      if (list == null || index >= list.length) {
        list = Tetromino.all();
        list.shuffle();
        index = 0;
      }

      // add next
      _bag.add(list[index++]);
    }
  }
}
