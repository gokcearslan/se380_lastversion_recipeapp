import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';

class IngredientProvider extends ChangeNotifier {
  List<Ingredient> ingredients = [];
  HashSet<String> selectedIngredientIds = HashSet();
  List<String> enteredIngredients = [];

  List<Ingredient> get ingredientss => ingredients;

  void setEnteredIngredients(List<String> enteredIngredients) {
    this.enteredIngredients = enteredIngredients;
    notifyListeners();
  }

  void addEnteredIngredient(String ingredient) {
    enteredIngredients.add(ingredient);
    notifyListeners();
  }

  void removeEnteredIngredient(String ingredient) {
    enteredIngredients.remove(ingredient);
    notifyListeners();
  }
}

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];

  List<Recipe> get recipes => _recipes;

  void setRecipes(List<Recipe> recipes) {

    _recipes = recipes;
    notifyListeners();
  }

  void filterRecipes(BuildContext context) {
    // Get entered ingredients from IngredientProvider
    var ingredientProvider = Provider.of<IngredientProvider>(context, listen: false);
    List<String> enteredIngredients = ingredientProvider.enteredIngredients;

    // Print entered ingredients for debugging
    print('Entered Ingredients: $enteredIngredients');

    // Filter recipes based on entered ingredients
    _filteredRecipes = _recipes
        .where((recipe) =>
        recipe.ingredientIds.any((ingredientId) => enteredIngredients.contains(ingredientId)))
        .toList();

    // Print filtered recipes for debugging
    print('Filtered Recipes: $_filteredRecipes');

    notifyListeners();
  }

}
