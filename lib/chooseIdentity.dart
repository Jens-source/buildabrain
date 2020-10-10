import 'package:buildabrain/Owner/leaderSignup.dart';
import 'package:buildabrain/signupPage.dart';
import 'package:buildabrain/welcomePage.dart';
import 'package:flutter/material.dart';

class ChooseIdentity extends StatefulWidget {
  @override
  _ChooseIdentityState createState() => _ChooseIdentityState();
}

class _ChooseIdentityState extends State<ChooseIdentity> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      backgroundColor: Color.fromRGBO(23, 142, 137, 1),
      body: Stack(
        children: [
          Positioned(
              right: width / 1.6,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3000)),
                  color: Colors.brown,
                ),
                height: height * 1.1,
                width: height * 1.1,
              )),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignupPage("Leader")));
            },
            child: Stack(children: [
              Positioned(
                right: width / 6,
                top: height / 4.8,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  height: height / 8.5,
                  width: width / 2,
                  child: Center(
                    child: Text(
                      "ADMIN",
                      style: TextStyle(fontSize: 27),
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: width / 10,
                  top: height / 6,
                  child: Container(
                    width: height / 5,
                    height: height / 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                        color: Colors.brown,
                        border: Border.all(width: 15, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 0,
                              offset: Offset(8, 5),
                              color: Colors.black54,
                              blurRadius: 4),
                        ]),
                    child: Center(
                      child: Text(
                        "A",
                        style: TextStyle(color: Colors.white, fontSize: 80),
                      ),
                    ),
                  )),
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignupPage("Parent")));
            },
            child: Stack(children: [
              Positioned(
                right: width / 40,
                top: height / 2.25,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  height: height / 8.5,
                  width: width / 2,
                  child: Center(
                    child: Text(
                      "PARENT",
                      style: TextStyle(fontSize: 27),
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: width / 4.5,
                  top: height / 2.5,
                  child: Container(
                    width: height / 5,
                    height: height / 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                        color: Colors.brown,
                        border: Border.all(width: 15, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 0,
                              offset: Offset(8, 5),
                              color: Colors.black54,
                              blurRadius: 4),
                        ]),
                    child: Center(
                      child: Text(
                        "P",
                        style: TextStyle(color: Colors.white, fontSize: 80),
                      ),
                    ),
                  )),
            ]),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SignupPage("Teacher")));
            },
            child: Stack(children: [
              Positioned(
                right: width / 7,
                bottom: height / 4.8,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  height: height / 8.5,
                  width: width / 2,
                  child: Center(
                    child: Text(
                      "TEACHER",
                      style: TextStyle(fontSize: 27),
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: width / 10,
                  bottom: height / 6,
                  child: Container(
                    width: height / 5,
                    height: height / 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                        color: Colors.brown,
                        border: Border.all(width: 15, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 0,
                              offset: Offset(8, 5),
                              color: Colors.black54,
                              blurRadius: 4),
                        ]),
                    child: Center(
                      child: Text(
                        "T",
                        style: TextStyle(color: Colors.white, fontSize: 80),
                      ),
                    ),
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
