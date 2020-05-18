import 'package:flutter/material.dart';
import 'package:tetris/screens/game.dart';

void main() => runApp(TetrisApp());

class TetrisApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: GameScreen()
    );
  }
}
