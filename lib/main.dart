import 'dart:math';
import 'package:flutter/material.dart';
import 'hangman_paint.dart';
import 'keyboard_row.dart';
import 'word_tiles.dart';
import 'words.dart';

void main() {
  runApp(HangmanApp());
}

class HangmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HangmanGame(title: 'Hangman Game'),
    );
  }
}

class HangmanGame extends StatefulWidget {
  HangmanGame({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HangmanGameState createState() => _HangmanGameState();
}

enum GameStatus {
  running,
  won,
  lost,
}

const animationDuration = Duration(milliseconds: 250);
const opacityDuration = Duration(milliseconds: 200);

class _HangmanGameState extends State<HangmanGame>
    with SingleTickerProviderStateMixin {
  final _random = new Random();
  String _word = '';
  double _wordOpacity = 0.0;
  Set<String> _guesses = Set();
  GameStatus _status = GameStatus.running;
  int _incorrectGuessCount = 0;

  @override
  void initState() {
    super.initState();
    _word = words[_random.nextInt(words.length)].toUpperCase();
    _wordOpacity = 1.0;
  }

  void _onKeyPressed(String char) {
    if (_status != GameStatus.running) return;
    setState(() {
      _guesses = _guesses.toSet()..add(char);
      if (_word.contains(char)) {
        if (_word.characters.every((char) => _guesses.contains(char))) {
          _status = GameStatus.won;
        }
      } else {
        _incorrectGuessCount++;
        if (_incorrectGuessCount >= 10) {
          _status = GameStatus.lost;
        }
      }
    });
  }

  void _resetGame() async {
    setState(() {
      _wordOpacity = 0.0;
    });

    await Future.delayed(opacityDuration);

    setState(() {
      _guesses = Set();
      _status = GameStatus.running;
      _word = words[_random.nextInt(words.length)].toUpperCase();
      _incorrectGuessCount = 0;
      _wordOpacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Flex(
              direction: orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Center(
                    child: HangmanPaint(step: _incorrectGuessCount),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      AnimatedOpacity(
                          opacity: _wordOpacity,
                          curve: Curves.easeInOut,
                          duration: opacityDuration,
                          child: WordTiles(
                              key: ValueKey(_word),
                              guesses: _guesses,
                              revealed: _status == GameStatus.lost,
                              word: _word)),
                      SizedBox(height: 30),
                      KeyboardRow(
                          guesses: _guesses,
                          word: _word,
                          disabled: _status != GameStatus.running,
                          onPressed: _onKeyPressed),
                      SizedBox(height: 10),
                      _status == GameStatus.running
                          ? TextButton(
                              onPressed: _resetGame, child: Text('RESET'))
                          : ElevatedButton(
                              onPressed: _resetGame, child: Text('NEW GAME'))
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
