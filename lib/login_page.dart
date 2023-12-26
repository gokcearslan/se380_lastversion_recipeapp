import 'package:se380_lastversion_recipeapp/HomePage.dart';
//import 'package:se380_lastversion_recipeapp/MenuPage.dart';
import 'package:se380_lastversion_recipeapp/register_page.dart';
import 'package:se380_lastversion_recipeapp/services/fire_auth.dart';
//import 'package:se380_lastversion_recipeapp/services/fire_auth.dart';
//import 'package:eleven/ProfilePage.dart';
import 'package:se380_lastversion_recipeapp/validator.dart';
//import 'package:se380_lastversion_recipeapp/widget/custom_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:se380_lastversion_recipeapp/widget/custom_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CustomPage(pages: [
            //MenuPage(),
            HomePage(),
            //ProfilePage(),
          ], titles: const [
            'Menu',
            'Ana Sayfa',
            'Profil',
          ]),
        ),
      );
    }

    return firebaseApp;
  }

  Future<void> login() async{

    // if user is not created before
    String email = _emailTextController.text;
    String password = _passwordTextController.text;
    final auth= FirebaseAuth.instance;
    UserCredential userCredential= await
    auth.createUserWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    //String uid = user?.uid ?? "";


    //if user is created


  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailTextController,
                            focusNode: _focusEmail,
                            validator: (value) => Validator.validateEmail(
                                email: _emailTextController.text),
                            decoration: InputDecoration(
                              hintText: "Email",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _passwordTextController,
                            focusNode: _focusPassword,
                            obscureText: true,
                            validator: (value) => Validator.validatePassword(
                                password: _passwordTextController.text),
                            decoration: InputDecoration(
                              hintText: "Şifre",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      _focusEmail.unfocus();
                                      _focusPassword.unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isProcessing = true;
                                        });
                                        User? user = await FireAuth
                                            .signInUsingEmailPassword(
                                          email: _emailTextController.text,
                                          password: _passwordTextController.text,
                                          context: context,
                                        );
                                        setState(() {
                                          _isProcessing = false;
                                        });
                                        if (user != null) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomPage(pages: [
                                                      //MenuPage(),
                                                      HomePage(),
                                                      //ProfilePage(),
                                                    ], titles: [
                                                      'Menu',
                                                      'Ana Sayfa',
                                                      'Profil',
                                                    ])),
                                          );
                                        }
                                      }
                                    },
                                    child: Text('Giriş Yap'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF001489),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )
                                ),
                              ),
                              SizedBox(width: 24.0),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => RegisterPage()),
                                      );
                                    },
                                    child: Text('Kayıt Ol'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF001489),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
