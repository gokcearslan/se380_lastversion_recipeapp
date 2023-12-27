import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final DocumentSnapshot recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    List<dynamic> ingredientIds = recipe['ingredientIds'];

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredient IDs:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Displaying each ingredientId in a separate Text widget
            for (var id in ingredientIds)
              Text(id.toString()),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
