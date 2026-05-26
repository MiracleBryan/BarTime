part of '../../main.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.save),
        label: Text(label),
      ),
    );
  }
}
