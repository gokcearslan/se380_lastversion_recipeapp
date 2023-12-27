import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/FilteredRecipe.dart';

class IngredientSelectionScreen extends StatefulWidget {
  @override
  _IngredientSelectionScreenState createState() =>
      _IngredientSelectionScreenState();
}

class _IngredientSelectionScreenState extends State<IngredientSelectionScreen> {
  List<String> selectedIngredients = [];
  List<String> allIngredients = [];

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  void _fetchIngredients() async {
    try {
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('recipes').get();

      List<String> ingredients = [];

      querySnapshot.docs.forEach((doc) {
        List<dynamic> recipeIngredients = doc['ingredientIds'];
        ingredients.addAll(recipeIngredients.map((ingredient) => ingredient.toString()));
      });

      setState(() {
        allIngredients = ingredients.toSet().toList();
      });
    } catch (e) {
      print('Error fetching ingredients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Ingredients'),
      ),
      body: ListView(
        children: [
          for (var ingredient in allIngredients) ...[
            CheckboxListTile(
              title: Text(ingredient),
              value: selectedIngredients.contains(ingredient),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedIngredients.add(ingredient);
                  } else {
                    selectedIngredients.remove(ingredient);
                  }
                });
              },
            ),
          ],
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showFilteredRecipes(context);
            },
            child: Text('Show Recipes'),
          ),
        ],
      ),
    );
  }
  void _showFilteredRecipes(BuildContext context) async {
    try {
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('recipes').get();

      List<String> filteredRecipeNames = [];

      querySnapshot.docs.forEach((doc) {
        List<dynamic> recipeIngredients = doc['ingredientIds'];
        bool containsAllSelectedIngredients =
        selectedIngredients.every((ingredient) =>
            recipeIngredients.contains(ingredient));

        if (containsAllSelectedIngredients) {
          filteredRecipeNames.add(doc['name']);
        }
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilteredRecipesScreen(
            filteredRecipeNames: filteredRecipeNames,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching and filtering recipes: $e');
    }
  }


}
