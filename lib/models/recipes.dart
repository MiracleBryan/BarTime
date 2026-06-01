part of '../main.dart';

class Dish {
  const Dish({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.imageBase64,
  });

  final String id;
  final String name;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final String imageBase64;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'steps': steps,
      'imageBase64': imageBase64,
    };
  }

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as String,
      name: json['name'] as String,
      ingredients: (json['ingredients'] as List)
          .map(RecipeIngredient.fromSavedIngredient)
          .toList(),
      steps: List<String>.from(json['steps'] as List),
      imageBase64: json['imageBase64'] as String? ?? '',
    );
  }
}

class RecipeIngredient {
  const RecipeIngredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  final String name;
  final String amount;
  final String unit;

  String get displayText => amount.isEmpty ? name : '$name $amount $unit';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
    };
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    final savedAmount = json['amount'] as String? ?? json['grams'] as String?;
    return RecipeIngredient(
      name: json['name'] as String,
      amount: savedAmount ?? '',
      unit: json['unit'] as String? ?? 'g',
    );
  }

  factory RecipeIngredient.fromSavedIngredient(Object? savedIngredient) {
    if (savedIngredient is Map<String, dynamic>) {
      return RecipeIngredient.fromJson(savedIngredient);
    }

    return RecipeIngredient(
      name: savedIngredient as String? ?? '',
      amount: '',
      unit: 'g',
    );
  }
}

class Cocktail {
  const Cocktail({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.imageBase64,
  });

  final String id;
  final String name;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final String imageBase64;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'steps': steps,
      'imageBase64': imageBase64,
    };
  }

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json['id'] as String,
      name: json['name'] as String,
      ingredients: (json['ingredients'] as List)
          .map(RecipeIngredient.fromSavedIngredient)
          .toList(),
      steps: List<String>.from(json['steps'] as List),
      imageBase64: json['imageBase64'] as String? ?? '',
    );
  }
}

class CocktailMemory {
  const CocktailMemory({
    required this.id,
    required this.name,
    required this.date,
    required this.imageBase64,
    required this.barName,
    required this.location,
  });

  final String id;
  final String name;
  final DateTime date;
  final String imageBase64;
  final String barName;
  final String location;

  String get dateKey => dateOnlyKey(date);

  Uint8List get imageBytes => base64Decode(imageBase64);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': dateKey,
      'imageBase64': imageBase64,
      'barName': barName,
      'location': location,
    };
  }

  factory CocktailMemory.fromJson(Map<String, dynamic> json) {
    final savedDate = DateTime.tryParse(json['date'] as String? ?? '');

    return CocktailMemory(
      id: json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? '',
      date: savedDate ?? DateTime.now(),
      imageBase64: json['imageBase64'] as String? ?? '',
      barName: json['barName'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }
}
