part of '../../main.dart';

class ThemedRecipeSheet extends StatelessWidget {
  const ThemedRecipeSheet({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: radius.topLeft,
        topRight: radius.topRight,
      ),
      child: ColoredBox(
        color: const Color(0xFFF8FCFF),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: _SheetCloudPainter(),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.22),
                    width: 2,
                  ),
                ),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetCloudPainter extends CustomPainter {
  const _SheetCloudPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF8FCFF),
          Color(0xFFFFF7FB),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final cloudPaint = Paint()..color = const Color(0x99FFFFFF);
    final bluePaint = Paint()..color = const Color(0x338ECDF7);
    final pinkPaint = Paint()..color = const Color(0x44FFD7E8);

    _drawBubbleCloud(
      canvas,
      Offset(size.width * 0.18, 54),
      28,
      cloudPaint,
    );
    _drawBubbleCloud(
      canvas,
      Offset(size.width * 0.82, 92),
      32,
      cloudPaint,
    );
    _drawBubbleCloud(
      canvas,
      Offset(size.width * 0.72, size.height - 62),
      30,
      bluePaint,
    );

    canvas.drawCircle(
        Offset(size.width * 0.12, size.height * 0.62), 38, pinkPaint);
    canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.38), 46, bluePaint);
    _drawTinyStar(canvas, Offset(size.width * 0.88, 34), 8);
    _drawTinyStar(canvas, Offset(size.width * 0.08, 116), 7);
  }

  void _drawBubbleCloud(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    canvas.drawCircle(
        center + Offset(-radius * 0.75, radius * 0.1), radius * 0.55, paint);
    canvas.drawCircle(
        center + Offset(-radius * 0.1, -radius * 0.12), radius * 0.75, paint);
    canvas.drawCircle(
        center + Offset(radius * 0.65, radius * 0.08), radius * 0.52, paint);
  }

  void _drawTinyStar(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = const Color(0xFFFFC9DF);
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius * 0.32, center.dy - radius * 0.32)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx + radius * 0.32, center.dy + radius * 0.32)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius * 0.32, center.dy + radius * 0.32)
      ..lineTo(center.dx - radius, center.dy)
      ..lineTo(center.dx - radius * 0.32, center.dy - radius * 0.32)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
