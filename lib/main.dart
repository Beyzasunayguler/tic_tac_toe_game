import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(TicTacToeMainGame());
}

const firstPlayerSign = 'X';
const secondPlayerSign = 'O';

class TicTacToeMainGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tic Tac Toe',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple[900],
          centerTitle: true,
        ),
        body: TicTacToeMainWidget(),
      ),
    );
  }
}

class TicTacToeMainWidget extends StatefulWidget {
  @override
  _TicTacToeMainWidgetState createState() => _TicTacToeMainWidgetState();
}

class _TicTacToeMainWidgetState extends State<TicTacToeMainWidget> {
  bool isFirstPlayersTurn = true;
  List<List<String>> game;
  GameStatus gameStatus;

  @override
  void initState() {
    game = [
      ['', '', ''],
      ['', '', ''],
      ['', '', ''],
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (gameStatus != null &&
        (gameStatus.isGameFinished || gameStatus.isDraw)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(gameStatus.isGameFinished
                  ? 'Game finished!'
                  : 'It is a draw!'),
              content: Text(gameStatus.isGameFinished
                  ? isFirstPlayersTurn
                      ? 'Second player won the game!'
                      : 'First player won the game!'
                  : 'Let us try again!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    game = [
                      ['', '', ''],
                      ['', '', ''],
                      ['', '', ''],
                    ];
                    gameStatus = null;
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ],
            );
          }));
    }
    return Center(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          shrinkWrap: true,
          itemCount: 9,
          itemBuilder: (_, int position) {
            return GestureDetector(
              onTap: () {
                final horizontalPosition = position % 3;
                final verticalPosition = (position / 3).floor();
                if (!fieldAlreadyFilled(verticalPosition, horizontalPosition)) {
                  final textToPut =
                      isFirstPlayersTurn ? firstPlayerSign : secondPlayerSign;
                  // print('put $textToPut');
                  isFirstPlayersTurn = !isFirstPlayersTurn;
                  game[verticalPosition][horizontalPosition] = textToPut;
                  gameStatus = checkGameFinished(
                      textToPut, verticalPosition, horizontalPosition);
                  setState(() {});
                }
              },
              child: Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.all(10),
                color: position % 2 == 0 ? Colors.red : Colors.green,
                child: Center(
                  child: Text(
                    getTextForHere(position),
                    style: TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
    );
  }

  bool fieldAlreadyFilled(int verticalPosition, int horizontalPosition) {
    return game[verticalPosition][horizontalPosition].isNotEmpty;
  }

  GameStatus checkGameFinished(
    String currentText,
    int verticalPosition,
    int horizontalPosition,
  ) {
    final verticalResult =
        isFinishedHorizontally(horizontalPosition, currentText);

    final horizontalResult =
        isFinishedVertically(verticalPosition, currentText);

    final diagonalResult =
        isFinishedDiagonally(verticalPosition, horizontalPosition, currentText);

    final isGameFinished = verticalResult || horizontalResult || diagonalResult;
    return GameStatus(
      isGameFinished: isGameFinished,
      isDraw: !isGameFinished && isDraw(),
    );
  }

  bool isDraw() {
    for (int i = 0; i < game.length; i++) {
      final horizontal = game[i];
      for (int j = 0; j < horizontal.length; j++) {
        final element = game[i][j];
        if (element.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  bool isFinishedHorizontally(int horizontalPosition, String currentText) {
    final verticalGame = [
      game[0][horizontalPosition],
      game[1][horizontalPosition],
      game[2][horizontalPosition],
    ];
    return verticalGame
            .where((element) => element == currentText)
            .toList()
            .length ==
        verticalGame.length;
  }

  bool isFinishedVertically(int verticalPosition, String currentText) {
    final horizontalGame = game[verticalPosition];
    return horizontalGame
            .where((element) => element == currentText)
            .toList()
            .length ==
        horizontalGame.length;
  }

  bool isFinishedDiagonally(
      int verticalPosition, int horizontalPosition, String currentText) {
    final intervalBetweenPositions =
        (horizontalPosition - verticalPosition).abs();
    if (intervalBetweenPositions == 2 || intervalBetweenPositions == 0) {
      final diagonalBottom = [game[0][0], game[1][1], game[2][2]];
      final diagonalTop = [game[0][2], game[1][1], game[2][0]];
      return (diagonalBottom
                  .where((element) => element == currentText)
                  .toList()
                  .length ==
              diagonalBottom.length ||
          diagonalTop
                  .where((element) => element == currentText)
                  .toList()
                  .length ==
              diagonalTop.length);
    } else {
      return false;
    }
  }

  String getTextForHere(int position) {
    final horizontalPosition = position % 3;
    final verticalPosition = (position / 3).floor();
    return game[verticalPosition][horizontalPosition];
  }
}

class GameStatus {
  final bool isGameFinished;
  final bool isDraw;

  GameStatus({
    @required this.isGameFinished,
    @required this.isDraw,
  });
}
