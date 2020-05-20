import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stanley/stanley.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/stats.dart';
import 'package:tetris/model/tetromino.dart';
import 'package:tetris/utils/number.dart';
import 'package:tetris/model/player.dart';
import 'package:tetris/utils/ui.dart';
import 'package:tetris/widgets/block_painter.dart';
import 'package:tetris/widgets/board_widget.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> implements TetrisUI {
  static const int kTickAiDuration = 100;

  Game _game;
  bool _vertDragConsumed = false;
  double _horizDragDelta = 0;
  AssetsAudioPlayer _assetsAudioPlayer;
  Player _player;

  @override
  void initState() {
    super.initState();
    _player = new GeneticPlayer(ui: this);
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.loop = true;
    /*_assetsAudioPlayer.open(
      Audio('assets/sounds/theme.mp3'),
      volume: 0.5,
    );*/
    _player.startGame();
  }

  @override
  void setCurrentGame(Game game) {
    setState(() {
      _game = game;
    });
  }

  @override
  Widget build(BuildContext context) {
    // calc stats
    Stats stats = Stats.from(game: _game);
    String linesToPieces = '-';
    if (_game.linesCompleted > 0) {
      linesToPieces = NumberUtils.toPrecision(_game.tetrominos / _game.linesCompleted, 2).toString();
    }

    // next tetromino
    List<List<TetrominoType>> nextTetrominoBlocks = _game.nextTetromino?.blocks;
    List<List<TetrominoType>> nextTetrominoColors = List.generate(nextTetrominoBlocks.length, (j) {
      return List.generate(nextTetrominoBlocks[j].length, (i) {
        return nextTetrominoBlocks[j][i] != null ? _game.nextTetromino.type : null;
      });
    });

    return Scaffold(
      body: Decorator(
        paddingTop: 40,
        alignment: Alignment.topCenter,
        backgroundColor: Colors.black,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Score(title: 'LEVEL', value: _game.currentLevel),
                _player.userCanInteract
                    ? Score(
                        title: 'SCORE',
                        value: _game.score,
                      )
                    : Score(
                        title: 'PIECES',
                        value: _game.tetrominos,
                      ),
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
              height: 24,
            ),
            GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                if (_player.userCanInteract) {
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
                }
              },
              onHorizontalDragEnd: (_) => _horizDragDelta = 0,
              onHorizontalDragCancel: () => _horizDragDelta = 0,
              onVerticalDragStart: (_) => _vertDragConsumed = false,
              onVerticalDragUpdate: (DragUpdateDetails details) {
                if (_player.userCanInteract) {
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
                }
              },
              onVerticalDragEnd: (_) => _vertDragConsumed = false,
              onVerticalDragCancel: () => _vertDragConsumed = false,
              child: BoardWidget(
                game: _game,
              ),
              onTap: () {
                _player.onBoardTap();
              },
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIUtils.text('hol: ${stats.totalHoles}/${stats.connectedHoles}'),
                      UIUtils.text('wel: ${stats.maxWell}/${stats.sumWells}'),
                      UIUtils.text('min: ${stats.minHeight}'),
                      UIUtils.text('max: ${stats.maxHeight}'),
                      UIUtils.text('avg: ${stats.avgHeight}'),
                      UIUtils.text('std: ${stats.heightSD}'),
                      UIUtils.text('l/t: $linesToPieces'),
                    ],
                  ),
                ),
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 4,
                  child: UIUtils.text(_player.getInfo() ?? ''),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void currentPieceDone() {
    _horizDragDelta = 0;
    _vertDragConsumed = true;
  }

  @override
  void stateUpdateNeeded() {
    setState(() {});
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
