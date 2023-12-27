import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:se380_lastversion_recipeapp/recipe.dart';



class RecipeApi {
/*
  const req = unirest('GET', 'https://yummly2.p.rapidapi.com/feeds/list');

  req.query({
    limit: '10',
    start: '0'
  });

  req.headers({
  'X-RapidAPI-Key': 'aecc5dc230mshc027db8c30f9e97p11b779jsncb462787a4f8',
  'X-RapidAPI-Host': 'yummly2.p.rapidapi.com'
});

 */

static Future<List<Recipe>> getRecipe() async
{
 var uri=Uri.https('yummly2.p.rapidapi.com','/feeds/list',
 {
   "limit":"10","start":"0"
 });
final response=await http.get(uri,headers:{
  "x-rapid-key": "aecc5dc230mshc027db8c30f9e97p11b779jsncb462787a4f8",
  "x-rapid-host":"yummly2.p.rapidapi.com"

});
 Map data= jsonDecode(response.body);
 List _temp=[];
 for(var i in data['feed']){
   _temp.add(i['content']['details']);
 }
  return Recipe.recipesFromSnapshot(_temp);
}
}