part of '../../main.dart';

class CinnamorollBackground extends StatelessWidget {
  const CinnamorollBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const CustomPaint(
          painter: _CinnamorollBackgroundPainter(),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.66),
          ),
        ),
        child,
      ],
    );
  }
}

class _CinnamorollBackgroundPainter extends CustomPainter {
  const _CinnamorollBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFDFF4FF),
          Color(0xFFFFF8FC),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, skyPaint);

    _drawCloud(canvas, Offset(size.width * 0.18, size.height * 0.18), 54);
    _drawCloud(canvas, Offset(size.width * 0.78, size.height * 0.27), 44);
    _drawCloud(canvas, Offset(size.width * 0.26, size.height * 0.78), 48);
    _drawCloud(canvas, Offset(size.width * 0.82, size.height * 0.82), 58);

    _drawStar(canvas, Offset(size.width * 0.68, size.height * 0.14), 12);
    _drawStar(canvas, Offset(size.width * 0.11, size.height * 0.43), 9);
    _drawStar(canvas, Offset(size.width * 0.9, size.height * 0.55), 10);

    final characterCenter = Offset(size.width * 0.5, size.height * 0.42);
    final faceWidth = math.min(size.width * 0.54, 260.0);
    final faceHeight = faceWidth * 0.72;
    _drawCinnamorollFace(canvas, characterCenter, faceWidth, faceHeight);
  }

  void _drawCloud(Canvas canvas, Offset center, double radius) {
    final shadowPaint = Paint()..color = const Color(0x338ECDF7);
    final cloudPaint = Paint()..color = const Color(0xFFFFFFFF);

    for (final circle in _cloudCircles(center + const Offset(0, 8), radius)) {
      canvas.drawCircle(circle.$1, circle.$2, shadowPaint);
    }

    for (final circle in _cloudCircles(center, radius)) {
      canvas.drawCircle(circle.$1, circle.$2, cloudPaint);
    }
  }

  List<(Offset, double)> _cloudCircles(Offset center, double radius) {
    return [
      (center + Offset(-radius * 0.9, radius * 0.2), radius * 0.45),
      (center + Offset(-radius * 0.35, -radius * 0.05), radius * 0.62),
      (center + Offset(radius * 0.25, -radius * 0.12), radius * 0.72),
      (center + Offset(radius * 0.85, radius * 0.18), radius * 0.48),
    ];
  }

  void _drawStar(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = const Color(0xFFFFD7E8);
    final path = Path();

    for (var i = 0; i < 8; i += 1) {
      final angle = -math.pi / 2 + i * math.pi / 4;
      final pointRadius = i.isEven ? radius : radius * 0.42;
      final point = Offset(
        center.dx + math.cos(angle) * pointRadius,
        center.dy + math.sin(angle) * pointRadius,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCinnamorollFace(
    Canvas canvas,
    Offset center,
    double width,
    double height,
  ) {
    final outlinePaint = Paint()
      ..color = const Color(0x338ECDF7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final whitePaint = Paint()..color = const Color(0xFFFFFFFF);
    final bluePaint = Paint()..color = const Color(0xFF5DADE2);
    final blushPaint = Paint()..color = const Color(0xFFFFB7D5);

    final leftEar = Rect.fromCenter(
      center: center + Offset(-width * 0.56, -height * 0.02),
      width: width * 0.7,
      height: height * 0.44,
    );
    final rightEar = Rect.fromCenter(
      center: center + Offset(width * 0.56, -height * 0.02),
      width: width * 0.7,
      height: height * 0.44,
    );
    canvas.drawOval(leftEar, whitePaint);
    canvas.drawOval(rightEar, whitePaint);
    canvas.drawOval(leftEar, outlinePaint);
    canvas.drawOval(rightEar, outlinePaint);

    final faceRect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
    canvas.drawOval(faceRect, whitePaint);
    canvas.drawOval(faceRect, outlinePaint);

    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-width * 0.2, -height * 0.08),
        width: width * 0.07,
        height: height * 0.16,
      ),
      bluePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(width * 0.2, -height * 0.08),
        width: width * 0.07,
        height: height * 0.16,
      ),
      bluePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-width * 0.34, height * 0.12),
        width: width * 0.15,
        height: height * 0.08,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(width * 0.34, height * 0.12),
        width: width * 0.15,
        height: height * 0.08,
      ),
      blushPaint,
    );

    final mouthPath = Path()
      ..moveTo(center.dx, center.dy + height * 0.05)
      ..quadraticBezierTo(
        center.dx - width * 0.06,
        center.dy + height * 0.13,
        center.dx - width * 0.13,
        center.dy + height * 0.07,
      )
      ..moveTo(center.dx, center.dy + height * 0.05)
      ..quadraticBezierTo(
        center.dx + width * 0.06,
        center.dy + height * 0.13,
        center.dx + width * 0.13,
        center.dy + height * 0.07,
      );
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = const Color(0xFF5DADE2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
