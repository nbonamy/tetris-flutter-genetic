
import 'package:flutter/foundation.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/dumb.dart';
import 'package:tetris/ai/force.dart';
import 'package:tetris/model/game.dart';

abstract class TetrisUI {
  void currentPieceDone();
  void stateUpdateNeeded();
  void restartGame();
}

abstract class Player {

  Game _game;
  final TetrisUI ui;
  Player({
    @required this.ui,
  });

  bool get autoRestart;
  bool get userCanInteract;
  void startGame(Game game);
  void gameEnded();

  String getInfo();

}

class RealPlayer extends Player {

  RealPlayer({
    @required TetrisUI ui,
  }) : super(ui: ui);

  @override
  bool get autoRestart => false;

  @override
  bool get userCanInteract => false;

  @override
  void startGame(Game game) {
    this._game = game;
    this._tick();
  }

  @override
  void gameEnded() {
  }

  @override
  String getInfo() {
    return null;
  }

  void _tick() {

    // tick: true means current piece is done
    if (_game.tick()) {
      if (ui != null) {
        ui.currentPieceDone();
      }
    }

    // refesh ui
    ui.stateUpdateNeeded();

    // continue?
    if (_game.isFinished == false) {

      // set next timer
      Future.delayed(Duration(milliseconds: _game.delay), () {
        _tick();
      });

    }

  }

}

class AiPlayer extends Player {

  Pajitnov _ai;

  AiPlayer({
    @required TetrisUI ui,
  }) : super(ui: ui) {
    _ai = BruteForce();
  }

  @override
  bool get autoRestart => false;

  @override
  bool get userCanInteract => false;

  @override
  void startGame(Game game) {

    _ai.play(game, (bool finalOp) {

      // refresh
      ui.stateUpdateNeeded();

      if (finalOp) {

        if (game.isFinished) {

          // callback
          _ai.onGameFinished(game);

          // auto restart
          Future.delayed(Duration(milliseconds: 500), () {
            ui.restartGame();
          });

        } else {

          // continue
          Future.delayed(Duration(milliseconds: 100), () {
            startGame(game);
          });

        }

      }

    });

  }

  @override
  void gameEnded() {
  }

  @override
  String getInfo() {
    return _ai.getInfo();
  }

}
