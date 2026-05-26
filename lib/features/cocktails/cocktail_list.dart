part of '../../main.dart';

class CocktailList extends StatelessWidget {
  const CocktailList({
    required this.cocktails,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<Cocktail> cocktails;
  final ValueChanged<Cocktail> onOpen;
  final ValueChanged<Cocktail> onEdit;
  final ValueChanged<Cocktail> onDelete;

  @override
  Widget build(BuildContext context) {
    return RecipeList(
      itemCount: cocktails.length,
      itemBuilder: (context, index) {
        final cocktail = cocktails[index];
        return RecipeCard(
          title: cocktail.name,
          subtitle: '${cocktail.ingredients.length} ingredients • '
              '${cocktail.steps.length} steps',
          imageUrl: cocktail.imageUrl,
          chips: cocktail.ingredients
              .take(3)
              .map((ingredient) => ingredient.displayText)
              .toList(),
          actionsTooltip: 'Cocktail actions',
          onOpen: () => onOpen(cocktail),
          onEdit: () => onEdit(cocktail),
          onDelete: () => onDelete(cocktail),
        );
      },
    );
  }
}
