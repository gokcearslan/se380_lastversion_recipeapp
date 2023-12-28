import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'fire_auth.dart';

class ImageService{
  String _base64Image="";
  String get base64Image => _base64Image;

  Future<bool> pickAndSetImageFromGallery() async{  //Galeriden resim seçme
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,maxHeight: 800,maxWidth: 800);//Boyutlandırma yapılacak.

    if(pickedFile != null){
      final imageBytes = await pickedFile.readAsBytes();
      _base64Image= base64Encode(imageBytes);
      saveImageToFirestore();
      return true;
    }
    return false;
  }

  Future<bool> pickAndSetImageFromCamera() async{ //Kameradan resim seçme
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera,maxHeight: 800,maxWidth: 800); //Boyutlandırma yapılacak.

    if(pickedFile != null){
      final imageBytes = await pickedFile.readAsBytes();
      _base64Image= base64Encode(imageBytes);
      saveImageToFirestore();
      return true;
    }
    return false;
  }

  Future<bool> saveImageToFirestore() async { //Resmi Firestore'a kaydetme
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user=auth.currentUser;

      if (user == null) {
        print("Kullanıcı oturumu açmamış.");
        return false;
      }
      user=await FireAuth.refreshUser(user);
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('users').doc(user!.uid).update({
        'base64Image': _base64Image,
      });
      return true;
    } catch (e) {
      print('Firestore\'a resmi kaydederken bir hata oluştu: $e');
      return false;
    }
  }

  Future<String?> getImageFromFirestore(String userId) async { //Firestore'dan resmi çekme
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot snapshot =
      await firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        String? base64Image = snapshot['base64Image'];
        return base64Image;
      } else {
        return null;
      }
    } catch (e) {
      print('Firestore\'dan resmi çekerken bir hata oluştu: $e');
      return null;
    }
  }


}