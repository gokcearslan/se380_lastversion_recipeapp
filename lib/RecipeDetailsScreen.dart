import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final DocumentSnapshot recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    List<dynamic> ingredientIds = List.from(recipe['ingredientIds']);
    dynamic instructions = recipe['instructions'];

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']),
      ),
      body: Container(
        constraints: BoxConstraints.expand(), // Ensure the container takes up the full screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/736x/aa/69/1e/aa691e23e493ef0f452d1713a1f6875e.jpg'),
            fit: BoxFit.fill, // Cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingredient IDs:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              // Displaying each ingredientId in a separate Text widget
              for (var id in ingredientIds)
                Text(id.toString(), style: TextStyle(color: Colors.black)),
              SizedBox(height: 16),

              Text(
                'Instructions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              // Displaying instructions based on its type
              if (instructions is List)
                for (var instruction in instructions)
                  Text(instruction.toString(), style: TextStyle(color: Colors.black))
              else if (instructions is String)
                Text(instructions, style: TextStyle(color: Colors.black))
              else
                Text('No instructions available', style: TextStyle(color: Colors.black)),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
