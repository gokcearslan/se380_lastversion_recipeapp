
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
  final String instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredientIds,
    required this.category,
    required this.instructions,
  });


  Recipe.withoutId({
    required this.name,
    required this.ingredientIds,
    required this.category,
    required this.instructions,
  }) : id = '';
}
