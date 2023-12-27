import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/widget/recipe_widget.dart';

class ListRecipesPage extends StatefulWidget{
@override
_ListRecipesPageState createState() => _ListRecipesPageState();



}

class _ListRecipesPageState extends State<ListRecipesPage>{
@override
Widget build(BuildContext context){
return Scaffold(
appBar:AppBar(
title:Row(children: [
Icon(Icons.restaurant),
SizedBox(width: 10),
Text('Food Recipes')
],
),
),
  body: RecipeCard(title: "recipe",cookTime: "30",rating: "rating",thumbnailUrl:'https://cdn.yemek.com/mnresize/1250/833/uploads/2022/03/domates-corbasi-sevgililer-gunu-gorsel.jpg')

);
}

}
