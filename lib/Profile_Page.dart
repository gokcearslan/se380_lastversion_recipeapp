import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se380_lastversion_recipeapp/color.dart';
import 'package:se380_lastversion_recipeapp/services/fire_auth.dart';
import 'package:se380_lastversion_recipeapp/services/image_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();

  Future<String?> fetchImageFromFirestore(String userId) async {
    ImageService imageService = ImageService();
    String? base64Image = await imageService.getImageFromFirestore(userId);
    return base64Image;
  }
}

class _ProfilePageState extends State<ProfilePage> {
  ImageService _imageService = ImageService();

  String name = '';
  String? _base64Image;

  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  User? _currentUser;

  void fetchUser() {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot userSnapshot) {
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
          String name = userData['name'] as String;

          setState(() {
            this.name = name;
          });
        } else {
          print('There is no such user.');
        }
      }).catchError((error) {
        print(error);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchImage() async {
    String? base64Image = await widget.fetchImageFromFirestore(
        FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _base64Image = base64Image ?? '';
    });
  }

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    fetchImage();
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Navy,
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://i.pinimg.com/564x/68/89/e1/6889e19019131d905809a8c0e5528e58.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: GestureDetector(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: EdgeInsets.all(width * 0.01),
                    child: Stack(
                      children: [
                        Container(
                          width: width * 0.3,
                          height: width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.circle,
                            border: Border.all(color: PeachBorder, width: 1),
                            image: _base64Image?.isNotEmpty ?? false
                                ? DecorationImage(
                              image: MemoryImage(Uint8List.fromList(
                                base64Decode(_base64Image!),
                              )),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                        ),
                        Positioned(
                          right: width * 0.01,
                          bottom: height * 0.05,
                          child: Container(
                            width: width * 0.15,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                              color: Color(0xfff2f9fe),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xFF001489), width: 1),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                final action = CupertinoActionSheet(
                                  title: Text(
                                    "Picture",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color(0xFF001489),
                                    ),
                                  ),
                                  message: Text(
                                    "Select a picture",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color(0xFF001489)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        "Camera",
                                        style: TextStyle(
                                            color: Color(0xFF001489)),
                                      ),
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _imageService
                                            .pickAndSetImageFromCamera();
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        "Gallery",
                                        style: TextStyle(
                                            color: Color(0xFF001489)),
                                      ),
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _imageService
                                            .pickAndSetImageFromGallery();
                                      },
                                    ),
                                  ],
                                  cancelButton:
                                  CupertinoActionSheetAction(
                                    child: Text("Close"),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => action);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Color(0xFF001489),
                                size: width * 0.05,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: Text(
                                '${_currentUser?.email ?? 'There is no such info'}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: _currentUser?.emailVerified == true
                                  ? Text(
                                'Email confirmed',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              )
                                  : Text(
                                'Email could not be confirmed',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.04),
                            _isSendingVerification
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: _currentUser != null && !_currentUser!.emailVerified
                                  ? () async {
                                setState(() {
                                  _isSendingVerification = true;
                                });
                                await _currentUser!.sendEmailVerification();
                                setState(() {
                                  _isSendingVerification = false;
                                });
                              }
                                  : null,
                              child: const Text(
                                'Confirm Email',
                                style: TextStyle(color: Color(0xFFffffff)),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Navy),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () async {
                                User? user = await FireAuth.refreshUser(_currentUser!);

                                if (user != null) {
                                  setState(() {
                                    _currentUser = user;
                                  });
                                }
                              },
                              icon: Icon(Icons.refresh),
                              iconSize: width * 0.05,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: _isSigningOut
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isSigningOut = true;
                                  });
                                  await FirebaseAuth.instance.signOut();
                                  setState(() {
                                    _isSigningOut = false;
                                  });
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Sign out',
                                        style: TextStyle(
                                            color: Colors.white)),
                                    SizedBox(width: 8),
                                    Icon(Icons.exit_to_app,
                                        color: Colors.white),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  backgroundColor: Navy,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
