import 'package:flutter/material.dart';
import 'package:hangman_game/keyboard_letter.dart';
import 'keyboard_letter.dart';

const letters = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

typedef PressHandler = void Function(String char);

class KeyboardRow extends StatefulWidget {
  KeyboardRow(
      {Key? key,
      required this.guesses,
      required this.word,
      required this.disabled,
      required this.onPressed})
      : super(key: key);

  final String word;
  final Set<String> guesses;
  final bool disabled;
  final PressHandler onPressed;

  @override
  _KeyboardRowState createState() => _KeyboardRowState();
}

class _KeyboardRowState extends State<KeyboardRow> {
  late List<KeyboardLetter> _letterWidgets;

  @override
  void initState() {
    super.initState();
    _letterWidgets = getLetterWidgets();
  }

  List<KeyboardLetter> getLetterWidgets([List<KeyboardLetter>? prevList]) {
    if (prevList == null) {
      return letters
          .map((char) => KeyboardLetter(
              key: ValueKey(char),
              char: char,
              isCorrect: widget.word.contains(char),
              isGuessed: widget.guesses.contains(char),
              disabled: !widget.guesses.contains(char) && widget.disabled,
              onPressed: widget.onPressed))
          .toList();
    }

    // Only recreate widgets that require update for better performance
    return prevList.map((letterWidget) {
      final char = letterWidget.char;
      final isCorrect = widget.word.contains(char);
      final isGuessed = widget.guesses.contains(char);

      if (letterWidget.isCorrect == isCorrect &&
          letterWidget.isGuessed == isGuessed &&
          (isGuessed || letterWidget.disabled == widget.disabled)) {
        return letterWidget;
      }

      return KeyboardLetter(
        key: ValueKey(char),
        char: char,
        isCorrect: isCorrect,
        isGuessed: isGuessed,
        disabled: !isGuessed && widget.disabled,
        onPressed: widget.onPressed,
      );
    }).toList();
  }

  @override
  void didUpdateWidget(covariant KeyboardRow oldWidget) {
    if (oldWidget.guesses != widget.guesses ||
        oldWidget.disabled != widget.disabled ||
        oldWidget.word != widget.word) {
      setState(() {
        _letterWidgets = getLetterWidgets(_letterWidgets);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 4.0,
      spacing: 4.0,
      children: _letterWidgets,
    );
  }
}
