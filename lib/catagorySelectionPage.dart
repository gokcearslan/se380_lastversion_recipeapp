import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/FilteredRecipe.dart';

class CategorySelectionScreen extends StatefulWidget {
  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String selectedCategory = '';
  List<String> allCategories = ['Breakfast', 'Soup']; // Add more categories as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
      ),
      body: ListView(
        children: [
          for (var category in allCategories) ...[
            ListTile(
              title: Text(category),
              onTap: () {
                _navigateToCategoryPage(context, category);
              },
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToCategoryPage(BuildContext context, String category) {
    setState(() {
      selectedCategory = category;
    });

    recipesAccordingCategory(context, selectedCategory);
  }

  void recipesAccordingCategory(BuildContext context, String category) async {
    try {
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('recipes').get();

      List<String> filteredRecipeNames = [];

      querySnapshot.docs.forEach((doc) {
        // Check if the 'category' field exists in the document
        if ((doc.data() as Map<String, dynamic>).containsKey('category') &&
            (doc.data() as Map<String, dynamic>)['category'] == category)
        {
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
