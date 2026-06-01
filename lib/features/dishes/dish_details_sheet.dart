part of '../../main.dart';

class DishDetailsSheet extends StatelessWidget {
  const DishDetailsSheet({
    required this.dish,
    required this.onEdit,
    super.key,
  });

  final Dish dish;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ThemedRecipeSheet(
      child: RecipeDetailsScaffold(
        title: dish.name,
        imageBase64: dish.imageBase64,
        onEdit: onEdit,
        sections: [
          DetailSection(
            title: 'Ingredients',
            children: dish.ingredients
                .map(
                  (ingredient) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(ingredient.name),
                    trailing: ingredient.amount.isEmpty
                        ? null
                        : Text('${ingredient.amount} ${ingredient.unit}'),
                  ),
                )
                .toList(),
          ),
          DetailSection(
            title: 'Cooking steps',
            children: numberedTiles(dish.steps),
          ),
        ],
      ),
    );
  }
}
