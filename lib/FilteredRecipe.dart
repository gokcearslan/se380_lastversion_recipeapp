import 'package:flutter/material.dart';

class FilteredRecipesScreen extends StatelessWidget {
  final List<String> filteredRecipeNames;

  FilteredRecipesScreen({required this.filteredRecipeNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Recipes'),
      ),
      body: ListView.builder(
        itemCount: filteredRecipeNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredRecipeNames[index]),
          );
        },
      ),
    );
  }
}
