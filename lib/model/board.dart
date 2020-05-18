import 'package:tetris/model/tetromino.dart';

class Board {
  List<List<TetrominoType>> _state;

  final int width;
  final int height;
  Board({
    this.width = 10,
    this.height = 20,
  }) {
    // init
    this._state = List.generate(this.height, (_) {
      return List.generate(this.width, (_) => null);
    });
  }

  Board clone() {
    Board clone = Board(width: this.width, height: this.height);
    clone._state = this.state;
    return clone;
  }

  List<List<TetrominoType>> get state {
    // we send a clone
    return List.generate(_state.length, (j) {
      return List.generate(_state[j].length, (i) {
        return _state[j][i];
      });
    });
  }

  int checkCompletedLines() {
    // count lines completed
    int linesCompleted = 0;

    // and process it
    for (int j = _state.length - 1; j >= 0; j--) {
      // check if complete
      bool complete = true;
      List<TetrominoType> row = _state[j];
      for (int i = 0; i < row.length; i++) {
        if (row[i] == null) {
          complete = false;
          break;
        }
      }

      // if complete
      if (complete) {
        // move all lines down
        for (int k = j; k >= 1; k--) {
          _state[k] = _state[k - 1];
        }

        // reset
        _state[0] = List.generate(this.width, (_) => null);

        // we need to recheck the same line
        j = j + 1;

        // and congrats
        linesCompleted++;
      }
    }

    // done
    return linesCompleted;
  }

  void addTetromino(Tetromino tetromino) {
    Board.addTetrominoToState(this, _state, tetromino);
  }

  static void addTetrominoToState(Board board, List<List<TetrominoType>> state, Tetromino tetromino) {
    // place each block
    List<List<TetrominoType>> blocks = tetromino.blocks;
    for (int j = 0; j < blocks.length; j++) {
      if (j + tetromino.y >= 0 && j + tetromino.y <= board.height - 1) {
        List<TetrominoType> row = blocks[j];
        for (int i = 0; i < row.length; i++) {
          if (row[i] != null && i + tetromino.x <= board.width - 1) {
            state[j + tetromino.y][i + tetromino.x] = tetromino.type;
          }
        }
      }
    }
  }
}
