import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/IngredientSelection.dart';
import 'package:se380_lastversion_recipeapp/Recipes.dart';
import 'package:se380_lastversion_recipeapp/catagorySelectionPage.dart';
import 'package:se380_lastversion_recipeapp/login_page.dart';
import 'package:se380_lastversion_recipeapp/recipe_create.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userName = "";
  late String userEmail = "";

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          userName = user.displayName ?? "";
          userEmail = user.email ?? "";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void signOutAndNavigateToLogin() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }


  void navigateCategoriesPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(),
      ),
    );
  }


  void navigateAllRecipesScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AllRecipesScreen(),
      ),
    );
  }



  void navigateToCreateRecipe() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateRecipePage(),
      ),
    );
  }


  void navigateToSelectIngredients() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>IngredientSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f9fe),
      body: GestureDetector(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Name: $userName', style: TextStyle(fontSize: 20)),
                    Text('Email: $userEmail', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: signOutAndNavigateToLogin,
            child: Text('Çıkış yap', style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 16),

          ElevatedButton(
            onPressed: navigateToCreateRecipe,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Choose your desired button color
            ),
            child: Text('Go to Recipe Creation', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: navigateAllRecipesScreen,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Choose your desired button color
            ),
            child: Text('Go to ALL Recipe Creation', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: navigateToSelectIngredients,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Choose your desired button color
            ),
            child: Text('Go to SelectIngredients', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: navigateCategoriesPage,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Choose your desired button color
            ),
            child: Text('Go to Category', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
