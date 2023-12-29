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

      //Firestore'a kullanıcı verileri ekleniyor.
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'formcount': 0,
        'base64Image': "",
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Şifre çok zayıf.');
      } else if (e.code == 'email-already-in-use') {
        print('Bu mail için bir hesap zaten var.');
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
        print('Bu mail için bir kullanıcı bulunmamaktadır..');
      } else if (e.code == 'wrong-password') {
        print('Yanlış şifre!');
      }
    }catch(e){
      print(e);
    }
    return user;
  }

  static Future<void> signOut() async { //Kullanıcı çıkışı için kullanıldı.
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> sendEmailVerification() async { //E-posta doğrulaması için
    User? user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }

  static Future<User?> refreshUser(User user) async { //Kullanıcı bilgilerini güncellemek için kullanıldı.
    FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    User? refreshedUser = auth.currentUser;
    return refreshedUser;
  }
}
