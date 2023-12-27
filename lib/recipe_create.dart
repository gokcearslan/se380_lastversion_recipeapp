import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se380_lastversion_recipeapp/services/fire_recipe.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_provider.dart';

class CreateRecipePage extends StatefulWidget {
  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  String _selectedCategory = 'Others'; // Default category
  final List<String> _categories = [
    'Breakfast',
    'Soup',
    'Main Course',
    'Drink',
    'Salad',
    'Dessert',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _recipeNameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            SizedBox(height: 16.0),
            Text('Ingredients:'),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Enter Ingredients (comma-separated)'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Category: '),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Split the comma-separated ingredients into a list
                List<String> ingredients = _ingredientsController.text.split(',');

                Recipe newRecipe = Recipe(
                  name: _recipeNameController.text,
                  ingredientIds: ingredients,
                  category: _selectedCategory, // Get the category from the dropdown
                  id: '',
                );

                await FirebaseService().saveRecipe(newRecipe);

                _recipeNameController.clear();
                _ingredientsController.clear();
                // No need to clear the category controller as it's now a dropdown
              },
              child: Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}

