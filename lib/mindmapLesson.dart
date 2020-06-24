import 'package:buildabrain/FirstWeek.dart';
import 'package:flutter/material.dart';

class MindMapLesson extends StatefulWidget {
  @override
  _MindMapLessonState createState() => _MindMapLessonState();
}

class _MindMapLessonState extends State<MindMapLesson> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.keyboard_arrow_left, size: 30,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Mind map lesson"),
        ),


        body: new ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 30, left: 20, bottom: 40),
                  child: Text("What will you learn this week?",
                    style: TextStyle(
                        fontSize: 20
                    ),)
              ),
              Stack(
                children: <Widget>[

                  Center(
                    child:
                    Container(
                      child: Image.asset(
                        "lib/Assets/bodyparts.png",
                        height: 200,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(top: 30, left: 20, bottom: 40),
                  child: Text("Weekly topics: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),)
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 0,
                    color: Color.fromRGBO(255, 0, 0, 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                          18.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: ListTile(
                          leading: Image.asset("lib/Assets/face.jpg"),
                          title: Text('First Week',),
                          trailing: IconButton(
                              icon: Icon(Icons.play_arrow, size: 50, color: Colors.orange,),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => WeekOne()));
                              },

                          ),
                          subtitle: Text(
                              'Parts of the face'),
                        ),
                        ),
                      ],

                    ),
                  )
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 0,
                    color: Color.fromRGBO(66, 222, 0, 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                          18.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child:  ListTile(
                            leading: Image.asset("lib/Assets/upper.png"),
                            title: Text('Second Week',),
                            trailing: Icon(Icons.play_arrow, size: 50, color: Colors.orange,),
                            subtitle: Text(
                                'Upper body'),
                          ),
                        )
                      ],

                    ),
                  )
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 0,
                    color: Color.fromRGBO(0, 68, 224, 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                          18.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child:  ListTile(
                            leading:Image.asset("lib/Assets/lower.jpg"),
                            title: Text('Third Week',),
                            trailing: Icon(Icons.play_arrow, size: 50, color: Colors.orange,),
                            subtitle: Text(
                                'Lower body'),
                          ),
                        )
                      ],

                    ),
                  )
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 0,
                    color: Color.fromRGBO(255, 173, 0, 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                          18.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child:  ListTile(
                            leading: Image.asset("lib/Assets/skeleton.jpg"),
                            title: Text('Fourth Week',),
                            trailing: Icon(Icons.play_arrow, size: 50, color: Colors.orange,),
                            subtitle: Text(
                                'Inner parts'),
                          ),
                        )
                      ],

                    ),
                  )
              )

            ]
        )
    );
  }
}