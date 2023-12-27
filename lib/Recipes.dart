import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_provider.dart';

import 'RecipeDetailsScreen.dart';

class AllRecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Recipes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          List<ListTile> recipeWidgets = [];
          if (snapshot.hasData) {
            final recipes = snapshot.data?.docs.reversed.toList();
            for (var recipe in recipes!) {
              final recipeWidget = ListTile(
                title: Text(recipe['name']),
                onTap: () {
                  // Handle the recipe item click
                  _showRecipeDetails(context, recipe);
                },
              );
              recipeWidgets.add(recipeWidget);
            }
          }

          return Expanded(
            child: ListView(
              children: recipeWidgets,
            ),
          );
        },
      ),
    );
  }

  void _showRecipeDetails(BuildContext context, DocumentSnapshot recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecipeDetailsScreen(recipe: recipe)),
    );
  }
}
