import 'dart:ui';
import 'package:animated_splash/animated_splash.dart';
import 'package:buildabrain/Parent/parentHome.dart';
import 'package:buildabrain/calendar.dart';

import 'package:buildabrain/Owner/ownerHome.dart';
import 'package:buildabrain/chooseIdentity.dart';
import 'package:buildabrain/profile.dart';
import 'package:buildabrain/signupPage.dart';
import 'package:buildabrain/welcomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentUser;
  Widget _defaultHome;
  String name;
  Stream<QuerySnapshot> userSnap;

  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    _currentUser = account;
  });

  if (user != null) {
    await Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((value) {
      if (value.documents[0].data['identity'] == "Teacher") {
        _defaultHome = WelcomePage();
      } else if (value.documents[0].data['identity'] == "Leader") {
        _defaultHome = OwnerHome(value, 0);
      } else if (value.documents[0].data['identity'] == "Parent") {
        _defaultHome = ParentHome(value, 0, 0);
      }
    });
  }

  if (_currentUser != null) {
    await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: googleSignIn.currentUser.id)
        .getDocuments()
        .then((value) => {
              if (value.documents[0].data['identity'] == "Teacher")
                {_defaultHome = MyHomePage()}
              else if (value.documents[0].data['identity'] == "Leader")
                {_defaultHome = OwnerHome(value, 0)}
              else if (value.documents[0].data['identity'] == "Parent")
                {_defaultHome = ParentHome(value, 0, 0)}
            })
        .catchError((error) {
      _defaultHome = WelcomePage();
    });
  } else if (user == null && _currentUser == null) {
    _defaultHome = WelcomePage();
  }

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'App',
    home: AnimatedSplash(
      imagePath: 'lib/Assets/bdblogo.png',
      home: MyApp(_defaultHome),
      duration: 2500,
      type: AnimatedSplashType.StaticDuration,
    ),
  ));
}

class MyApp extends StatelessWidget {
  MyApp(this._defaultHome);

