
import 'package:tetris/ai/ai.dart';
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
    this.ui,
  });

  Game get game => _game;

  bool get autoRestart;
  bool get userCanInteract;

  void startGame() {
    _game = Game();
    ui?.setCurrentGame(_game);
  }

  void gameEnded();

  String getInfo();

  void onBoardTap() {
    if (_game.isFinished) {
      if (autoRestart == false) {
        startGame();
      }
    } else if (userCanInteract) {
      _game.rotate();
      ui?.stateUpdateNeeded();
    }
  }

}

class RealPlayer extends Player {

  RealPlayer({
    TetrisUI ui,
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
      ui?.currentPieceDone();
    }

    // refesh ui
    ui?.stateUpdateNeeded();

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
    TetrisUI ui,
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
      ui?.stateUpdateNeeded();

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
    TetrisUI ui,
    bool print = true,
  }) : super(ui: ui) {
    _ai = Genetic();
    if (print == false) {
      (_ai as Genetic).printf = (_) {};
    }
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
      ui?.stateUpdateNeeded();

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

  @override
  void onBoardTap() {
    _ai.kill();
  }

  GeneticInfo get geneticInfo {
    return (_ai as Genetic).getGeneticInfo();
  }

}
