import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';
import 'package:provider/provider.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_provider.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Recipes'),
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, _) {
          // Filter recipes based on the selected category
          List<Recipe> recipes = recipeProvider.recipes
              .where((recipe) => recipe.category == category)
              .toList();

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(recipes[index].name),
                // Add more details if needed
              );
            },
          );
        },
      ),
    );
  }
}

