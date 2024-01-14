
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ingredient>> getIngredients() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('ingredients').get();

    return snapshot.docs
        .map((doc) => Ingredient(id: doc.id, name: doc['name']))
        .toList();
  }

  Future<List<Recipe>> getRecipes() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('recipes').get();

    return snapshot.docs.map((doc) {
      final instructions = doc.data()!['instructions'];
      final recipe = Recipe(
        id: doc.id,
        name: doc['name'],
        ingredientIds: List<String>.from(doc['ingredientIds']),
        category: 'category',
        instructions: instructions != null ? instructions : 'No instructions',
        image: 'image',

      );

      return recipe;
    }).toList();
  }





  Future<void> saveRecipe(Recipe recipe) async {
    try {

      Map<String, dynamic> recipeData = {
        'name': recipe.name,
        'ingredientIds': recipe.ingredientIds,
        'category': recipe.category,
        'instructions': recipe.instructions,
        'image': recipe.image,
      };


      DocumentReference recipeRef = await _firestore.collection('recipes').add(recipeData);
      await recipeRef.update({'id': recipeRef.id});
    } catch (e) {
      print('Error saving recipe: $e');
    }
  }


  Future<String> uploadRecipeImage(File imageFile) async {
    try {
      firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref().child('recipe_images').child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      firebase_storage.UploadTask uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() => print('Image uploaded successfully'));

      String downloadURL = await storageRef.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }
  // favorites
  Future<void> updateFavoriteStatus(String recipeId, bool isFavorite) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).update({'favorite': isFavorite});
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }

  //edit recipes

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      if (recipe.id == null) {
        throw Exception('Recipe ID is null. Cannot update recipe without an ID.');
      }

      Map<String, dynamic> updatedRecipeData = {
        'ingredientIds': recipe.ingredientIds,
        'instructions': recipe.instructions,
      };

      await _firestore.collection('recipes').doc(recipe.id).update(updatedRecipeData);
    } catch (e) {
      print('Error updating recipe: $e');

    }
  }

}

