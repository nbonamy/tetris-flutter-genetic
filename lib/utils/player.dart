
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/dumb.dart';
import 'package:tetris/ai/force.dart';
import 'package:tetris/ai/genetic.dart';
import 'package:tetris/model/game.dart';

abstract class TetrisUI {
  void currentPieceDone();
  void stateUpdateNeeded();
  void setCurrentGame(Game game);
}

abstract class Player {

  Game _game;
  final TetrisUI ui;
  Player({
    @required this.ui,
  });

  bool get autoRestart;
  bool get userCanInteract;

  void startGame() {
    _game = Game();
    ui.setCurrentGame(_game);
  }

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
  bool get userCanInteract => true;

  @override
  void startGame() {
    super.startGame();
    _tick();
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
  void startGame() {
    super.startGame();
    _play();
  }

  void _play() {

    _ai.play(_game, (bool finalOp) {

      // refresh
      ui.stateUpdateNeeded();

      if (finalOp) {

        if (_game.isFinished) {

          // callback
          _ai.onGameFinished(_game);

          // start game again
          Future.delayed(Duration(milliseconds: 500), () {
            startGame();
          });

        } else {

          // continue
          Future.delayed(Duration(milliseconds: 5), () {
            _play();
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

class GeneticPlayer extends AiPlayer {

  Pajitnov _ai;

  GeneticPlayer({
    @required TetrisUI ui,
  }) : super(ui: ui) {
    _ai = Genetic();
  }

  @override
  bool get autoRestart => false;

  @override
  bool get userCanInteract => false;

  @override
  void startGame() {
    super.startGame();
    _play();
  }

  void _play() {

    _ai.play(_game, (bool finalOp) async {

      // refresh
      ui.stateUpdateNeeded();

      if (finalOp) {

        if (_game.isFinished) {

          // callback
          _ai.onGameFinished(_game);
          startGame();

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
