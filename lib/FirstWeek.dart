import 'package:flutter/material.dart';

class WeekOne extends StatefulWidget {
  @override
  _WeekOneState createState() => _WeekOneState();
}

class _WeekOneState extends State<WeekOne> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text("First Week"),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30,),
          onPressed: () {
              Navigator.of(context).pop();
          },
        ),


      ),



      body: ListView(
        children: <Widget>[
          Image.asset("lib/Assets/face.jpg", height: 300,),
          Container(
            padding: EdgeInsets.only(left: 30, top: 30),
            child: Text(
              "Objective",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 30, right: 10),
            child: Text(
              "Students will be able to identify and recognise the different parts of the face. Also they will be able to pronounce the different words out correctly. ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                height: 1.5
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}