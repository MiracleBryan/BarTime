part of '../main.dart';

class MenuHomeScreen extends StatefulWidget {
  const MenuHomeScreen({super.key});

  @override
  State<MenuHomeScreen> createState() => _MenuHomeScreenState();
}

class _MenuHomeScreenState extends State<MenuHomeScreen> {
  final RecipeStore _store = RecipeStore();
  final List<Dish> _dishes = [];
  final List<Cocktail> _cocktails = [];
  final List<CocktailMemory> _cocktailMemories = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final results = await Future.wait([
      _store.loadDishes(),
      _store.loadCocktails(),
      _store.loadCocktailMemories(),
    ]);

    setState(() {
      _dishes
        ..clear()
        ..addAll(results[0] as List<Dish>);
      _cocktails
        ..clear()
        ..addAll(results[1] as List<Cocktail>);
      _cocktailMemories
        ..clear()
        ..addAll(results[2] as List<CocktailMemory>);
      _isLoading = false;
    });
  }

  Future<void> _saveDishes() async {
    await _store.saveDishes(_dishes);
  }

  Future<void> _saveCocktails() async {
    await _store.saveCocktails(_cocktails);
  }

  Future<void> _saveCocktailMemories() async {
    await _store.saveCocktailMemories(_cocktailMemories);
  }

  Future<void> _openDishForm({Dish? dish}) async {
    final savedDish = await showModalBottomSheet<Dish>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemedRecipeSheet(
        child: DishFormSheet(dish: dish),
      ),
    );

    if (savedDish == null) {
      return;
    }

    setState(() {
      final existingIndex =
          _dishes.indexWhere((currentDish) => currentDish.id == savedDish.id);
      if (existingIndex == -1) {
        _dishes.insert(0, savedDish);
      } else {
        _dishes[existingIndex] = savedDish;
      }
    });

    await _saveDishes();
  }

  Future<void> _openCocktailForm({Cocktail? cocktail}) async {
    final savedCocktail = await showModalBottomSheet<Cocktail>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemedRecipeSheet(
        child: CocktailFormSheet(cocktail: cocktail),
      ),
    );

    if (savedCocktail == null) {
      return;
    }

    setState(() {
      final existingIndex = _cocktails.indexWhere(
        (currentCocktail) => currentCocktail.id == savedCocktail.id,
      );
      if (existingIndex == -1) {
        _cocktails.insert(0, savedCocktail);
      } else {
        _cocktails[existingIndex] = savedCocktail;
      }
    });

    await _saveCocktails();
  }

  Future<void> _openCocktailMemoryForm({
    DateTime? initialDate,
    CocktailMemory? memory,
  }) async {
    final savedMemory = await showModalBottomSheet<CocktailMemory>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemedRecipeSheet(
        child: CocktailMemoryFormSheet(
          initialDate: initialDate,
          memory: memory,
        ),
      ),
    );

    if (savedMemory == null) {
      return;
    }

    setState(() {
      final existingIndex = _cocktailMemories.indexWhere(
        (currentMemory) => currentMemory.id == savedMemory.id,
      );
      if (existingIndex == -1) {
        _cocktailMemories.insert(0, savedMemory);
      } else {
        _cocktailMemories[existingIndex] = savedMemory;
      }
      _cocktailMemories.sort((a, b) => b.date.compareTo(a.date));
    });

    await _saveCocktailMemories();
  }

  Future<void> _deleteDish(Dish dish) async {
    setState(() {
      _dishes.removeWhere((currentDish) => currentDish.id == dish.id);
    });
    await _saveDishes();
  }

  Future<void> _deleteCocktail(Cocktail cocktail) async {
    setState(() {
      _cocktails.removeWhere(
        (currentCocktail) => currentCocktail.id == cocktail.id,
      );
    });
    await _saveCocktails();
  }

  Future<void> _deleteCocktailMemory(CocktailMemory memory) async {
    setState(() {
      _cocktailMemories.removeWhere(
        (currentMemory) => currentMemory.id == memory.id,
      );
    });
    await _saveCocktailMemories();
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (_selectedIndex) {
      0 => 'Menu Book',
      1 => 'Cocktails',
      _ => 'Bar Calendar',
    };
    final addTooltip = switch (_selectedIndex) {
      0 => 'Add dish',
      1 => 'Add cocktail',
      _ => 'Add footprint',
    };
    final addLabel = switch (_selectedIndex) {
      0 => 'Add dish',
      1 => 'Add cocktail',
      _ => 'Add footprint',
    };
    final addAction = switch (_selectedIndex) {
      0 => () => _openDishForm(),
      1 => () => _openCocktailForm(),
      _ => () => _openCocktailMemoryForm(),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: addTooltip,
            onPressed: addAction,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: CinnamorollBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : IndexedStack(
                index: _selectedIndex,
                children: [
                  _dishes.isEmpty
                      ? EmptyCollection(
                          icon: Icons.restaurant_menu,
                          title: 'No dishes yet',
                          message:
                              'Start your first recipe with ingredients, cooking steps, and a dish image.',
                          buttonLabel: 'Add dish',
                          onAdd: () => _openDishForm(),
                        )
                      : DishList(
                          dishes: _dishes,
                          onOpen: _showDishDetails,
                          onEdit: (dish) => _openDishForm(dish: dish),
                          onDelete: _deleteDish,
                        ),
                  _cocktails.isEmpty
                      ? EmptyCollection(
                          icon: Icons.local_bar,
                          title: 'No cocktails yet',
                          message:
                              'Save your cocktail specs with measured ingredients, steps, and a picture.',
                          buttonLabel: 'Add cocktail',
                          onAdd: () => _openCocktailForm(),
                        )
                      : CocktailList(
                          cocktails: _cocktails,
                          onOpen: _showCocktailDetails,
                          onEdit: (cocktail) =>
                              _openCocktailForm(cocktail: cocktail),
                          onDelete: _deleteCocktail,
                        ),
                  CocktailCalendarView(
                    memories: _cocktailMemories,
                    onAddMemory: () => _openCocktailMemoryForm(),
                    onAddMemoryForDate: (date) =>
                        _openCocktailMemoryForm(initialDate: date),
                    onEditMemory: (memory) =>
                        _openCocktailMemoryForm(memory: memory),
                    onDeleteMemory: _deleteCocktailMemory,
                  ),
                ],
              ),
      ),
      floatingActionButton: _selectedIndex == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: addAction,
              icon: const Icon(Icons.add),
              label: Text(addLabel),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant),
            label: 'Dishes',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_bar),
            label: 'Cocktails',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }

  void _showDishDetails(Dish dish) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DishDetailsSheet(
        dish: dish,
        onEdit: () {
          Navigator.of(context).pop();
          _openDishForm(dish: dish);
        },
      ),
    );
  }

  void _showCocktailDetails(Cocktail cocktail) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CocktailDetailsSheet(
        cocktail: cocktail,
        onEdit: () {
          Navigator.of(context).pop();
          _openCocktailForm(cocktail: cocktail);
        },
      ),
    );
  }
}
