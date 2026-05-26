part of '../../main.dart';

class FormHeader extends StatelessWidget {
  const FormHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFFB8E1FF),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(Icons.cloud, color: Color(0xFF8ECDF7)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF3E7FA8),
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    );
  }
}
