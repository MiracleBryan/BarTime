part of '../../main.dart';

class DishList extends StatelessWidget {
  const DishList({
    required this.dishes,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<Dish> dishes;
  final ValueChanged<Dish> onOpen;
  final ValueChanged<Dish> onEdit;
  final ValueChanged<Dish> onDelete;

  @override
  Widget build(BuildContext context) {
    return RecipeList(
      itemCount: dishes.length,
      itemBuilder: (context, index) {
        final dish = dishes[index];
        return RecipeCard(
          title: dish.name,
          subtitle: '${dish.ingredients.length} ingredients • '
              '${dish.steps.length} steps',
          imageBase64: dish.imageBase64,
          chips: dish.ingredients
              .take(3)
              .map((ingredient) => ingredient.displayText)
              .toList(),
          actionsTooltip: 'Dish actions',
          onOpen: () => onOpen(dish),
          onEdit: () => onEdit(dish),
          onDelete: () => onDelete(dish),
        );
      },
    );
  }
}
