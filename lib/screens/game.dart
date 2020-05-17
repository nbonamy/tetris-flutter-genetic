import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stanley/stanley.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/widgets/board_widget.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  Game _game;
  bool _vertDragConsumed = false;
  double _horizDragDelta = 0;

  @override
  void initState() {
    super.initState();
    this.reset();
  }

  reset() {
    _game = Game();
    this._tick(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        _horizDragDelta += details.delta.dx;
        if (_horizDragDelta < -10) {
          _game.moveLeft();
          setState(() {});
          _horizDragDelta = 0;
        } else if (_horizDragDelta > 10) {
          _game.moveRight();
          setState(() {});
          _horizDragDelta = 0;
        }
      },
      onHorizontalDragEnd: (_) => _horizDragDelta = 0,
      onHorizontalDragCancel: () => _horizDragDelta = 0,
      onVerticalDragStart: (_) => _vertDragConsumed = false,
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (_vertDragConsumed == false) {
          if (details.delta.dy < 0) {
            _game.rotate();
            setState(() {});
            _vertDragConsumed = true;
          } else if (details.delta.dy > 0) {
            _tick(false);
          }
        }
      },
      onVerticalDragEnd: (_) => _vertDragConsumed = false,
      onVerticalDragCancel: () => _vertDragConsumed = false,
      child: Decorator(
        backgroundColor: Colors.black,
        child: Decorator(
          alignment: Alignment.center,
          child: BoardWidget(
            game: _game,
          ),
          onTap: () {
            if (_game.finished) {
              this.reset();
            }
          },
        ),
      ),
    );
  }

  void _tick(bool setTimer) {
    if (_game.tick()) {
      _horizDragDelta = 0;
      _vertDragConsumed = true;
    }
    setState(() {
      if (setTimer && _game.finished == false) {
        Future.delayed(Duration(milliseconds: (_game.delay).floor()), () {
          _tick(true);
        });
      }
    });
  }

}
