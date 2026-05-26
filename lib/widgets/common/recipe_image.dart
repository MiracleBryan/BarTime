part of '../../main.dart';

class RecipeImage extends StatelessWidget {
  const RecipeImage({
    required this.url,
    this.size,
    this.height,
    super.key,
  });

  final String url;
  final double? size;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url.trim();
    final borderRadius = BorderRadius.circular(8);
    final width = size ?? double.infinity;
    final resolvedHeight = size ?? height ?? 160;

    Widget child;
    if (imageUrl.isEmpty) {
      child = const _ImagePlaceholder();
    } else {
      child = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
      );
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
