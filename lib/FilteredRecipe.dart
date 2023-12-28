import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'RecipeDetailsScreen.dart';
import 'color.dart';

class FilteredRecipesScreen extends StatelessWidget {
  final List<String> filteredRecipeNames;

  FilteredRecipesScreen({required this.filteredRecipeNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Recipes', style: TextStyle(color: Colors.white)),
        backgroundColor: Navy,
        iconTheme: IconThemeData(color: Colors.white),

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
          return ListTile(
            title: Text(recipeName),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                'https://i.pinimg.com/564x/5c/de/08/5cde08f5e2cc6c2493dfbf3f71e7c8c6.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              _navigateToRecipeDetailsScreen(context, recipeName);
            },
          );
        },
      ),
    );
  }

  void _navigateToRecipeDetailsScreen(BuildContext context, String recipeName) async {
    try {
      final DocumentSnapshot recipeSnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where('name', isEqualTo: recipeName)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      if (recipeSnapshot.exists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(recipe: recipeSnapshot),
          ),
        );
      } else {
        _showNoRecipeFoundDialog(context);
      }
    } catch (error) {
      print('Error fetching recipe details: $error');
      _showErrorDialog(context);
    }  }

}
void _showNoRecipeFoundDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Recipe Not Found"),
        content: Text("The recipe could not be found in the database."),
        actions: <Widget>[
          TextButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
void _showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text("An error occurred while fetching the recipe details."),
        actions: <Widget>[
          TextButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}