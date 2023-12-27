//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/list_recipes_Page.dart';
import 'package:se380_lastversion_recipeapp/login_page.dart';
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
        builder: (context) => LoginPage(), // Replace with your login page
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
              // Display the user's name and email
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Name: $userName', style: TextStyle(fontSize: 20)),
                    Text('Email: $userEmail', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              // go to list recipes page
               TextButton(
                onPressed: () {
                  // Navigate to the list recipe page when the text is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListRecipesPage()),
                  );
                },
                child: Text(
                  'List Recipes',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Add a Sign-Out button that navigates to the login page
      floatingActionButton: FloatingActionButton(
        onPressed: signOutAndNavigateToLogin,
        child: Text('Çıkış yap', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
