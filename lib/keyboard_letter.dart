import 'package:flutter/material.dart';

typedef PressHandler = void Function(String char);

class KeyboardLetter extends StatelessWidget {
  KeyboardLetter(
      {Key? key,
      required this.char,
      required this.isCorrect,
      required this.isGuessed,
      required this.disabled,
      required this.onPressed})
      : super(key: key);

  final String char;
  final bool isCorrect;
  final bool isGuessed;
  final bool disabled;
  final PressHandler onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ValueKey(char),
      height: 32,
      width: 32,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: TextButton(
          key: ValueKey(disabled ? 'disabled' : 'default'),
          child: Text(char),
          onPressed: isGuessed || disabled
              ? null
              : () {
                  onPressed(char);
                },
          style: TextButton.styleFrom(
            backgroundColor: isGuessed
                ? null
                : (disabled
                    ? Colors.grey.shade400
                    : Theme.of(context).primaryColor),
            onSurface: isGuessed
                ? (isCorrect ? Colors.teal.shade500 : Colors.red.shade600)
                : Colors.white,
            padding: EdgeInsets.zero,
            primary: Theme.of(context).primaryTextTheme.button?.color,
            shape: CircleBorder(),
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
