
import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:tetris/model/piece.dart';
import 'package:tetris/model/board.dart';
import 'package:tetris/model/pieces/i.dart';
import 'package:tetris/model/pieces/j.dart';
import 'package:tetris/model/pieces/l.dart';
import 'package:tetris/model/pieces/o.dart';
import 'package:tetris/model/pieces/s.dart';
import 'package:tetris/model/pieces/t.dart';
import 'package:tetris/model/pieces/z.dart';

class Game {

  int _level;
  int _count;
  int _lines;
  Board _board;
  bool _finished;
  Piece _currentPiece;
  List<List<Color>> _boardState;
  Random _random;

  Game() {

    // easy
    this._level = 0;
    this._count = 0;
    this._lines = 0;
    this._finished = false;
    this._board = Board();
    this._random = Random();

    // init
    this._boardState = List.generate(this._board.height, (_) {
      return List.generate(this._board.width, (_) => null);
    });

  }

  bool get finished {
    return this._finished;
  }

  int get level {
    return this._level;
  }

  int get piecesCount {
    return this._count;
  }

  int get lines {
    return this._lines;
  }

  int get delay {
    return 1000 - this._level * 100;
  }

  Board get board {
    return this._board;
  }

  bool tick() {

    // move the current piece
    if (_currentPiece != null) {

      // collision
      bool collision = false;
      if (_currentPiece.y + _currentPiece.height >= _board.height) {
        collision = true;
      } else {
        collision = _checkCollision(_currentPiece, 0, 1);
      }

      // stop or move
      if (collision) {

        // end of game
        if (_currentPiece?.y == 0) {
          _currentPiece.y -= _currentPiece.height;
          this._finished = true;
          return false;
        }

        // add piece to state and check completed lines
        _addPieceToState(_boardState, _currentPiece);
        _checkCompletedLines();
        _currentPiece = null;

      } else {

        // simply move it down
        _currentPiece.y++;

      }
    }

    // do we need a piece
    if (_finished == false && _currentPiece == null) {
      _currentPiece = _addPiece();
      return true;
    }

    // nothing happened
    return false;

  }

  void moveLeft() {
    if (_currentPiece != null && _currentPiece.x > 0) {
      if (_checkCollision(_currentPiece, -1, 0) == false) {
        _currentPiece.x--;
      }
    }
  }

  void moveRight() {
    if (_currentPiece != null && _currentPiece.x + _currentPiece.width < _board.width) {
      if (_checkCollision(_currentPiece, 1, 0) == false) {
        _currentPiece.x++;
      }
    }
  }

  void rotate() {
    _currentPiece?.rotate();
  }

  bool _checkCollision(Piece piece, int deltaX, int deltaY) {

    // check
    List<List<bool>> blocks = piece.blocks;
    for (int j=0; j<blocks.length; j++) {
      if (_currentPiece.y+j+deltaY <= _board.height-1) {
        List<bool> row = blocks[j];
        for (int i=0; i<row.length; i++) {
          if (row[i] && _currentPiece.x+i+deltaX <= _board.width-1) {
            if (_boardState[_currentPiece.y+j+deltaY][_currentPiece.x+i+deltaX] != null) {
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
        this._lines++;

      }

    }

  }

  void _incCount() {
    if (++this._count % 100 == 0) {
      this._level++;
    }
  }

  List<List<Color>> getBoardState() {

    // we send a clone anyways
    List<List<Color>> state = List.generate(_boardState.length, (j) {
      return List.generate(_boardState[j].length, (i) {
        return _boardState[j][i];
      });
    });

    // add current piece if needed
    if (_currentPiece != null) {
      _addPieceToState(state, _currentPiece);
    }

    // done
    return state;

  }

  void _addPieceToState(List<List<Color>> state, Piece piece) {

    // place each block
    List<List<bool>> blocks = piece.blocks;
    for (int j=0; j<blocks.length; j++) {
      if (j+piece.y < this._board.height) {
        List<bool> row = blocks[j];
        for (int i=0; i<row.length; i++) {
          if (row[i] && i+piece.x < this._board.width) {
            state[j+piece.y][i+piece.x] = piece.color;
          }
        }
      }
    }

  }

  Piece _addPiece() {
    Piece piece = this._randomPiece();
    piece.x = ((this._board.width - piece.width) / 2).floor();
    _incCount();
    return piece;
  }

  Piece _randomPiece() {

    List types = PieceType.values;
    PieceType type = types[_random.nextInt(types.length)];
    switch (type) {
      case PieceType.o:
        return PieceO();
      case PieceType.i:
        return PieceI();
      case PieceType.t:
        return PieceT();
      case PieceType.s:
        return PieceS();
      case PieceType.z:
        return PieceZ();
      case PieceType.j:
        return PieceJ();
      case PieceType.l:
        return PieceL();
      default:
        return null;
    }

  }


}
