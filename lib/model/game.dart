import 'dart:math';

import 'package:tetris/model/tetromino.dart';
import 'package:tetris/model/board.dart';
import 'package:tetris/utils/randomizer.dart';

import '../utils/consts.dart';

class Game {
  int _level = 1;
  int _count = 0;
  int _lines = 0;
  int _score = 0;

  Board _board = Board();
  bool _finished = false;
  Randomizer _randomizer = Randomizer(bagSize: Consts.kRandomBagSize);
  Tetromino? _nextTetromino;
  Tetromino? _currentTetromino;

  Game() {
    _nextTetromino = _newTetromino();
    _currentTetromino = _newTetromino();
  }

  Game clone() {
    // basic stuff
    Game clone = Game();
    clone._level = this._level;
    clone._count = this._count;
    clone._lines = this._lines;
    clone._score = this._score;
    clone._finished = this._finished;
    clone._randomizer = Randomizer(bagSize: Consts.kRandomBagSize);

    // clone board
    clone._board = this._board.clone();
    clone._currentTetromino = this._currentTetromino?.clone();
    clone._nextTetromino = this._nextTetromino?.clone();

    // done
    return clone;
  }

  bool get isFinished {
    return this._finished;
  }

  int get currentLevel {
    return this._level;
  }

  int get tetrominos {
    return this._count;
  }

  int get linesCompleted {
    return this._lines;
  }

  int get score {
    return this._score;
  }

  int get delay {
    // from https://tetris.fandom.com/wiki/Tetris_Worlds
    return (pow(0.8 - ((_level - 1) * 0.007), _level - 1) * 1000).round();
  }

  Board get board {
    return this._board;
  }

  Tetromino? get currentTetromino {
    return _currentTetromino;
  }

  Tetromino? get nextTetromino {
    return _nextTetromino;
  }

  bool tick() {
    // move the current tetromino
    if (_currentTetromino != null) {
      // stop or move
      if (_checkCollision(_currentTetromino!, 0, 1)) {
        // end of game
        if (_currentTetromino?.y == 0) {
          _finished = true;
          return false;
        }

        // add tetromino to state and check completed lines
        _board.addTetromino(_currentTetromino!);
        _checkCompletedLines();
        _currentTetromino = null;

        // score
        _score += Consts.kTetrominoDroppedPoint;
      } else {
        // simply move it down
        _currentTetromino!.y++;

        // score
        _score += Consts.kTetrominoMovedPoint;
      }
    }

    // do we need a tetromino
    if (_finished == false && _currentTetromino == null) {
      _currentTetromino = _nextTetromino;
      _nextTetromino = _newTetromino();
      while (_checkCollision(_currentTetromino!, 0, 0)) {
        _currentTetromino!.y--;
        _finished = true;
      }
      return true;
    }

    // nothing happened
    return false;
  }

  void moveLeft() {
    if (_currentTetromino != null && _currentTetromino!.x > 0) {
      if (_checkCollision(_currentTetromino!, -1, 0) == false) {
        _currentTetromino!.x--;
      }
    }
  }

  void moveRight() {
    if (_currentTetromino != null &&
        _currentTetromino!.x + _currentTetromino!.width < _board.width) {
      if (_checkCollision(_currentTetromino!, 1, 0) == false) {
        _currentTetromino!.x++;
      }
    }
  }

  bool rotate() {
    // we need a tetromino
    if (_currentTetromino == null) {
      return false;
    }

    // save values
    int x = _currentTetromino!.x;
    int y = _currentTetromino!.y;
    Rotation rot = _currentTetromino!.rotation;

    // rotate
    _currentTetromino!.rotate();

    // if collision restore
    if (_checkCollision(_currentTetromino!, 0, 0)) {
      _currentTetromino!.x = x;
      _currentTetromino!.y = y;
      _currentTetromino!.rotation = rot;
      return false;
    }

    // done
    return true;
  }

  void drop() {
    while (true) {
      if (tick() || this._finished) {
        break;
      }
    }
  }

  bool _checkCollision(Tetromino tetromino, int deltaX, int deltaY) {
    // check boundaries
    List<List<TetrominoType?>> blocks = tetromino.blocks;
    int newX = tetromino.x + tetromino.blocks.first.length - 1 + deltaX;
    int newY = tetromino.y + tetromino.blocks.length - 1 + deltaY;
    if (newX < 0 || newX >= _board.width || newY >= _board.height) {
      return true;
    }

    // check
    List<List<TetrominoType?>> state = _board.state;
    for (int j = 0; j < blocks.length; j++) {
      int newY = tetromino.y + j + deltaY;
      if (newY >= 0 && newY <= _board.height - 1) {
        List<TetrominoType?> row = blocks[j];
        for (int i = 0; i < row.length; i++) {
          int newX = tetromino.x + i + deltaX;
          if (row[i] != null && newX >= 0 && newX <= _board.width - 1) {
            if (state[tetromino.y + j + deltaY][tetromino.x + i + deltaX] !=
                null) {
              return true;
            }
          }
        }
      }
    }

    // good
    return false;
  }

  void _checkCompletedLines() {
    // count lines completed
    int linesCompleted = _board.checkCompletedLines();

    // update score
    if (linesCompleted > 0) {
      linesCompleted = Consts.kLinesCompletedLines[linesCompleted - 1];
      this._lines += linesCompleted;
      this._score += linesCompleted * 100;
    }

    // update level
    this._level = this._lines ~/ Consts.kIncreaseLevelEvery;
  }

  List<List<TetrominoType?>> getBoardState(bool includeCurrentTetromino) {
    // get current state
    List<List<TetrominoType?>> state = _board.state;

    // add current tetromino if needed
    if (includeCurrentTetromino == true && _currentTetromino != null) {
      Board.addTetrominoToState(_board, state, _currentTetromino!);
    }

    // done
    return state;
  }

  Tetromino _newTetromino() {
    Tetromino tetromino = _randomizer.next();
    tetromino.x = ((this._board.width - tetromino.width) / 2).floor();
    return tetromino;
  }
}
