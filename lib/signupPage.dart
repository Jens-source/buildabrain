import 'package:buildabrain/Owner/ownerHome.dart';
import 'package:buildabrain/Parent/parentHome.dart';
import 'package:buildabrain/Parent/parentSignup.dart';
import 'package:buildabrain/Owner/leaderSignup.dart';
import 'package:buildabrain/chooseIdentity.dart';
import 'package:buildabrain/Teacher/teacherSignup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'services/userManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  SignupPage(this.identity);
  final identity;

  @override
  _SignupPageState createState() => _SignupPageState(this.identity);
}

class _SignupPageState extends State<SignupPage> {
  _SignupPageState(this.identity);
  final identity;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentUser;

  String _password;
  String _email;

  AuthCredential credential1;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    credential1 = credential;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(
            child: CircularProgressIndicator(),
          ));
        });

    final FirebaseUser user = await _auth.signInWithCredential(credential);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((value) {
      Navigator.of(context).pop();
      if (value.documents[0].data['identity'] == "Leader") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => OwnerHome(value, 0)));
      } else if (value.documents[0].data['identity'] == "Teacher") {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
      } else if (value.documents[0].data['identity'] == "Parent") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ParentHome(value, 0, 0)));
      }
    }).catchError((e) async {
      FirebaseUser us = await FirebaseAuth.instance.currentUser();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Center(
                  child: Text("Choose your identity"),
                ),
                content: StatefulBuilder(
                    // You need this, notice the parameters below:
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                      width: 500,
                      height: 200,
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: Text(1.toString()),
                            title: Text("Teacher"),
                            onTap: () {
                              UserManagement().storeNewTeacher(us, context);
                              UserManagement.updateFirstName(
                                  us.displayName.split(" ")[0]);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          TeacherSignup(
                                              us.displayName.split(" "),
                                              user.photoUrl)),
                                  (route) => false);
                            },
                          ),
                          ListTile(
                            leading: Text(2.toString()),
                            title: Text("Parent"),
                            onTap: () {
                              UserManagement().storeNewParent(us, context);
                              UserManagement.updateFirstName(
                                  us.displayName.split(" ")[0]);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ParentSignup(
                                              us.displayName.split(" ")[0],
                                              user.photoUrl)),
                                  (route) => false);
                            },
                          ),
                          ListTile(
                            leading: Text(3.toString()),
                            title: Text("Leader"),
                            onTap: () {
                              String password;
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text("Enter Password: "),
                                      content: new TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder()),
                                        onChanged: (value) {
                                          setState(() {
                                            password = value;
                                          });
                                        },
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            if (password == 'bdbbest') {
                                              UserManagement()
                                                  .storeNewLeader(us, context);
                                              UserManagement.updateFirstName(
                                                  us.displayName.split(" "));
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LeaderSignup(
                                                              us.displayName
                                                                  .split(" "),
                                                              us.photoUrl)),
                                                  (route) => false);
                                            } else {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text(
                                            "CONTINUE",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "CANCEL",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ],
                      ));
                }));
          });
    });

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  String _status = 'no-action';
  String name;

  Future validateEmail(email) async {
    var sign;

    try {
      sign =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
    } on PlatformException catch (e) {
      print(e);
      print(e.message);
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            );
          });
    }

    if (sign != null && sign.length == 0) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Email not found"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            );
          });
    }
  }

  bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      backgroundColor: Color.fromRGBO(23, 142, 137, 1),
      body: new Stack(
        children: <Widget>[
          Container(
              width: width,
              height: height / 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(1000),
                      bottomLeft: Radius.circular(1000)),
                  color: Colors.white)),
          Container(
            padding: EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3, 3),
                              color: Colors.grey,
                              blurRadius: 3)
                        ]),
                    height: 160,
                    width: 160,
                    child: new CircleAvatar(
                      backgroundImage: AssetImage(
                        "lib/Assets/bdblogo.jpg",
                      ),
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: height / 3.3),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Sign-up',
                        style: TextStyle(
                          fontFamily: 'Balsamiq',
                          color: Colors.white70,
                          fontSize: 35.0,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                      ),
                      height: 40,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            _email = value.trim();
                          });
                        },
                        decoration: new InputDecoration(
                          icon: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                          hintText: "E-MAIL",
                          hintStyle: TextStyle(fontFamily: 'Balsamiq'),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                      ),
                      height: 40,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: passwordVisible,
                        onChanged: (value) {
                          setState(() {
                            _password = value.trim();
                          });
                        },
                        cursorColor: Colors.black,
                        decoration: new InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                                // Based on passwordVisible state choose the icon
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          icon: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.lock, color: Colors.black),
                          ),
                          hintText: "PASSWORD",
                          hintStyle: TextStyle(fontFamily: 'Balsamiq'),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 100, right: 100),
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white12),
                    child: Center(
                      child: FlatButton(
                        child: Text(
                          "SIGN-UP",
                          style: TextStyle(
                              fontFamily: 'Balsamiq',
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_email != null && _password != null) {
                            await validateEmail(_email);
                            var sign;
                            try {
                              if (sign == null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Center(
                                        child: CircularProgressIndicator(),
                                      ));
                                    });
                              }
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _email, password: _password)
                                  .then((value) {
                                setState(() {
                                  sign = value;
                                });
                              });
                            } on PlatformException catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(e.message),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "OK",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            } on FirebaseUser catch (e) {
                              Firestore.instance
                                  .collection('users')
                                  .where('uid', isEqualTo: e.uid)
                                  .getDocuments()
                                  .then((value) {
                                if (value.documents[0].data['identity'] ==
                                    "Teacher") {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MyHomePage()),
                                      (route) => false);
                                } else if (value
                                        .documents[0].data['identity'] ==
                                    "Parent") {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MyApp(ParentHome(value, 0, 0))),
                                      (route) => false);
                                } else if (value
                                        .documents[0].data['identity'] ==
                                    "Leader") {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              OwnerHome(value, 0)),
                                      (route) => false);
                                }
                              });
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        Text("Please enter your credentials"),
                                    content: FlatButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  child: Text(
                    "OR SIGN-UP USING",
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Balsamiq'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white),
                        height: 70,
                        width: 70,
                        child: Image.asset("lib/Assets/googleIcon.png"),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Image.asset("lib/Assets/facebook.png"),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
