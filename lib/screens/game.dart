
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stanley/stanley.dart';
import 'package:tetris/ai/ai.dart';
import 'package:tetris/ai/dumb.dart';
import 'package:tetris/ai/force.dart';

import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/utils/ui.dart';
import 'package:tetris/widgets/block_painter.dart';
import 'package:tetris/widgets/board_widget.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int kTickAiDuration = 100;

  Game _game;
  bool _vertDragConsumed = false;
  double _horizDragDelta = 0;
  AssetsAudioPlayer _assetsAudioPlayer;
  Pajitnov _ai;

  @override
  void initState() {
    super.initState();
    _ai = new BruteForce();
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.loop = true;
    _assetsAudioPlayer.open(
      Audio('assets/sounds/theme.mp3'),
      volume: 0.5,
    );
    this.reset();
  }

  reset() {
    _game = Game();
    this._tick(true);
  }

  @override
  Widget build(BuildContext context) {

    // calc stats
    Stats stats = Stats.from(game: _game);

    // next tetromino
    List<List<TetrominoType>> nextTetrominoBlocks = _game.nextTetromino?.blocks;
    List<List<TetrominoType>> nextTetrominoColors = List.generate(nextTetrominoBlocks.length, (j) {
      return List.generate(nextTetrominoBlocks[j].length, (i) {
        return nextTetrominoBlocks[j][i] != null ? _game.nextTetromino.type : null;
      });
    });

    return Scaffold(
      body: Decorator(
        paddingTop: 48,
        alignment: Alignment.topCenter,
        backgroundColor: Colors.black,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Score(title: 'LEVEL', value: _game.currentLevel),
                Score(title: 'SCORE', value: _game.score),
                Score(title: 'LINES', value: _game.linesCompleted),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScoreTitle(text: 'NEXT'),
                    SizedBox(
                      height: 16,
                    ),
                    CustomPaint(
                      foregroundPainter: BlockPainter(
                        blocks: nextTetrominoColors,
                        cellSize: 10,
                      ),
                    ),
                  ],
                ),
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
                    _game.drop();
                    setState(() {});
                    _vertDragConsumed = true;
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
            SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIUtils.text('holes: ${stats.numHoles}'),
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
      if (_game.isFinished == false) {

        // let ai play
        if (_ai != null) {
          _ai.play(_game, () {
            //setState(() {});
            //sleep(Duration(milliseconds: 50));
          });
        }

        // set next timer
        if (setTimer) {
          Future.delayed(Duration(milliseconds: _ai == null ? _game.delay : kTickAiDuration), () {
            _tick(true);
          });
        }

      } else if (_ai != null) {

        Future.delayed(Duration(milliseconds: 500), () {
          //this.reset();
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
