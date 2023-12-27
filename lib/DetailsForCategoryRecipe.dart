import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            for (var ingredientId in recipe.ingredientIds)
              Text(ingredientId),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