  final _defaultHome;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buildabrain',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(23, 142, 137, 1),
          fontFamily: 'Balsamiq',
          primaryTextTheme: TextTheme(
              headline1: TextStyle(fontFamily: 'Balsamiq'),
              caption: TextStyle(fontFamily: 'Balsamiq'),
              headline2: TextStyle(fontFamily: 'Balsamiq'),
              headline3: TextStyle(fontFamily: 'Balsamiq'),
              headline4: TextStyle(fontFamily: 'Balsamiq'),
              button: TextStyle(fontFamily: 'Balsamiq'),
              subtitle1: TextStyle(fontFamily: 'Balsamiq'),
              subtitle2: TextStyle(fontFamily: 'Balsamiq'),
              overline: TextStyle(fontFamily: 'Balsamiq')),
          primaryIconTheme: IconThemeData(color: Colors.black)),
      home: _defaultHome,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String identity;
  QuerySnapshot teacher;

  List<DocumentSnapshot> userInfo;
  List<DocumentSnapshot> childrenInfo;
  List<String> childrenName = [];
  String dropdownValue;

  Future<List> init() async {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        if (docs.documents[0].data["relationship"] == "Mother")
          Firestore.instance
              .collection('students')
              .where('motherUid', isEqualTo: user.uid)
              .getDocuments()
              .then((children) {
            setState(() {
              userInfo = docs.documents;
              childrenInfo = children.documents;
              print("User: ${userInfo}");
              print("Children: ${childrenInfo}");
              for (int i = 0; i < childrenInfo.length; i++) {
                childrenName.add(childrenInfo[i]["firstName"]);
              }
            });
          });
        if (docs.documents[0].data["relationship"] == "Father")
          Firestore.instance
              .collection('students')
              .where('fatherUid', isEqualTo: user.uid)
              .getDocuments()
              .then((children) {
            setState(() {
              userInfo = docs.documents;
              childrenInfo = children.documents;
              print("User: ${userInfo}");
              print("Children: ${childrenInfo}");

              for (int i = 0; i < childrenInfo.length; i++) {
                childrenName.add(childrenInfo[i]["firstName"]);
              }
            });
          });
      });
    });
  }

  Future _neverSatisfied(url) {
    print(url);
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'My QR code',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Image.network(url)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TabController tabController;

  @override
  void initState() {
    setState(() {
      Firestore.instance
          .collection('users/26UTUC4DV1qusU2lIwrq/timestamps')
          .orderBy("date", descending: true)
          .getDocuments();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("lib/Assets/bdblogo.jpg"))),
              ),
              ListTile(
                title: Text('Profile'),
                trailing: Icon(Icons.account_circle),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(teacher)));
                },
              ),
              identity == "Parent"
                  ? ListTile(
                      title: DropdownButton(
                        //
                        hint: Text(
                          "Sign into classroom",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        elevation: 0,
                        underline: Container(
                          height: 2,
                          color: Colors.white12,
                        ),

                        icon: Container(),
                        value: dropdownValue,
                        style: TextStyle(color: Colors.black),
                        onChanged: (newValue) {
                          setState(() {});
                        },
                        items: childrenInfo.map((value) {
                          return DropdownMenuItem(
                            child: new GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                _neverSatisfied(value.data["qrCodeUrl"]);
                              },
                              child: new Text(
                                value.data["firstName"],
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                            value: value,
                          );
                        }).toList(),
                      ),
                      trailing: Icon(Icons.av_timer),
                      onTap: () {},
                    )
                  : identity == "Teacher"
                      ? ListTile(
                          title: Text('My QR code'),
                          trailing: Image.asset(
                            'lib/Assets/qrcode.png',
                            color: Colors.grey,
                            height: 30,
                            width: 30,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _neverSatisfied(
                                teacher.documents[0].data["qrCodeUrl"]);
                          },
                        )
                      : Container(),
              ListTile(
                title: Text('Performance'),
                trailing: Icon(Icons.person),
                onTap: () {},
              ),
              ListTile(
                title: Text('Payment'),
                trailing: Icon(Icons.attach_money),
                onTap: () {},
              ),
              ListTile(
                title: Text("Calendar"),
                trailing: Icon(Icons.calendar_today),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Calendar()));
                },
              ),
              ListTile(
                title: Text("Gallery"),
                trailing: Icon(Icons.image),
                onTap: () {},
              ),
              ListTile(
                title: Text("Sign Out"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => WelcomePage()),
                      (route) => false);
                },
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: new CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            expandedHeight: height / 2.7,
            flexibleSpace: new FlexibleSpaceBar(
              background: Stack(children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(left: width / 25, top: height / 10),
                    child: Image.asset(
                      "lib/Assets/hand.png",
                      color: Color.fromRGBO(0, 0, 0, 0.06),
                      width: width / 2,
                    )),
                Positioned(
                  top: height / 4,
                  left: 30,
                  child: Text(
                    "Hello,",
                    style: TextStyle(
                      fontSize: 42,
                    ),
                  ),
                ),
                Positioned(
                    top: height / 3.2,
                    left: 30,
                    child: identity == "Parent"
                        ? Text(
                            userInfo[0]["firstName"],
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container()),
              ]),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                "Weekly lessons",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 100,
                            width: width * (4 / 10),
                            child: MaterialButton(
                              color: Colors.orange,
                              onPressed: () {},
                              child: Text(
                                "Mindmap",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.orange)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 100,
                            width: width * (4 / 10),
                            child: MaterialButton(
                              color: Colors.purple,
                              onPressed: () {},
                              child: Text(
                                "IQ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.purple)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 5),
                          Container(
                            height: 100,
                            width: width * (4 / 10),
                            child: MaterialButton(
                              color: Colors.blue,
                              onPressed: () {},
                              child: Text(
                                "Art",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blue)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 100,
                            width: width * (4 / 10),
                            child: MaterialButton(
                              color: Colors.green,
                              onPressed: () {},
                              child: Text(
                                "Phonics",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green)),
                            ),
                          ),
                        ],
                      )
                    ]))),
            Container(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                "Upcoming events",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CarouselSlider.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int itemIndex) =>
                  GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Calendar()));
                }, // handle your image tap here
                child: Image.asset(
                  'lib/Assets/calendar${(itemIndex + 1).toString()}.jpg',
                  fit: BoxFit.cover, // this is the solution for border
                  width: 210.0,
                  height: 110.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                "Recent Pictures",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: CarouselSlider(
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black87),
                          ));
                    },
                  );
                }).toList(),
              ),
            )
          ]))
        ]));
  }
}
