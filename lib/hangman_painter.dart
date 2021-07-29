import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

const lineWidth = 3.0;
const stepValue = 1.0 / 11.0;

class HangmangPainter extends CustomPainter {
  HangmangPainter(this.value) : super();

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final offset = lineWidth;
    final totalSize = size.width - (offset * 2);

    final paint = Paint()
      ..color = Colors.grey.shade800
      ..strokeCap = StrokeCap.round
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    double getValueForStep(int stepId) {
      final lowerBound = (stepId - 1) * stepValue;
      final upperBound = stepId * stepValue;
      if (value <= lowerBound) return 0.0;
      if (value >= upperBound) return 1.0;
      return (value - lowerBound) / stepValue;
    }

    final lastStepValue = getValueForStep(11);

    final pole = Offset(offset + totalSize * 0.15, offset);
    final rope = Offset(offset + totalSize * 0.65, pole.dy);
    final man = Offset(rope.dx, offset + totalSize * 0.3);
    final headRadius = totalSize * 0.1;
    final bodyLen = totalSize * 0.20;
    final limpX = totalSize * 0.15;
    final limpY = totalSize * 0.15;

    void line(int stepId, Offset offset1, Offset offset2) {
      final currentValue = getValueForStep(stepId);
      if (currentValue > 0.0) {
        final finalPoint = currentValue == 1.0
            ? offset2
            : Offset(
                (offset2.dx - offset1.dx) * currentValue + offset1.dx,
                (offset2.dy - offset1.dy) * currentValue + offset1.dy,
              );
        canvas.drawLine(offset1, finalPoint, paint);
      }
    }

    void circle(int stepId, Offset offset, double radius) {
      final currentValue = getValueForStep(stepId);
      if (currentValue >= 1.0) {
        canvas.drawCircle(offset, radius, paint);
      } else if (currentValue > 0.0) {
        canvas.drawArc(Rect.fromCircle(center: offset, radius: radius),
            pi * -0.5, currentValue * 2.5 * pi, false, paint);
      }
    }

    final rad = sin(lastStepValue * 2 * pi) * pi / 90;
    final cosRad = cos(rad);
    final sinRad = sin(rad);
    Offset swingTranspose(Offset offset) {
      final x = offset.dx - rope.dx;
      final y = offset.dy - rope.dy;
      return Offset((x * cosRad) - (y * sinRad) + rope.dx,
          (y * cosRad) + (x * sinRad) + rope.dy);
    }

    line(1, Offset(offset, totalSize + offset),
        Offset(totalSize + offset, totalSize + offset));

    line(2, Offset(pole.dx, totalSize + offset), pole);

    line(3, pole, Offset(rope.dx + headRadius, pole.dy));

    line(4, rope, swingTranspose(Offset(man.dx, man.dy - headRadius)));

    circle(5, swingTranspose(man), headRadius);

    line(6, swingTranspose(Offset(man.dx, man.dy + headRadius)),
        swingTranspose(Offset(man.dx, man.dy + headRadius + bodyLen)));

    line(7, swingTranspose(Offset(man.dx, man.dy + headRadius)),
        swingTranspose(Offset(man.dx - limpX, man.dy + headRadius + limpY)));

    line(8, swingTranspose(Offset(man.dx, man.dy + headRadius)),
        swingTranspose(Offset(man.dx + limpX, man.dy + headRadius + limpY)));

    line(
        9,
        swingTranspose(Offset(man.dx, man.dy + headRadius + bodyLen)),
        swingTranspose(
            Offset(man.dx - limpX, man.dy + headRadius + bodyLen + limpY)));

    line(
        10,
        swingTranspose(Offset(man.dx, man.dy + headRadius + bodyLen)),
        swingTranspose(
            Offset(man.dx + limpX, man.dy + headRadius + bodyLen + limpY)));
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      Rect rect = Offset.zero & size;
      final double width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRepaint(HangmangPainter oldDelegate) =>
      oldDelegate.value != this.value;

  @override
  bool shouldRebuildSemantics(HangmangPainter oldDelegate) => false;
}
