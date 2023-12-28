import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/IngredientSelection.dart';
import 'package:se380_lastversion_recipeapp/Recipes.dart';
import 'package:se380_lastversion_recipeapp/catagorySelectionPage.dart';
import 'package:se380_lastversion_recipeapp/login_page.dart';
import 'package:se380_lastversion_recipeapp/recipe_create.dart';
import 'package:se380_lastversion_recipeapp/color.dart';


import 'Profile_Page.dart';


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
  void navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>ProfilePage(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Recipe App', style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.w800, // Higher font weight for a thicker appearance
          fontSize: 30,
        ),
        ),
        backgroundColor: Navy,

        // Customize the AppBar as needed
      ),

      // mail ve username kodu:
      backgroundColor: Color(0xfff2f9fe),
      /*body: GestureDetector(
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
       */

      body: SafeArea(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*
    Expanded(
    child: Container(
      width: double.infinity, // Take up the full width of the screen
      padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: FloatingActionButton(
    onPressed: signOutAndNavigateToLogin,
    child: Text('Çıkış yap', style: TextStyle(color: Colors.black)),
    ),
    ),
    ),
    SizedBox(height: 16),

       */

            Expanded(
              child: Container(
                width: 1000,
                height: 60,
                child: GestureDetector(
                  onTap: navigateToCreateRecipe, // Function to be called on tap
                  child: Stack(
                    children: <Widget>[
                      // Background Image
                      Positioned.fill(
                        child: Image.network(
                          'https://i.pinimg.com/564x/2e/c7/6b/2ec76bcc46f6efa497c4ff4033dfb634.jpg',
                          fit: BoxFit.cover, // This ensures the image covers the button area
                        ),
                      ),

                      // Centered Text on top of the image
                      Center(
                        child: Text(
                          'Create New Recipe',
                          style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w800, // Higher font weight for a thicker appearance
                            fontSize: 30,
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 1000,
                height: 60,
                child: GestureDetector(
                  onTap: navigateAllRecipesScreen, // Function to be called on tap
                  child: Stack(
                    children: <Widget>[
                      // Background Image
                      Positioned.fill(
                        child: Image.network(
                          'https://i.pinimg.com/564x/2e/c7/6b/2ec76bcc46f6efa497c4ff4033dfb634.jpg',
                          fit: BoxFit.cover, // This ensures the image covers the button area
                        ),
                      ),

                      // Centered Text on top of the image
                      Center(
                        child: Text(
                          'List All Recipes',
                          style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w800, // Higher font weight for a thicker appearance
                            fontSize: 30,
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 1000,
                height: 60,
                child: GestureDetector(
                  onTap: navigateToSelectIngredients, // Function to be called on tap
                  child: Stack(
                    children: <Widget>[
                      // Background Image
                      Positioned.fill(
                        child: Image.network(
                          'https://i.pinimg.com/564x/2e/c7/6b/2ec76bcc46f6efa497c4ff4033dfb634.jpg',
                          fit: BoxFit.cover, // This ensures the image covers the button area
                        ),
                      ),

                      // Centered Text on top of the image
                      Center(
                        child: Text(
                          'Select Ingredients to Find Recipes',
                          style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w800, // Higher font weight for a thicker appearance
                            fontSize: 30,
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 1000,
                height: 60,
                child: GestureDetector(
                  onTap: navigateCategoriesPage, // Function to be called on tap
                  child: Stack(
                    children: <Widget>[
                      // Background Image
                      Positioned.fill(
                        child: Image.network(
                          'https://i.pinimg.com/564x/2e/c7/6b/2ec76bcc46f6efa497c4ff4033dfb634.jpg',
                          fit: BoxFit.cover, // This ensures the image covers the button area
                        ),
                      ),

                      // Centered Text on top of the image
                      Center(
                        child: Text(
                          'Recipe Categories',
                          style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w800, // Higher font weight for a thicker appearance
                            fontSize: 30,
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 60,
                width: 120,
                child: ElevatedButton(
                  onPressed:
                  navigateToProfile,
                  style: ElevatedButton.styleFrom(
                    primary: Peach,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      SizedBox(width: 3.0),
                      Text(
                        'Profile',
                        style: TextStyle(fontWeight: FontWeight.w800,color:Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
