import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'RecipeDetailsScreen.dart';
import 'Recipes.dart';
import 'color.dart';

class FilteredRecipesScreen extends StatelessWidget {
  final List<String> filteredRecipeNames;

  FilteredRecipesScreen({required this.filteredRecipeNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Recipes'),
      ),
      body: filteredRecipeNames.isEmpty
          ? Center(
        child: Text(
          'No matching recipes found.',
          style: TextStyle(color: Navy),
        ),
      )
          : ListView.builder(
        itemCount: filteredRecipeNames.length,
        itemBuilder: (context, index) {
          final recipeName = filteredRecipeNames[index];
          return RecipeCard(
            recipeName: recipeName,
            imageUrl: 'https://i.pinimg.com/564x/5c/de/08/5cde08f5e2cc6c2493dfbf3f71e7c8c6.jpg',
            onTap: () {
              _showRecipeDetails(recipeName);
            },
          );
        },
      ),
    );
  }


  Stream<DocumentSnapshot> _showRecipeDetails(String recipeName) {
    try {
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeName)
        .snapshots()
        .handleError((error) {
    // Handle errors here
    print('Error fetching recipe details: $error');
    throw StateError('Error fetching recipe details');
    });
    } catch (error) {
    // Handle any errors that occur during the fetch operation
    print('Error fetching recipe details: $error');
    throw StateError('Error fetching recipe details');
    }
    }

}
