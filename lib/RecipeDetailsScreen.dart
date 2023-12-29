import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'color.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final DocumentSnapshot recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    List<dynamic> ingredientIds = List.from(recipe['ingredientIds']);
    dynamic instructions = recipe['instructions'];

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name'], style: TextStyle(color: Colors.white)),
        backgroundColor: Navy,
        iconTheme: IconThemeData(color: Colors.white),
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
                    for (var i = 0; i < ingredientIds.length; i++)
                      AnimationConfiguration.staggeredList(
                        position: i + 1,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Card(
                              child: ListTile(
                                title: Text(ingredientIds[i].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
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
                          child: _buildSectionTitle('Instructions:'),
                        ),
                      ),
                    ),
                    _buildInstructions(instructions),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildInstructions(dynamic instructions) {
    if (instructions is List) {
      return Column(
        children: instructions
            .asMap()
            .entries
            .map(
              (entry) =>
              AnimationConfiguration.staggeredList(
                position: entry.key,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // Background color for the instruction box
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
                      child: Row(
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
                    ),
                  ),
                ),
              ),
        )
            .toList(),
      );
    } else if (instructions is String) {
      return Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
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
        child: Text(
          instructions,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Text(
        'No instructions available',
        style: TextStyle(color: Colors.black),
      );
    }
  }
}
