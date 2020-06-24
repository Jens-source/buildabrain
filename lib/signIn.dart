import 'package:buildabrain/Owner/ownerHome.dart';
import 'package:buildabrain/welcomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signupPage.dart';
import 'package:google_sign_in/google_sign_in.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;




  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );


    final FirebaseUser user = await _auth.signInWithCredential(credential);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);


    String u;

    await Firestore.instance.collection('users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((docs) {
        u = docs.documents[0].data['identity'];
    });
    return u;
  }

  void signOutGoogle() async{
    await googleSignIn.signOut();

    print("User Sign Out");
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white24,
            leading: new IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black,),
                onPressed: () {
                  Navigator.pop(context);
                }
            )
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text('Log In',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),

                      SizedBox(height: 20.0),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 25.0, left: 20.0),
                        child: InkWell(
                            child: Center(
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color.fromRGBO(81, 113, 100, 0.6),
                          elevation: 0,
                          child: OutlineButton(
                            child: Center(
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                            onPressed: () {

                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          child: Center(
                              child: Stack(
                                children: <Widget>[

                                  Container(
                                    child: Text('___________',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black38)),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 105, top: 10),
                                    child: Text('or continue with',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black38)),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(left: 220),
                                    child: Text('__________',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black38)),
                                  ),

                                  Center(
                                    child:
                                    Container(
                                        padding: EdgeInsets.only(top: 40),

                                        child: GestureDetector(
                                            onTap: () {
                                              signInWithGoogle().then((val){
                                                if (val == 'Leader') {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                            return OwnerHome();
                                                          }
                                                      )
                                                  );
                                                }


                                                else if (val == 'Teacher') {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                            return MyHomePage();
                                                          }
                                                      )
                                                  );
                                                }

                                                else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("No account found"),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child: Text("OK", style: TextStyle(
                                                                  color: Colors.blue
                                                              ),),
                                                              onPressed: (){
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) {
                                                                          return WelcomePage();
                                                                        }
                                                                    )
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      }
                                                  );
                                                }
                                              });

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
                          )
                      )
                    ]
                )

            )
          ],
        ));
  }
}

