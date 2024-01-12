import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RecipeDetailsScreen.dart';
import 'color.dart';
import 'services/fire_recipe.dart';
import 'FavRecipePage.dart';

class FavoritesManagementScreen extends StatefulWidget {
  @override
  _FavoritesManagementScreenState createState() => _FavoritesManagementScreenState();
}

class _FavoritesManagementScreenState extends State<FavoritesManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Favorites',
            style:TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Navy,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite,color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteRecipesScreen()),
              );
            },
          ),
        ],

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var recipes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              var recipe = recipes[index];
              var recipeData = recipe.data() as Map<String, dynamic>?;
              bool isFavorite = recipeData != null && recipeData.containsKey('favorite')
                  ? recipeData['favorite'] as bool
                  : false;

              // Wrap ListTile with Card
              return Card(
                elevation: 4.0, // Optional: adds a slight shadow
                margin: EdgeInsets.all(8.0), // Optional: adds spacing around each card
                child: ListTile(
                  title: Text(recipe['name']),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      var firebaseService = FirebaseService();
                      await firebaseService.updateFavoriteStatus(recipe.id, !isFavorite);
                      setState(() {
                        isFavorite = !isFavorite;
                      });


                    },
                  ),
                  onTap: () => _showRecipeDetails(context, recipe),
                ),
              );
            },
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

