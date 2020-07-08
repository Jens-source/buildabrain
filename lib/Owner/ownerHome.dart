import 'package:buildabrain/Owner/ownerCalendar.dart';
import 'package:buildabrain/Owner/staffInfo.dart';
import 'package:buildabrain/Owner/studentInfo.dart';
import 'package:buildabrain/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;


class OwnerHome extends StatefulWidget {
  @override
  _OwnerHome createState() => _OwnerHome();
}

class _OwnerHome extends State<OwnerHome> {



  bool change;
  String scanStudent;
  String scanTeacherIn;
  String scanTeacherOut;


  void _scanOutDialog(scanTeacherOut) {
    Duration time;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Teaching Hours"),
            content: Container(
              height: 100,
              child:

            CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm,
              minuteInterval: 10,


              onTimerDurationChanged: (Duration changedtimer) {
                setState(() {
                  time = changedtimer;
                });
              },
            ),
            ),


            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("CANCEL", style: TextStyle(
                    color: Colors.blue
                ),),
              ),
              FlatButton(
                onPressed: () async {

                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                            builder: (context, setState) {
                              return new AlertDialog(
                                title: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                            });
                      });



                  await Firestore.instance.collection('users')
                      .where('uid', isEqualTo: scanTeacherOut)
                      .getDocuments()
                      .then((docs){
                    Firestore.instance.document('users/${docs.documents[0].documentID}')
                        .collection('timestamps')
                        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
                      .getDocuments()
                      .then((val) async {

                        if(val.documents[0].data['minutes'] == 0)
                          {
                            await Firestore.instance.document('users/${docs.documents[0].documentID}/timestamps/${val.documents[0].documentID}')
                                .updateData({
                              'minutes': time.inMinutes,
                              'timeOut' :  DateFormat('Hm').format(DateTime.now()),
                            });
                            Navigator.of(context).pop();


                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                        return new AlertDialog(
                                          title: ListTile(
                                            title: Text("Signed out successfully"),


                                          ),

                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("OK", style: TextStyle(
                                                color: Colors.blue
                                              ),),
                                            )
                                          ],
                                        );

                                      });
                                });



                          }


                        else{

                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                      return new AlertDialog(
                                        title: ListTile(
                                          title: Text("Already signed out"),


                                        ),

                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();

                                            },
                                            child: Text("OK", style: TextStyle(
                                                color: Colors.blue
                                            ),),
                                          )
                                        ],
                                      );

                                    });
                              });


                        }
                    });


                  });

                },

                child: Text("ADD", style: TextStyle(
                  color: Colors.blue
                ),),
              )


            ],

          );
        }
    );
  }


