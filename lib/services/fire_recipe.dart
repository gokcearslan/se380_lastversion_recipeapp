// services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';


class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ingredient>> getIngredients() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('ingredients').get();

    return snapshot.docs
        .map((doc) => Ingredient(id: doc.id, name: doc['name']))
        .toList();
  }

  Future<List<Recipe>> getRecipes() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('recipes').get();

    return snapshot.docs.map((doc) {
      final instructions = doc.data()!['instructions'];
      final recipe = Recipe(
        id: doc.id,
        name: doc['name'],
        ingredientIds: List<String>.from(doc['ingredientIds']),
        category: 'category',
        instructions: instructions != null ? instructions : 'No instructions',
      );

      return recipe;
    }).toList();
  }





  Future<void> saveRecipe(Recipe recipe) async {
    try {
      // Convert the Recipe object to a Map
      Map<String, dynamic> recipeData = {
        'name': recipe.name,
        'ingredientIds': recipe.ingredientIds,
        'category': recipe.category,
        'instructions': recipe.instructions, // Add the instructions field
        // Add other fields like 'id' if needed
      };

      // Add the recipe data to the 'recipes' collection
      await _firestore.collection('recipes').add(recipeData);
    } catch (e) {
      print('Error saving recipe: $e');
      // Handle the error as needed
    }
  }

}

