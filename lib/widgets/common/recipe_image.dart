part of '../../main.dart';

class RecipeImage extends StatelessWidget {
  const RecipeImage({
    required this.imageBase64,
    this.size,
    this.height,
    super.key,
  });

  final String imageBase64;
  final double? size;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final savedImage = imageBase64.trim();
    final borderRadius = BorderRadius.circular(8);
    final width = size ?? double.infinity;
    final resolvedHeight = size ?? height ?? 160;

    Widget child;
    if (savedImage.isEmpty) {
      child = const _ImagePlaceholder();
    } else {
      try {
        child = Image.memory(
          base64Decode(savedImage),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const _ImagePlaceholder(),
        );
      } on FormatException {
        child = const _ImagePlaceholder();
      }
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: resolvedHeight,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: child,
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.dining,
        size: 40,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
