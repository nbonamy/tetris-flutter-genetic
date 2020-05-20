#!/Users/nbonamy/src/flutter/bin/cache/dart-sdk/bin/dart

import 'dart:io';

import 'package:console/console.dart';
import 'package:tetris/ai/genetic.dart';
import 'package:tetris/model/game.dart';
import 'package:tetris/model/player.dart';

class ConsoleUI extends TetrisUI {

  GeneticPlayer player;
  //int _progress = 0;

  @override
  void currentPieceDone() {
  }

  @override
  void setCurrentGame(Game game) {

    GeneticInfo info = player.geneticInfo;
    if (info == null) {
      return;
    }

    // print it
    //Console.moveCursor(row: 1);
    print('|' + _pad(info.currGeneration) + ' |' + _pad(info.currIndividual) + ' |' + _pad(info.currExperiment) + ' |' + _pad(info.lastScoreInd) + ' |' + _pad(info.bestScoreInd) + ' |' + _pad(info.bestScoreGen) + ' |' + _pad(info.bestScoreEver) + ' |');

    // _reset
    //Console.moveCursor(row: 2, column: 1);
    //Console.eraseLine();
    //_progress = 0;

  }

  @override
  void stateUpdateNeeded() {
    //Console.moveCursor(row: 2, column: ++_progress + 1);
    //stdout.write('.');
  }

  String _pad(int value) {
    String str = value == null ? '-' : value.toString();
    return str.padLeft(8);
  }

}


void main() {

  // console
  Console.init();

  // init
  ConsoleUI console = ConsoleUI();
  GeneticPlayer player = GeneticPlayer(ui: console, multithread: true,);
  console.player = player;

  // catch Ctrl-C
  ProcessSignal.sigint.watch().listen((_) {
    print('\n');
    player.onBoardTap();
    exit(1);
  });

  // now run
  player.startGame();

}
