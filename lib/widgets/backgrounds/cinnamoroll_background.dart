part of '../../main.dart';

class CinnamorollBackground extends StatelessWidget {
  const CinnamorollBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/mamoru_background.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFF7FB).withValues(alpha: 0.34),
                const Color(0xFFFFFBF4).withValues(alpha: 0.64),
                const Color(0xFFE8F7FF).withValues(alpha: 0.38),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
