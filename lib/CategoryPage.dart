import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/RecipeDetailsScreen.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {

    print("Category received: $category");

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Recipes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {

          print("Connection state: ${snapshot.connectionState}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for data...");
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text("An error occurred: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print("No data available for category: $category");
            return Center(child: Text("No recipes found in the '$category' category"));
          }


          print("documents: ${snapshot.data!.docs.length}");
          snapshot.data!.docs.forEach((doc) {
            print("Document data: ${doc.data()}");
          });

          List<Widget> recipeWidgets = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
           // recipe names to test
            print("Recipe name: ${data['name']}");
            return ListTile(
              title: Text(data['name']),
              onTap: () {
                _showRecipeDetails(context, document);
              },
            );
          }).toList();

          return ListView(children: recipeWidgets);
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