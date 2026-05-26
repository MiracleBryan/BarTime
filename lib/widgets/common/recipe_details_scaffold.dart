part of '../../main.dart';

class RecipeDetailsScaffold extends StatelessWidget {
  const RecipeDetailsScaffold({
    required this.title,
    required this.imageUrl,
    required this.onEdit,
    required this.sections,
    super.key,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onEdit;
  final List<DetailSection> sections;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                tooltip: 'Edit',
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
              ),
              const SizedBox(width: 4),
              IconButton.filledTonal(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RecipeImage(url: imageUrl, height: 220),
          const SizedBox(height: 24),
          ...sections.expand(
            (section) => [
              Text(section.title,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...section.children,
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailSection {
  const DetailSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;
}
