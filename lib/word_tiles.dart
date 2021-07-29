import 'dart:math';
import 'package:flutter/material.dart';

const animationDuration = Duration(milliseconds: 250);
const tileMinWidth = 12.0;
const tileMaxWidth = 32.0;
const tileHeight = 30.0;

class WordTiles extends StatelessWidget {
  WordTiles(
      {Key? key,
      required this.guesses,
      required this.word,
      required this.revealed})
      : super(key: key);

  final String word;
  final bool revealed;
  final Set<String> guesses;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: tileMinWidth * this.word.length,
        maxWidth: tileMaxWidth * this.word.length,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: this.word.characters.map((char) {
          final isGuessed = guesses.contains(char);
          return Flexible(
            child: Container(
              alignment: Alignment.center,
              child: Stack(children: [
                AnimatedPositioned(
                  left: 0.0,
                  right: 0.0,
                  top: isGuessed || revealed ? 6.0 : tileHeight,
                  curve: Curves.easeOutBack,
                  duration: animationDuration,
                  child: Text(
                    char,
                    style: TextStyle(
                        color: isGuessed
                            ? Colors.grey.shade900
                            : Colors.red.shade600,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              ]),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade600)),
              ),
              height: tileHeight,
              margin: EdgeInsets.symmetric(
                  horizontal: max(1.0, 20.0 / this.word.length)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
