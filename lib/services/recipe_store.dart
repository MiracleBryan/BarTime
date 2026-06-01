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

    try {
      final decoded = jsonDecode(savedJson) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Dish.fromJson)
          .toList();
    } on FormatException {
      await preferences.remove(_dishStorageKey);
      return [];
    } on TypeError {
      await preferences.remove(_dishStorageKey);
      return [];
    }
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

    try {
      final decoded = jsonDecode(savedJson) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Cocktail.fromJson)
          .toList();
    } on FormatException {
      await preferences.remove(_cocktailStorageKey);
      return [];
    } on TypeError {
      await preferences.remove(_cocktailStorageKey);
      return [];
    }
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

    try {
      final decoded = jsonDecode(savedJson) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(CocktailMemory.fromJson)
          .toList();
    } on FormatException {
      await preferences.remove(_cocktailMemoryStorageKey);
      return [];
    } on TypeError {
      await preferences.remove(_cocktailMemoryStorageKey);
      return [];
    }
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
