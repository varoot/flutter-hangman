import 'package:flutter/material.dart';
import 'hangman_painter.dart';

class HangmanPaint extends StatefulWidget {
  HangmanPaint({Key? key, required this.step}) : super(key: key);

  final int step;

  @override
  _HangmanPaintState createState() => _HangmanPaintState();
}

const animationDuration = Duration(milliseconds: 250);
const swingDuration = Duration(seconds: 2);

class _HangmanPaintState extends State<HangmanPaint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: animationDuration,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HangmanPaint oldWidget) {
    if (oldWidget.step < widget.step) {
      _controller
          .animateTo(widget.step * stepValue, duration: animationDuration)
          .then((value) {
        if (widget.step == 10) {
          _controller.repeat(
              min: 10 * stepValue, max: 1.0, period: swingDuration);
        }
      });
    } else if (oldWidget.step > widget.step) {
      _controller.animateBack(widget.step * stepValue,
          duration: animationDuration);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return CustomPaint(
      painter: HangmangPainter(_controller.value),
      size: const Size(200.0, 200.0),
    );
  }
}