//
  Future<void> scanning() async {
    setState(() {
      scanStudent = "";
      scanTeacherIn = '';
      scanTeacherOut = '';
      change = false;
    });




    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          content: StatefulBuilder( // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState)
      {
        return Container(
            height: 300,
            width: 300,
            child: ListView(
                children: <Widget>[


                  Center(
                    child:  Text("User type", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                  ),


                  SizedBox(
                    height: 80,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: change == false? Colors.blue : Colors.green,

                          boxShadow: [
                            BoxShadow(color: Colors.grey, offset: Offset(1, 2)),

                          ]
                        ),

                        child: FlatButton(

                          onPressed: () async{

                            if(change == false){
                              scanStudent = await scanner.scan();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                          return new AlertDialog(
                                            title: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );

                                        });
                                  });

                              await Firestore.instance.document('students/${scanStudent}')
                              .collection('timestamps')
                              .add({
                                'date' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                'time' : DateFormat('Hm').format(DateTime.now()),
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();





                            }

                            else{
                              scanTeacherIn = await scanner.scan();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                          return new AlertDialog(
                                            title: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );

                                        });
                                  });


                              await Firestore.instance.collection('users')
                              .where('uid', isEqualTo: scanTeacherIn)
                              .getDocuments()
                              .then((docs){



                                Firestore.instance.document('users/${docs.documents[0].documentID}')
                                    .collection('timestamps')
                                .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
                                .getDocuments()
                                .then((value) async{



                                  if(value.documents.length == 0){
                                    await Firestore.instance.document('users/${docs.documents[0].documentID}')
                                        .collection('timestamps')
                                        .add({
                                      'date' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                      'time' : DateFormat('Hm').format(DateTime.now()),
                                      'minutes': 0
                                    });

                                  }

                                  else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                                return new AlertDialog(
                                                  title: ListTile(
                                                    title: Text("Already signed in"),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                      },

                                                      child: Text("OK", style: TextStyle(
                                                          color: Colors.blue
                                                      ),),
                                                    )
                                                  ],
                                                );
                                              });
                                        });

                                  }
                                });
                              });
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                          return new AlertDialog(
                                            title: ListTile(
                                              title: Text("Signed in successfully"),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },

                                                child: Text("OK", style: TextStyle(
                                                  color: Colors.blue
                                                ),),
                                              )
                                            ],
                                          );
                                        });
                                  });
                            }

                          },
                          child: change == false? Text("Student", style: TextStyle(
                            color: Colors.white
                          ),) : Text("Sign In", style: TextStyle(
                              color: Colors.white
                          ),)
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: change == false?  Colors.blue: Colors.red,
                            boxShadow: [
                              BoxShadow(color: Colors.grey, offset: Offset(1, 2)),
                            ]
                        ),

                        child: FlatButton(
                          onPressed: () async{

                            if(change == true){
                              scanTeacherOut = await scanner.scan();
                              _scanOutDialog(scanTeacherOut);
                            }
                            setState(() {
                              change = true;
                            });
                          },
                          child: change == false? Text("Teachers", style: TextStyle(
                              color: Colors.white
                          ),):  Text("Sign Out", style: TextStyle(
                              color: Colors.white
                          ),),

                        ),
                      )
                    ],
                  )



                ]
            )
        );
      }));
  });

  }

  Future scan(user, val) async {
    await Firestore.instance.document('students/${val}')
        .collection('timestamps')
        .add({
      "timestamp": DateTime.now()
    });
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
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Color.fromRGBO(219, 220, 224, 1),
      appBar: AppBar(
        title: Text("Buildabrain"),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(15),
                  child:
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return StudentAv();
                              }
                          )
                      );
                    },
                      child:
                      Container(
                        height: height / 4,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                  offset: Offset(
                                      5,
                                      5
                                  )
                              )
                            ]
                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Icon(Icons.date_range, size: 50,),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Text("Schedule", style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),),
                              )
                            ],
                          ),

                        ),
                      )),
              Container(
                  padding: EdgeInsets.all(15),
                  child:
                  GestureDetector(
                    onTap: () async{
                      scanning();




                    },
                      child:
                      Container(
                        height: height / 4,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                  offset: Offset(
                                      5,
                                      5
                                  )
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.account_box, size: 50,),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Text("Scan", style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),),
                            )
                          ],
                        ),
                      ))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(15),
                  child:
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return Preschoolers();
                              }
                          )
                      );
                    },
                    child:
                    Container(
                      height: height / 4,
                      width: width / 2.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: Offset(
                                    5,
                                    5
                                )
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.child_care, size: 50,),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Text("Unset students", style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      ),

                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(15),
                  child:
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) {
                                  return  StaffInfo();
                                }
                            )
                        );
                      },
                      child:
                      Container(
                        height: height / 4,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                  offset: Offset(
                                      5,
                                      5
                                  )
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.face, size: 50,),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Text("Staff Info", style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),),
                            )
                          ],
                        ),
                      ))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(15),
                  child:
                  GestureDetector(
                    onTap: () {},
                    child:
                    Container(
                      height: height / 4,
                      width: width / 2.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: Offset(
                                    5,
                                    5
                                )
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.payment, size: 50,),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Text("Payment", style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      ),

                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(15),
                  child:
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) {
                                  return Lessons();
                                }
                            )
                        );


                      },
                      child:
                      Container(
                        height: height / 4,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                  offset: Offset(
                                      5,
                                      5
                                  )
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.assignment, size: 50,),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Text("Lessons", style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),),
                            )
                          ],
                        ),
                      ))),
            ],
          )
        ],
      ),
    );
  }

}



class Lessons extends StatefulWidget {


@override
_Lessons createState() => _Lessons();
}

class _Lessons extends State<Lessons> {



  List lessons = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection('lessons')
    .getDocuments()
    .then((docs){
      for(int i = 0; i < docs.documents.length; i++){
        lessons.add(docs.documents[i]);
      }
      setState(() {
        lessons.sort((a, b){
          var alesson = a.data['startDate'];
          var blesson = b.data['startDate'];
          return alesson.compareTo(blesson);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Lessons"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){


            },
          )
        ],
      ),



      body: ListView.builder(
        itemCount: lessons == null ? 0 : lessons.length,
          itemBuilder: (BuildContext context, i){
            return new ListTile(
              title: Text(lessons[i]['subject']),
            );
          })
    );
  }


}
