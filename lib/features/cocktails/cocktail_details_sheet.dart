part of '../../main.dart';

class CocktailDetailsSheet extends StatelessWidget {
  const CocktailDetailsSheet({
    required this.cocktail,
    required this.onEdit,
    super.key,
  });

  final Cocktail cocktail;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ThemedRecipeSheet(
      child: RecipeDetailsScaffold(
        title: cocktail.name,
        imageUrl: cocktail.imageUrl,
        onEdit: onEdit,
        sections: [
          DetailSection(
            title: 'Ingredients',
            children: cocktail.ingredients
                .map(
                  (ingredient) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.scale),
                    title: Text(ingredient.name),
                    trailing: ingredient.amount.isEmpty
                        ? null
                        : Text('${ingredient.amount} ${ingredient.unit}'),
                  ),
                )
                .toList(),
          ),
          DetailSection(
            title: 'Mixing steps',
            children: numberedTiles(cocktail.steps),
          ),
        ],
      ),
    );
  }
}
