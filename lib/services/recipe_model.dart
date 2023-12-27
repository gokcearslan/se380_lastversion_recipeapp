
class Ingredient {
  final String id;
  final String name;

  Ingredient({required this.id, required this.name});
}

class Recipe {
  final String id;
  final String name;
  final List<String> ingredientIds;
  final String category;

  Recipe({
    required this.id, // Make id required
    required this.name,
    required this.ingredientIds,
    required this.category,
  });

  // Add a named constructor for creating a Recipe without providing an id
  Recipe.withoutId({
    required this.name,
    required this.ingredientIds,
    required this.category,
  }) : id = ''; // Provide a default value for id
}
