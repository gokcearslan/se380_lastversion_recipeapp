import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:se380_lastversion_recipeapp/services/recipe_model.dart';
import 'color.dart';
import 'edit_Recipe.dart';
import 'package:se380_lastversion_recipeapp/services/fire_recipe.dart';
import 'Recipes.dart';


class EditRecipePage extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final bool editMode;

  EditRecipePage({required this.recipe, this.editMode = true});



  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {

  late List<dynamic> ingredientIds;
  late dynamic instructions;
  late List<TextEditingController> ingredientControllers;
  late TextEditingController instructionsController;

  @override
  void initState() {
    super.initState();

    if (widget.editMode) {



      ingredientControllers = List.generate(
        widget.recipe['ingredientIds'].length,
            (index) =>
            TextEditingController(text: widget.recipe['ingredientIds'][index]),
      );
      instructionsController =
          TextEditingController(text: widget.recipe['instructions']);
    }
   else {

  ingredientControllers = [TextEditingController()];
  instructionsController = TextEditingController();
  }

    ingredientIds = List.from(widget.recipe['ingredientIds']);
    instructions = widget.recipe['instructions'];
  }


    @override
    Widget build(BuildContext context) {


      return Scaffold(
        appBar: AppBar(

          title: Text(widget.editMode ? 'Edit Recipe' : widget.recipe['name'],
              style: TextStyle(color: Colors.white, fontSize: 18)),
          backgroundColor: Navy,
          iconTheme: IconThemeData(color: Colors.white),

          actions: [
            if (widget.editMode)
              IconButton(
                icon: Icon(Icons.save, size: 30,),
                onPressed: () {

                  saveChanges();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllRecipesScreen(
                      ),
                    ),
                  );

                },
              ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://i.pinimg.com/564x/0b/57/e2/0b57e25e10c285bd93316b28bd522a09.jpg',
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: AnimationLimiter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimationConfiguration.staggeredList(
                        position: 0,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _buildSectionTitle('Ingredients:'),
                          ),
                        ),
                      ),
                      for (var i = 0; i < ingredientControllers.length; i++)
                        AnimationConfiguration.staggeredList(
                          position: i + 1,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                child: ListTile(
                                  title: TextField(
                                    controller: ingredientControllers[i],
                                    decoration: InputDecoration(
                                      labelText: 'Ingredient ${i + 1}',

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
              AnimationConfiguration.staggeredList(
                position: ingredientIds.length + 1,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Card(
                      child: ListTile(
                        title: TextField(
                          controller: instructionsController,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Instructions',

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
                  ),
                ),
              ),
            ),

                    ],
                  ),
      );
    }

  void saveChanges() async {
    try {

      String recipeId = widget.recipe['id'];


      await FirebaseService().updateRecipe(
        Recipe(
          id: recipeId,
          ingredientIds: ingredientControllers.map((controller) => controller.text).toList(),
          instructions: instructionsController.text,
          name: widget.recipe['name'],
          category: widget.recipe['category'],
          image: widget.recipe['image'],
        ),
      );


      setState(() {
        widget.recipe['ingredientIds'] = ingredientControllers.map((controller) => controller.text).toList();
        widget.recipe['instructions'] = instructionsController.text;

      });
    } catch (e) {
      print('Error saving changes: $e');

    }
  }





  Widget _buildSectionTitle(String title) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Navy),
        ),
      );
    }

  Widget _buildInstructions(dynamic instructions, bool isEditMode) {

    if (!isEditMode) {
      return Text(
        'No instructions available',
        style: TextStyle(color: Colors.black),
      );
    }


    if (instructions is List) {
      return Column(
        children: instructions
            .asMap()
            .entries
            .map(
              (entry) => AnimationConfiguration.staggeredList(
            position: entry.key,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _instructionContainer(entry),
              ),
            ),
          ),
        )
            .toList(),
      );
    } else if (instructions is String) {
      return Column(
        children: [
          _instructionContainer(MapEntry<int, dynamic>(0, instructions)),
          SizedBox(height: 16.0),
          Image.file(
            File(widget.recipe['image']),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      );
    } else {
      return Text(
        'No instructions available',
        style: TextStyle(color: Colors.black),
      );
    }
  }

  Widget _instructionContainer(MapEntry<int, dynamic> entry) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Navy,
                foregroundColor: Colors.white,
                child: Text('${entry.key + 1}'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.value.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          Image.file(
            File(widget.recipe['image']),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }


}

