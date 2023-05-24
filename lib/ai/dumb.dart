import 'package:tetris/ai/ai.dart';
import 'package:tetris/model/game.dart';

class DumbAI extends Pajitnov with MovePlayer {
  @override
  Move selectMove(Game game, List<Move> moves) {
    moves.shuffle();
    return moves[0];
  }
}
