import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user =
          userCredential.user;
      await user!.updateProfile(
          displayName: name);
      await user.reload();
      user = auth.currentUser;


      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'formcount': 0,
        'base64Image': "",
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Weak Password');
      } else if (e.code == 'email-already-in-use') {
        print('This mail already in use.');
      }
    }catch(e){
      print(e);
    }
    return user;
  }

  static Future<User?>signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('there is no such a user');
      } else if (e.code == 'wrong-password') {
        print('Wrong Password!');
      }
    }catch(e){
      print(e);
    }
    return user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    User? refreshedUser = auth.currentUser;
    return refreshedUser;
  }
}
