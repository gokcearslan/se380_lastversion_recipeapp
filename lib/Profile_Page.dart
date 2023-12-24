/*

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se380_lastversion_recipeapp//services/fire_auth.dart';
import 'package:se380_lastversion_recipeapp//services/image_service.dart';
import 'package:se380_lastversion_recipeapp//services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'login_page.dart';
import 'model/pushNotification_model.dart';
import 'notificationBadge.dart';
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
  int formcount = 0;
  String? _base64Image;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  User? _currentUser;

  //late User _currentUser=FirebaseAuth.instance.currentUser!;

  late int _totalNotifications; //Bildirim sayısını tutmak için kullanıldı.
  late final FirebaseMessaging
  _messaging; //Anlık bildirim göndermek için kullanıldı.
  PushNotification?
  _notificationInfo; //Bildirim bilgilerini tutmak için kullanıldı.

  void fetchUser() {
    //Kullanıcı bilgilerini çekmek için kullanıldı.
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
          //int formCount = userData['formcount'] as int;

          setState(() {
            this.name = name;
            //this.formCount = formCount;
          });
        } else {
          print('Böyle bir kullanıcı bulunmamaktadır.');
        }
      }).catchError((error) {
        print(error);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchImage() async {
    String? base64Image = await widget
        .fetchImageFromFirestore(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _base64Image = base64Image ??
          ''; // Firestore'dan gelen veriyi _base64Image değişkenine atıyoruz.
    });
  }

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    //Başlangıç durumunu ayarlar.
    _totalNotifications = 0;
    checkForInitialMessage();
    //Uygulama arka planda olduğunda ancak sonlandırılmadığında bildirimi işlemek için
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
    fetchImage();
    super.initState();
    fetchUser();
    registerNotification();
  }

  checkForInitialMessage() async {
    //Uygulama sonlandırılmış durumdayken bildirimi işlemek için kullanıldı.
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification!.title,
        body: initialMessage.notification!.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  void registerNotification() async {
    // iOS cihazlarda gerekli olan bildirim erişimi ister, mesajlaşmayı anında iletme bildirimlerini alacak ve görüntüleyecek şekilde yapılandırır.
    await Firebase
        .initializeApp(); //Firebase uygulamasının başlatılması için kullanıldı.
    _messaging = FirebaseMessaging
        .instance; //Firebase mesajlaşması başlatmak için kullanıldı.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //İOS'ta kullanıcı izinlerinin alınmasına yardımcı olur.
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Kullanıcı izinleri alındı.');
      //ToDo:Alınan bildirimler işlenecek.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //Alınan mesajı ayrıştırır.
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
        );
        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          //Bildirimi yer paylaşımı olarak görüntülemek için kullanıldı.
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(
              totalNotifications: _totalNotifications,
            ),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.blue,
            duration: Duration(seconds: 5),
          );
        }
      });
    } else {
      print('Kullanıcı izinleri alınamadı.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xfff2f9fe),
      body: SingleChildScrollView(
        child: GestureDetector(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: Stack(
                    children: [
                      Container(
                        width: width * 0.25,
                        height: height * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: Color(0xFF001489), width: 1),
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
                          width: width * 0.08,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            color: Color(0xfff2f9fe),
                            shape: BoxShape.circle,
                            border:
                            Border.all(color: Color(0xFF001489), width: 1),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final action = CupertinoActionSheet(
                                title: Text(
                                  "Fotoğraf",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(0xFF001489),
                                  ),
                                ),
                                message: Text(
                                  "Fotoğraf Seçiniz",
                                  style: TextStyle(fontSize: 15.0,color:Color(0xFF001489).withOpacity(0.7),),
                                ),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text("Kamera",style:TextStyle(color:Color(0xFF001489)),),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _imageService
                                          .pickAndSetImageFromCamera();
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text("Galeri",style:TextStyle(color:Color(0xFF001489)),),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _imageService
                                          .pickAndSetImageFromGallery();
                                    },
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text("Kapat"),
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                              showCupertinoModalPopup(
                                  context: context, builder: (context) => action);
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: width * 0.2,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color(0xFF001489), width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('İsim'),
                          )),
                      SizedBox(
                        width: width * 0.08,
                      ),
                      Container(
                          width: width * 0.5,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color(0xFF001489), width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                '${_currentUser?.displayName ?? 'Bilgi yok'}'),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: width * 0.2,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color(0xFF001489), width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('Email'),
                          )),
                      SizedBox(
                        width: width * 0.08,
                      ),
                      Container(
                          width: width * 0.5,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color(0xFF001489), width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child:
                            Text('${_currentUser?.email ?? 'Bilgi yok'}'),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: width * 0.5,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color(0xFF001489), width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: _currentUser?.emailVerified == true
                                ? Text('Email onaylandı')
                                : Text('Email onaylanamadı'),
                          )),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      _isSendingVerification
                          ? CircularProgressIndicator()
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: _currentUser != null &&
                                !_currentUser!.emailVerified
                                ? () async {
                              setState(() {
                                _isSendingVerification = true;
                              });
                              await _currentUser!
                                  .sendEmailVerification();
                              setState(() {
                                _isSendingVerification = false;
                              });
                            }
                                : null,
                            child: const Text(
                              'Emaili onayla',
                              style: TextStyle(color: Color(0xFFffffff)),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Color(0xFF001489)),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          IconButton(
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Color(0xFF001489))),
                            icon: Icon(Icons.refresh),
                            onPressed: () async {
                              User? user = await FireAuth.refreshUser(
                                  _currentUser!);

                              if (user != null) {
                                setState(() {
                                  _currentUser = user;
                                });
                              }
                            },
                            iconSize: width * 0.05,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
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
                              child: Text('Çıkış yap',
                                  style: TextStyle(color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                backgroundColor: Color(0xfff2f9fe),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () async {
                                await saveFcmTokenToFirestore();
                                await sendNotificationToCurrentUser();
                              },
                              child: Text(
                                'Bildirim gönder',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                backgroundColor: Color(0xfff2f9fe),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: (){}, child: Text("Guncel"))
                        ],
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Arka planda gelen bildirim: ${message.messageId}');
}


 */