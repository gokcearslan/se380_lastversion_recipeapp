import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/color.dart';
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
          List<Widget> recipeWidgets = [];
          if (snapshot.hasData) {
            final recipes = snapshot.data?.docs.reversed.toList();
            for (var recipe in recipes!) {
              final recipeWidget = RecipeCard(
                recipeName: recipe['name'],
                imageUrl: 'https://i.pinimg.com/564x/5c/de/08/5cde08f5e2cc6c2493dfbf3f71e7c8c6.jpg',
                onTap: () {
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
        builder: (context) => RecipeDetailsScreen(recipe: recipe),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String recipeName;
  final String imageUrl;
  final VoidCallback onTap;

  RecipeCard({
    required this.recipeName,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PeachBG,
      child: ListTile(
        title: Text(
          recipeName,
          style: TextStyle(color: Navy,
            //fontWeight: FontWeight.bold,
         ),
        ),
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Navy, // Set the border color
              width: 2.0, // Set the border width
            ),
          ),
          child: CircleAvatar(
            radius: 25.0,
            backgroundColor: Peach,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
