import 'dart:ui';

import 'package:buildabrain/Parent/parentSignup.dart';
import 'package:buildabrain/Owner/leaderSignup.dart';
import 'package:buildabrain/Teacher/teacherSignup.dart';


import 'main.dart';
import 'welcomePage.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'services/userManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignupPage extends StatefulWidget {

  SignupPage(this.identity);
  final identity;

  @override
  _SignupPageState createState() => _SignupPageState(this.identity);
}

class _SignupPageState extends State<SignupPage> {

  _SignupPageState(this.identity);
  final identity;
  var name;

  String _email;
  String _password;
  String _name;
  String _status = 'no-action';

  bool backdrop = false;


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  get appAuth => null;


  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,


    );
    setState(() {
      name = (googleSignIn.currentUser.displayName).split(" ");

      print(name);
    });



    final FirebaseUser user = await _auth.signInWithCredential(credential);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    setState(() => this._status = 'loading');

    appAuth.login().then((result) {
      if (result && name != 0 ) {

      } else {
        setState(() => this._status = 'rejected');
      }
    });

      FirebaseAuth.instance.currentUser().then((val) {
        UserUpdateInfo updateUser = UserUpdateInfo();
        val.updateProfile(updateUser)
            .then((user) {
          FirebaseAuth.instance
              .currentUser()
              .then((user) {
                if(identity == "Leader"){
                  UserManagement().storeNewLeader(user,context);
                  UserManagement.updateFirstName(user.displayName.split(" "));
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
                      BuildContext context) =>  LeaderSignup(user.displayName.split(" "), user.photoUrl)), (route) => false);

                }
                if(identity == "Teacher"){
                  UserManagement().storeNewTeacher(user,context);
                  UserManagement.updateFirstName(user.displayName.split(" ")[0]);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
                      BuildContext context) =>  TeacherSignup(user.displayName.split(" "), user.photoUrl)), (route) => false);
                }
                if(identity == "Parent"){
                  UserManagement().storeNewParent(user,context);
                  UserManagement.updateFirstName(user.displayName.split(" ")[0]);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
                      BuildContext context) =>  ParentSignup(user.displayName.split(" ")[0], user.photoUrl)), (route) => false);

                }




          }).catchError((e) {
            print(e);
          });
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
    });

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async{
    await googleSignIn.signOut();

    print("User Sign Out");
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return new Scaffold(
        appBar: new AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white24,
            leading: new IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black,),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            )
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[



          backdrop == false ? Container() :  Container(
              width: width,
              height: height,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                child: Container(
                  child: Center(
                    child:
                  CircularProgressIndicator(),

                ),
                  color: Colors.black.withOpacity(0.2),
              ),
              )
            ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text('Create an account',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Column(
                    children: <Widget>[
                      TextField(
                          decoration: InputDecoration(
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              // hintText: 'EMAIL',
                              // hintStyle: ,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          }
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                          decoration: InputDecoration(
                              labelText: 'PASSWORD ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          }
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                          decoration: InputDecoration(
                              labelText: 'NAME',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          onChanged: (value) {
                            setState(() {
                              _name = value;
                            });
                          }
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        width: 270,
                        height: 40,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color.fromRGBO(81, 113, 100, 0.8),
                        ),
                        child: OutlineButton(
                          child: Center(
                              child: Text('Signup',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  )
                              )
                          ),
                          onPressed: () async {

                            setState(() {
                              backdrop = true;
                            });


                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                email: _email, password: _password)
                                .then((signedInUser) {
                                  print("Signed ${signedInUser}");
                              FirebaseAuth.instance.currentUser().then((val) {
                                UserUpdateInfo updateUser = UserUpdateInfo();
                                val.updateProfile(updateUser)

                                    .then((user) {
                                  FirebaseAuth.instance
                                      .currentUser()
                                      .then((user) {
                                    if(identity == "Parent") {
                                      UserManagement().storeNewParent(user,context);
                                      UserManagement.updateFirstName(_name);
                                      Navigator.of(context).pop();


                                    }

                                    if(identity == "Teacher")
                                    {
                                      UserManagement().storeNewTeacher(user, context);
                                      UserManagement.updateFirstName(_name);
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
                                          BuildContext context) =>  TeacherSignup(_name, null)), (route) => false);

                                    }




                                    if(identity == "Leader")
                                    {
                                      UserManagement().storeNewLeader(user, context);
                                      UserManagement.updateFirstName(_name);
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
                                          BuildContext context) => LeaderSignup(
                                          _name, null)), (route) => false);


                                    }



                                  }).catchError((e) {
                                    print(e);
                                  });
                                }).catchError((e) {
                                  print(e);
                                });
                              }).catchError((e) {
                                print(e);
                              });
                            });
                          },
                        ),
                      ),
                    ]
                )
            ),
            SizedBox(
              height: 30,
            ),




                Container(
                  child:
                  Row(
                      children: <Widget>[

                        Container(
                          padding: EdgeInsets.only(left: width / 8,bottom: 15),
                          child: Text('___________',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold,
                                  color: Colors.black38)),
                        ),



                        Container(
                          padding: EdgeInsets.only(left: 5, ),
                          child: Text('or continue with',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black38)),
                        ),

                        Container(
                          padding: EdgeInsets.only(left: 5, bottom: 15),
                          child: Text('__________',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold,
                                  color: Colors.black38)),
                        ),
                      ]
                  ),
                ),
                            Center(
                              child:
                              Container(
                                padding: EdgeInsets.only(top: 40),

                                  child: GestureDetector(
                                      onTap: () {
                                        signInWithGoogle();
                                      },
                                      child:
                                      Container(
                                          width: 200,
                                          height: 30,
                                          decoration: new BoxDecoration(
                                            borderRadius: BorderRadius.circular(7.0),
                                            color: Color.fromRGBO(81, 113, 100, 0.2),
                                          ),
                                          child: Container(
                                            child: new Image.asset('lib/Assets/googleIcon.png',),
                                          )
                                      )
                                  )
                              ),

                        )

          ],
        )
          ],
        )
    );
  }



}
