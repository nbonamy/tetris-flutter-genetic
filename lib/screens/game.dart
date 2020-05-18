import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stanley/stanley.dart';

import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';
import 'package:tetris/widgets/board_widget.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  static const double kAccelerationFactor = 1.0;

  Game _game;
  bool _vertDragConsumed = false;
  double _horizDragDelta = 0;
  AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.loop = true;
    _assetsAudioPlayer.open(
      Audio('assets/sounds/theme.mp3'),
      volume: 0.25,
    );
    this.reset();
  }

  reset() {
    _game = Game();
    this._tick(true);
  }

  @override
  Widget build(BuildContext context) {

    Stats stats = Stats.from(game: _game);

    return Scaffold(
      body: Decorator(
        paddingTop: 48,
        alignment: Alignment.topCenter,
        backgroundColor: Colors.black,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Score(title: 'LEVEL', value: _game.currentLevel),
                Score(title: 'SCORE', value: _game.score),
                Score(title: 'LINES', value: _game.linesCompleted),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            GestureDetector(
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
              child: BoardWidget(
                game: _game,
              ),
              onTap: () {
                if (_game.isFinished) {
                  this.reset();
                } else {
                  _game.rotate();
                  setState(() {});
                }
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIUtils.text('holes: ${stats.holes}'),
                UIUtils.text('min: ${stats.minHeight}'),
                UIUtils.text('max: ${stats.maxHeight}'),
                UIUtils.text('avg: ${stats.avgHeight}'),
                UIUtils.text('std: ${stats.heightSD}'),
              ],
            )
          ],
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
      if (setTimer && _game.isFinished == false) {
        Future.delayed(Duration(milliseconds: (_game.delay/kAccelerationFactor).floor()), () {
          _tick(true);
        });
      }
    });
  }
}

class Score extends StatelessWidget {
  final String title;
  final int value;
  const Score({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScoreTitle(
          text: title,
        ),
        SizedBox(
          height: 8,
        ),
        ScoreValue(
          value: value,
        ),
      ],
    );
  }
}

class ScoreTitle extends StatelessWidget {
  final String text;
  const ScoreTitle({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UIUtils.text(text, size: 14);
  }
}

class ScoreValue extends StatelessWidget {
  final int value;
  const ScoreValue({
    Key key,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UIUtils.text(value.toString(), size: 32, bold: true);
  }
}
