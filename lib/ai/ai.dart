
import 'dart:math';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/tetromino.dart';

class Move {
  final int rotations;
  final int translations;
  Move({
    this.rotations,
    this.translations,
  });

}

typedef MovePlaying(bool finalOp);

abstract class Pajitnov {

  Random random;

  Pajitnov() {
    random = new Random();
  }

  void play(Game game, MovePlaying callback) {

    // we need moves
    List<Move> moves = _getAllMoves(game);
    if (moves == null) {
      return;
    }

    // select the move
    Move move = selectMove(game, moves);
    if (move == null) {
      move = moves[0];
    }

    // play it
    playMove(game, move, false, callback);

  }

  Move selectMove(Game game, List<Move> moves);

  void onGameFinished(Game game) {}

  String getInfo() { return null; }

  List<Move> _getAllMoves(Game game) {

    // get the current tetromino
    Tetromino tetromino = game.currentTetromino;
    if (tetromino == null) {
      return null;
    }

    // clone it
    tetromino = tetromino.clone();

    // generate all
    List<Move> moves = List();
    for (int r=0; r<4; r++) {
      if (r>0) {
        tetromino.rotate();
      }
      for (int i=0; i<=game.board.width; i++) {
        for (int s=-1; s<=1; s+=2) {
          if (tetromino.x + i*s >= 0 && tetromino.x + tetromino.width + i*s <= game.board.width) {
            moves.add(Move(rotations: r, translations: i*s,));
          }
        }
      }
    }

    // done
    return moves;

  }

  Game playMove(Game game, Move move, bool simulation, MovePlaying callback) {

    // if not simulation play it directly
    if (simulation == false) {
      _playMove(game, move, callback);
      return null;
    }

    // clone and play against clone
    Game clone = game.clone();
    _playMove(clone, move, callback);
    return clone;

  }

  void _playMove(Game game, Move move, MovePlaying callback) {

    // first rotate
    for (int r=0; r<move.rotations; r++) {
      game.rotate();
      if (callback != null) {
        callback(false);
      }
    }

    // move
    for (int i=0; i<move.translations.abs(); i++) {
      if (move.translations < 0) {
        game.moveLeft();
      } else {
        game.moveRight();
      }
      if (callback != null) {
        callback(false);
      }
    }

    // drop
    game.drop();

    // done
    if (callback != null) {
      callback(true);
    }

  }

}
