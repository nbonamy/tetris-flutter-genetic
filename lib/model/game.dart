
import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/model/board.dart';
import 'package:tetris/model/tetrominos/i.dart';
import 'package:tetris/model/tetrominos/j.dart';
import 'package:tetris/model/tetrominos/l.dart';
import 'package:tetris/model/tetrominos/o.dart';
import 'package:tetris/model/tetrominos/s.dart';
import 'package:tetris/model/tetrominos/t.dart';
import 'package:tetris/model/tetrominos/z.dart';

class Game {

  static const double kInitialSpeed = 1000;
  static const int kIncreaseLevelEvery = 25;
  static const int kTetrominoMovedPoint = 1;
  static const int kTetrominoDroppedPoint = 10;
  static const List<int> kLinesCompletedPoints = [
    100,
    250,
    500,
    1000,
  ];

  int _level;
  int _count;
  int _lines;
  int _score;

  Board _board;
  bool _finished;
  Tetromino _nextTetromino;
  Tetromino _currentTetromino;
  List<List<Color>> _boardState;
  Random _random;

  Game() {

    // easy
    this._level = 1;
    this._count = 0;
    this._lines = 0;
    this._score = 0;
    this._finished = false;
    this._board = Board();
    this._random = Random();

    // init
    this._boardState = List.generate(this._board.height, (_) {
      return List.generate(this._board.width, (_) => null);
    });

    // get two tetrominos
    _currentTetromino = _newTetromino();
    _nextTetromino = _newTetromino();

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
    return (kInitialSpeed * 2 / (_level+1.0)).round();
  }

  Board get board {
    return this._board;
  }

  Tetromino get currentTetromino {
    return _currentTetromino;
  }

  Tetromino get nextTetromino {
    return _nextTetromino;
  }

  bool tick() {

    // move the current tetromino
    if (_currentTetromino != null) {

      // stop or move
      if (_checkCollision(_currentTetromino, 0, 1)) {

        // end of game
        if (_currentTetromino?.y == 0) {
          _finished = true;
          return false;
        }

        // add tetromino to state and check completed lines
        _addTetrominoToState(_boardState, _currentTetromino);
        _checkCompletedLines();
        _currentTetromino = null;

        // score
        _score += kTetrominoDroppedPoint;


      } else {

        // simply move it down
        _currentTetromino.y++;

        // score
        _score += kTetrominoMovedPoint;

      }
    }

    // do we need a tetromino
    if (_finished == false && _currentTetromino == null) {
      _currentTetromino = _nextTetromino;
      _nextTetromino = _newTetromino();
      while (_checkCollision(_currentTetromino, 0, 0)) {
        _currentTetromino.y--;
        _finished = true;
      }
      return true;
    }

    // nothing happened
    return false;

  }

  void moveLeft() {
    if (_currentTetromino != null && _currentTetromino.x > 0) {
      if (_checkCollision(_currentTetromino, -1, 0) == false) {
        _currentTetromino.x--;
      }
    }
  }

  void moveRight() {
    if (_currentTetromino != null && _currentTetromino.x + _currentTetromino.width < _board.width) {
      if (_checkCollision(_currentTetromino, 1, 0) == false) {
        _currentTetromino.x++;
      }
    }
  }

  bool rotate() {

    // we need a tetromino
    if (_currentTetromino == null) {
      return false;
    }

    // save values
    int x = _currentTetromino.x;
    int y = _currentTetromino.y;
    Rotation rot = _currentTetromino.rotation;

    // rotate
    _currentTetromino.rotate();

    // if collision restore
    if (_checkCollision(_currentTetromino, 0, 0)) {
      _currentTetromino.x = x;
      _currentTetromino.y = y;
      _currentTetromino.rotation = rot;
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
    List<List<TetrominoType>> blocks = tetromino.blocks;
    int newX = tetromino.x + tetromino.blocks.first.length - 1 + deltaX;
    int newY = tetromino.y + tetromino.blocks.length - 1 + deltaY;
    if (newX < 0 || newX >= _board.width || newY >= _board.height) {
      return true;
    }

    // check
    for (int j=0; j<blocks.length; j++) {
      int newY = tetromino.y+j+deltaY;
      if (newY >= 0 && newY <= _board.height -1) {
        List<TetrominoType> row = blocks[j];
        for (int i=0; i<row.length; i++) {
          int newX = tetromino.x+i+deltaX;
          if (row[i] != null && newX >= 0 && newX <= _board.width - 1) {
            if (_boardState[tetromino.y+j+deltaY][tetromino.x+i+deltaX] != null) {
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
    int linesCompleted = 0;

    // and process it
    for (int j=_boardState.length-1; j>=0; j--) {

      // check if complete
      bool complete = true;
      List<Color> row = _boardState[j];
      for (int i=0; i<row.length; i++) {
        if (row[i] == null) {
          complete = false;
          break;
        }
      }

      // if complete
      if (complete) {

        // move all lines down
        for (int k=j; k>=1; k--) {
          _boardState[k] = _boardState[k-1];
        }

        // reset
        _boardState[0] = List.generate(this._board.width, (_) => null);

        // we need to recheck the same line
        j = j + 1;

        // and congrats
        linesCompleted++;

      }

    }

    // update score
    if (linesCompleted > 0) {
      this._score += kLinesCompletedPoints[linesCompleted-1];
      this._lines += linesCompleted;
    }

  }

  void _incCount() {
    if (++this._count % kIncreaseLevelEvery == 0) {
      this._level++;
    }
  }

  List<List<Color>> getBoardState(bool includeCurrentTetromino) {

    // we send a clone anyways
    List<List<Color>> state = List.generate(_boardState.length, (j) {
      return List.generate(_boardState[j].length, (i) {
        return _boardState[j][i];
      });
    });

    // add current tetromino if needed
    if (includeCurrentTetromino == true && _currentTetromino != null) {
      _addTetrominoToState(state, _currentTetromino);
    }

    // done
    return state;

  }

  void _addTetrominoToState(List<List<Color>> state, Tetromino tetromino) {

    // place each block
    List<List<TetrominoType>> blocks = tetromino.blocks;
    for (int j=0; j<blocks.length; j++) {
      if (j+tetromino.y >= 0 && j+tetromino.y <= this._board.height-1) {
        List<TetrominoType> row = blocks[j];
        for (int i=0; i<row.length; i++) {
          if (row[i] != null && i+tetromino.x <= this._board.width-1) {
            state[j+tetromino.y][i+tetromino.x] = tetromino.color;
          }
        }
      }
    }

  }

  Tetromino _newTetromino() {
    Tetromino tetromino = this._randomTetromino();
    tetromino.x = ((this._board.width - tetromino.width) / 2).floor();
    _incCount();
    return tetromino;
  }

  Tetromino _randomTetromino() {

    List types = TetrominoType.values;
    TetrominoType type = types[_random.nextInt(types.length)];
    switch (type) {
      case TetrominoType.o:
        return TetrominoO();
      case TetrominoType.i:
        return TetrominoI();
      case TetrominoType.t:
        return TetrominoT();
      case TetrominoType.s:
        return TetrominoS();
      case TetrominoType.z:
        return TetrominoZ();
      case TetrominoType.j:
        return TetrominoJ();
      case TetrominoType.l:
        return TetrominoL();
      default:
        return null;
    }

  }

}
