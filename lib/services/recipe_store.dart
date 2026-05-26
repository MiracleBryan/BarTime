part of '../main.dart';

class RecipeStore {
  static const _dishStorageKey = 'dishes';
  static const _cocktailStorageKey = 'cocktails';
  static const _cocktailMemoryStorageKey = 'cocktail_memories';

  Future<List<Dish>> loadDishes() async {
    final preferences = await SharedPreferences.getInstance();
    final savedJson = preferences.getString(_dishStorageKey);

    if (savedJson == null) {
      return [];
    }

    final decoded = jsonDecode(savedJson) as List<dynamic>;
    return decoded
        .map((item) => Dish.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveDishes(List<Dish> dishes) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(dishes.map((dish) => dish.toJson()).toList());
    await preferences.setString(_dishStorageKey, encoded);
  }

  Future<List<Cocktail>> loadCocktails() async {
    final preferences = await SharedPreferences.getInstance();
    final savedJson = preferences.getString(_cocktailStorageKey);

    if (savedJson == null) {
      return [];
    }

    final decoded = jsonDecode(savedJson) as List<dynamic>;
    return decoded
        .map((item) => Cocktail.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCocktails(List<Cocktail> cocktails) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      cocktails.map((cocktail) => cocktail.toJson()).toList(),
    );
    await preferences.setString(_cocktailStorageKey, encoded);
  }

  Future<List<CocktailMemory>> loadCocktailMemories() async {
    final preferences = await SharedPreferences.getInstance();
    final savedJson = preferences.getString(_cocktailMemoryStorageKey);

    if (savedJson == null) {
      return [];
    }

    final decoded = jsonDecode(savedJson) as List<dynamic>;
    return decoded
        .map((item) => CocktailMemory.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCocktailMemories(
    List<CocktailMemory> cocktailMemories,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      cocktailMemories.map((memory) => memory.toJson()).toList(),
    );
    await preferences.setString(_cocktailMemoryStorageKey, encoded);
  }
}
