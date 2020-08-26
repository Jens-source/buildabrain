import 'package:buildabrain/Owner/addSchedule.dart';
import 'package:buildabrain/Owner/dashboard.dart';
import 'package:buildabrain/Owner/ownerCalendar.dart';
import 'package:buildabrain/Owner/scanner.dart';
import 'package:buildabrain/Owner/schedule.dart';
import 'package:buildabrain/Owner/staffInfo.dart';
import 'package:buildabrain/Owner/studentInfo.dart';
import 'package:buildabrain/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'addClass.dart';


class OwnerHome extends StatefulWidget {
  OwnerHome(this.user);
  final user;
  @override
  _OwnerHome createState() => _OwnerHome(this.user);
}

class _OwnerHome extends State<OwnerHome> with TickerProviderStateMixin{


  _OwnerHome(this.user);
  final user;


  bool change;
  String scanStudent;
  String scanTeacherIn;
  String scanTeacherOut;
  int tab;
  TabController _tabController;
  TabController bottomTabController;
  QuerySnapshot holidayQuery;
  QuerySnapshot promoQuery;
  String dropdownValue = 'Class';

  @override
  void initState() {



    _tabController = new TabController(length: 5, vsync: this);
    bottomTabController = new TabController(length: 5, vsync: this);
    tab = _tabController.index;


    setState(() {
      if (DateTime
          .now()
          .hour < 12) {
        timeOfDay = "Good Morning";
      }

      else {
        timeOfDay = "Good Afternoon";
      }
    });

    super.initState();
  }





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

  String timeOfDay;
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
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('schedule')
        .where('classDay', isEqualTo: DateFormat('EEEE').format(DateTime.now()))
        .snapshots(),
      builder: (context, snapshot) {

        if(!snapshot.hasData){
          return new Center(
            child: CircularProgressIndicator(),
          );
        }
        else
        return new Scaffold(
            extendBody: true,
          backgroundColor: Colors.white,

          appBar: AppBar(
            actions: [
              tab == 1 ?  Container(
                padding: EdgeInsets.only(right: 30),
                child: DropdownButton<String>(



                  underline: Container(),

            icon: Icon(Icons.add),
            iconSize: 30,
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            elevation: 16,
            onChanged: (String newValue) {
              if(newValue == "Class"){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) {
                          return AddClass( user );
                        }
                    )
                );
              }
              if(newValue == "Promotion"){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) {
                          return AddSchedule(DateTime.now(), null, null, null, null, null, null, null, null, null, null, user );
                        }
                    )
                );
              }

            },
            items: <String>['Class', 'Promotion']
                  .map<DropdownMenuItem<String>>((String value) {




                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
            }).toList(),
          ),
              ) : Container()
            ],
            leading:  tab == 1 ?  Icon(Icons.event, color: Colors.white,)

             : Container(),

            title: Row(
                children: [
                  tab == 0 ? FlatButton(
                    child:  Container(
                      width: 50,
                      height: 50,
                      child:
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.documents[0].data['photoUrl']),
                      ),
                    ),

                  ) : Container(),



                  SizedBox(
                    width: 20,
                  ),


                  Text(tab == 0 ? "${timeOfDay}... \n${user.documents[0].data['firstName']}" :

                  tab == 1 ? "Schedule" :
                  tab == 2 ? "Check-In" :
                  tab == 3 ? "Chat" :
                  tab == 4 ? "Settings" : ""),
                ]
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                )
            ),


          ),
            bottomNavigationBar: new Material(
              color: Color.fromRGBO(153, 107, 55, 1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              child: TabBar(
                onTap: (value) {
                  setState(() {
                    tab = _tabController.index;
                  });
                },
                unselectedLabelColor: Colors.white70,
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                controller: _tabController,
                tabs: <Widget>[

                  new Tab(child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 3),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("lib/Assets/home.png", height: 25,
                          color: tab == 0 ? Colors.white : Colors.white70,),
                        Text("HOME", style: TextStyle(fontSize: 7),)
                      ],),),),
                  new Tab(child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 3),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("lib/Assets/schedule.png", height: 25,
                            color: tab == 1 ? Colors.white : Colors.white70),
                        Text("SCHEDULE", style: TextStyle(fontSize: 7),)
                      ],),),),
                  new Tab(child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 3),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("lib/Assets/qrcode.png", height: 30,
                            color: tab == 2 ? Colors.white : Colors.white70),
                        Text("SCAN", style: TextStyle(fontSize: 7),)
                      ],),),),
                  new Tab(child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 3),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("lib/Assets/notify.png", height: 30,
                            color: tab == 3 ? Colors.white : Colors.white70),
                        Text("CHAT", style: TextStyle(fontSize: 7),)
                      ],),),),
                  new Tab(child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 3),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("lib/Assets/settings.png", height: 25,
                            color: tab == 4 ? Colors.white : Colors.white70),
                        Text("SETTINGS", style: TextStyle(fontSize: 7),)
                      ],),),),
                ],
              ),
            ),
          body: TabBarView(
        controller: _tabController,
        children: [
          Dashboard(user),
          Schedule(user),
          tab ==2? Scanner(user) : Container(),
          Container(),
          Container(),

          ]
          )


        );
      }
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
