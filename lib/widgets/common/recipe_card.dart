part of '../../main.dart';

class RecipeList extends StatelessWidget {
  const RecipeList({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: itemBuilder,
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.chips,
    required this.actionsTooltip,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final List<String> chips;
  final String actionsTooltip;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeImage(url: imageUrl, size: 104),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: chips
                          .map(
                            (chip) => Chip(
                              label: Text(chip),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<_RecipeAction>(
              tooltip: actionsTooltip,
              onSelected: (action) {
                switch (action) {
                  case _RecipeAction.edit:
                    onEdit();
                  case _RecipeAction.delete:
                    onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _RecipeAction.edit,
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: _RecipeAction.delete,
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _RecipeAction { edit, delete }
