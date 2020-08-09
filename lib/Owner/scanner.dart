import 'package:buildabrain/Owner/ownerHome.dart';
import 'package:buildabrain/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;



class Scanner extends StatefulWidget {


  Scanner(this.user);
  final user;
  @override
  _ScannerState createState() => _ScannerState(this.user);
}

class _ScannerState extends State<Scanner> {

  _ScannerState(this.user);
  final user;
  bool extend = false;
  Duration time;
  double height;
  String startTime = DateFormat('Hm').format(DateTime.now());
  Duration timeTeaching;


  String userScan;


  Future<void> scan() async {
    userScan = await scanner.scan();


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


    await Firestore.instance.collection('users').where(
        'uid', isEqualTo: userScan).getDocuments()
        .then((value) async {

      if (value.documents[0].data['identity'] == "Teacher") {
        print("Teacher");



        await Firestore.instance.collection('users/${value.documents[0].documentID}/timestamps')
            .where(
            'date', isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .getDocuments()
            .then((docs) async {
          if (docs.documents.length == 0) {
            print("No document for this teacher and day yet");
            await Firestore.instance.collection('users/${value.documents[0].documentID}/timestamps')
                .add({
              'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'time': DateFormat('Hm').format(DateTime.now()),
            });
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyApp(OwnerHome(user)))
            );
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (context, setState) {
                        return new AlertDialog(
                          title: Text("Success"),
                          content: Text("Successfully scanned in."),
                          actions: [
                            FlatButton(
                              child: Text("OK", style: TextStyle(
                                  color: Colors.blue
                              ),),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                });


          } else {

            if(docs.documents[0].data['timeOut'] == null){
              print("Hasn't scanned out yet.");



              await Firestore.instance.collection('users/${value.documents[0].documentID}/timestamps')
              .limit(4)
              .getDocuments()
              .then((scanningDocs) async {
                for(int i = 0; i < scanningDocs.documents.length; i++){

                  if(scanningDocs.documents[i].data['timeOut'] == null){

                    await showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setState) {



                                return new AlertDialog(
                                  title: Text("Missed a Sign out"),
                                  content: Container(
                                    height: 400,
                                    child: Column(
                                      children: [
                                        Text("What time did you leave the school on ${scanningDocs.documents[i].data['date']}?"),
                                        ListTile(
                                          title: Text(startTime, style: TextStyle(
                                              color: Colors.grey
                                          ),),
                                          trailing: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Future<TimeOfDay> selectedTime = showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              ).then((val) {
                                                setState(() {
                                                  final now = new DateTime.now();
                                                  DateTime t = DateTime(
                                                      now.year, now.month, now.day,
                                                      val.hour, val.minute);
                                                  startTime = DateFormat('Hm').format(t);
                                                });
                                              });
                                            },
                                          ),

                                        ),
                                        Container(
                                          height: 200,
                                          child: CupertinoTimerPicker(
                                            mode: CupertinoTimerPickerMode.hm,
                                            minuteInterval: 10,
                                            onTimerDurationChanged: (Duration changedtimer) {
                                              setState(() {
                                                timeTeaching = changedtimer;
                                              });
                                            },
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                  actions: [

                                    FlatButton(
                                      child: Text("OK", style: TextStyle(
                                          color: Colors.blue
                                      ),),
                                      onPressed: () async {

                                        if( timeTeaching != null){
                                          await Firestore.instance.document('users/${value.documents[0].documentID}/timestamps/${scanningDocs.documents[i].documentID}')
                                              .updateData({
                                            "timeOut": startTime,
                                            "minutes": timeTeaching.inMinutes

                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                    )
                                  ],
                                );
                              });
                        });



                  }
                }
              });




              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (context, setState) {


                          return  new AlertDialog(
                              title: Text("Scanning Teacher out"),
                              content: AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn,
                                  height: height,
                                  child: extend == false ?
                                  Text("Do you want to scan ${value.documents[0].data['firstName']} out?") :

                                  Column(
                                    children: [


                                          Text("How many hours did ${value.documents[0].data['firstName']} work today?"),
                                          Container(
                                            height: 200,
                                            child: CupertinoTimerPicker(
                                              mode: CupertinoTimerPickerMode.hm,
                                              minuteInterval: 10,


                                              onTimerDurationChanged: (Duration changedtimer) {
                                                setState(() {
                                                  time = changedtimer;
                                                });
                                              },
                                            ),
                                          ),
                                    ],
                                  )
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(extend == false ? "OK" : "FINISH", style: TextStyle(
                                      color: Colors.blue
                                  ),),
                                  onPressed: () async {

                                    if(extend == false){
                                      setState(() {
                                        extend = !extend;
                                        height = 300;
                                      });
                                    }

                                    if(extend == true && time != null){
                                      await Firestore.instance.document('users/${value.documents[0].documentID}/timestamps/${docs.documents[0].documentID}')
                                          .updateData({
                                        'minutes': time.inMinutes,
                                        "timeOut" : DateFormat('Hm').format(DateTime.now()),

                                      });
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyApp(OwnerHome(user)))
                                      );
                                    }

                                  },
                                ),
                                FlatButton(
                                  child: Text("NOT YET", style: TextStyle(
                                      color: Colors.blue
                                  ),),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyApp(OwnerHome(user)))
                                    );
                                  },
                                )
                              ],
                          );
                        });
                  });


            }
            else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (context, setState) {
                          return new AlertDialog(
                            title: Text("Scanning Error"),
                            content: Text(
                                "This teacher has already scanned in today."),
                            actions: [
                              FlatButton(
                                child: Text("OK", style: TextStyle(
                                    color: Colors.blue
                                ),),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyApp(OwnerHome(user)))
                                  );
                                },
                              )
                            ],
                          );
                        });
                  });
            }
          }
        }).catchError((e)
        {


        });
      }
    }).catchError((error) async {
      if (error.runtimeType == RangeError) {
        print("Student");
        await Firestore.instance.document('students/${userScan}')
            .collection('timestamps')
            .where(
            'date', isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .getDocuments()
            .then((value) async {
          if (value.documents.length == 0) {
            print("No document for this student and day yet");
            await Firestore.instance.document('students/${userScan}')
                .collection('timestamps')
                .add({
              'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'time': DateFormat('Hm').format(DateTime.now()),
            });
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyApp(OwnerHome(user)))
            );
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (context, setState) {
                        return new AlertDialog(
                          title: Text("Success"),
                          content: Text("Successfully scanned in."),
                          actions: [
                            FlatButton(
                              child: Text("OK", style: TextStyle(
                                  color: Colors.blue
                              ),),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                });
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (context, setState) {
                        return new AlertDialog(
                          title: Text("Scanning Error"),
                          content: Text(
                              "This student has already scanned in today."),
                          actions: [
                            FlatButton(
                              child: Text("OK", style: TextStyle(
                                  color: Colors.blue
                              ),),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyApp(OwnerHome(user)))
                                );
                              },
                            )
                          ],
                        );
                      });
                });
          }
        }).catchError((noDoc) async {
          if (error.runtimeType == RangeError) {

          }
        });
      }
    });
  }



  @override
  void initState() {




    scan();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Container();

  }

}
