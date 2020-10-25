import 'dart:io';
import 'dart:ui';

import 'package:buildabrain/Owner/ownerHome.dart';
import 'package:buildabrain/services/classManagement.dart';
import 'package:buildabrain/services/promotionManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ClosedDates extends StatefulWidget {
  ClosedDates(this.user);

  final user;

  @override
  _ClosedDatesState createState() => _ClosedDatesState(this.user);
}

class _ClosedDatesState extends State<ClosedDates> {
  _ClosedDatesState(this.user);

  final user;
  DateTime date;
  String time;
  InputBorder border;
  String teacher;
  List<String> teacherNames;

  var eventPhoto;
  String day;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String topic = "TOPIC";
  String description;
  String name;
  LatLng location;
  String material;
  String dressCode;
  String host;
  DragStartBehavior dragStartBehavior;
  List<Marker> allMarkers = [];
  int classesAmount = 1;
  String classType = "Preschool";

  List<String> subjects;

  @override
  void initState() {
    Firestore.instance
        .collection('users')
        .where('identity', isEqualTo: "Teacher")
        .getDocuments()
        .then((value) {
      teacherNames = new List(value.documents.length);
      for (int j = 0; j < value.documents.length; j++) {
        setState(() {
          teacherNames[j] = value.documents[j].data['firstName'];
        });
      }
    }).asStream();
    subjects = new List(classesAmount);
    dragStartBehavior = DragStartBehavior.down;
    time = "00:00 AM";
    startTime = TimeOfDay(hour: 12, minute: 0);
    endTime = TimeOfDay(hour: 14, minute: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (teacherNames == null) {
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Icon(
            Icons.event,
            color: Colors.white,
          ),
          title: Text("Closed Date"),
          actions: [
            FlatButton(
              child: Text(
                "CANCEL",
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              )),
        ),
        body: new ListView(children: [
          new Column(children: [
            Container(
                padding: EdgeInsets.all(15),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Row(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 150,
                              child: date != null ? Text(DateFormat("yMMMMd").format(date)) : Text(""),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.grey, size: 20,),
                              constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
                              onPressed: () async{
                               DateTime d;
                                d = await showDatePicker(
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime.now().add(Duration(days: 365)),
                                    firstDate: DateTime.now(),
                                    context: context,
                                );
                                setState(() {
                                  date = d;
                                });
                              },
                            ),



                          ],
                        ),

                        Container(
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),

                        Text(
                          "Make up class",
                          style: TextStyle(fontSize: 22),
                        ),
                        Container(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 150,
                              child: date != null ? Text(DateFormat("yMMMMd").format(date)) : Text(""),

                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.grey, size: 20,),
                              constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
                              onPressed: () async{
                                DateTime d;
                                d = await showDatePicker(
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime.now().add(Duration(days: 365)),
                                  firstDate: DateTime.now(),
                                  context: context,
                                );
                                setState(() {
                                  date = d;
                                });

                              },

                            ),



                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Start Time:   ${startTime.format(context)}",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              constraints: BoxConstraints(maxHeight: 40),
                              onPressed: () async {
                                await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Start Time",
                                                style: TextStyle(
                                                    fontSize: 28,
                                                    color: Colors.white),
                                              ),
                                              child
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((val) {
                                  setState(() {
                                    if (val != null) {
                                      startTime = val;
                                      endTime = TimeOfDay(
                                          hour: val.hour + 2,
                                          minute: val.minute);
                                    }
                                  });
                                });
                                await showTimePicker(
                                  initialTime: endTime,
                                  context: context,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "End Time",
                                                style: TextStyle(
                                                    fontSize: 28,
                                                    color: Colors.white),
                                              ),
                                              child
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((val) {
                                  setState(() {
                                    if (val != null) {
                                      endTime = TimeOfDay(
                                          hour: val.hour, minute: val.minute);
                                    }
                                  });
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "End Time:   ${endTime.format(context)}",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              constraints: BoxConstraints(maxHeight: 40),
                              onPressed: () async {
                                await showTimePicker(
                                  initialTime: endTime,
                                  context: context,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "End Time",
                                                style: TextStyle(
                                                    fontSize: 28,
                                                    color: Colors.white),
                                              ),
                                              child
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((val) {
                                  setState(() {
                                    if (val != null) {
                                      endTime = val;
                                    }
                                  });
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Amount of subjects in this class: "),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: DropdownButton<int>(
                                underline: Container(),
                                value: classesAmount,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 30,
                                elevation: 16,
                                onChanged: (int newValue) {
                                  setState(() {
                                    classesAmount = newValue;
                                    subjects = new List(classesAmount);
                                  });
                                },
                                items: <int>[
                                  1,
                                  2,
                                  3,
                                ].map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: classesAmount,
                            itemBuilder: (BuildContext context, i) {
                              return Container(
                                  child: Row(
                                    children: [
                                      Text("${i + 1}. Subject: "),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: DropdownButton<String>(
                                              underline: Container(),
                                              value: subjects[i],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              icon: Icon(Icons.arrow_drop_down),
                                              iconSize: 30,
                                              elevation: 16,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  subjects[i] = newValue;
                                                });
                                              },
                                              items: <String>[
                                                "Mindmap",
                                                "IQ",
                                                "Phonics",
                                                "Science"
                                              ].map<DropdownMenuItem<String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value.toString()),
                                                    );
                                                  }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "lib/Assets/teacher.png",
                                      height: 60,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Teacher",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        DropdownButton<String>(
                                          underline: Container(),
                                          value: teacher,
                                          hint: Text("Name"),
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.black),
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              teacher = newValue;
                                            });
                                          },
                                          items: teacherNames
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value.toString()),
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      right: 10,
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Image.asset("lib/Assets/colorwheel.png"),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          if (day != null &&
                              startTime != null &&
                              endTime != null &&
                              subjects[0] != null &&
                              teacher != null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                            child:
                                            CircularProgressIndicator())),
                                  );
                                });

                            String startTimeHour = startTime.hour < 10
                                ? "0${startTime.hour}"
                                : startTime.hour.toString();
                            String startTimeMinute = startTime.minute < 10
                                ? "0${startTime.minute}"
                                : startTime.minute.toString();

                            String endTimeHour = endTime.hour < 10
                                ? "0${endTime.hour}"
                                : endTime.hour.toString();
                            String endTimeMinute = endTime.minute < 10
                                ? "0${endTime.minute}"
                                : endTime.minute.toString();

                            await ClassManagement().storeNewClass(
                                subjects.length == 1
                                    ? '${subjects[0]}'
                                    : subjects.length == 2
                                    ? '${subjects[0]} and ${subjects[1]}'
                                    : subjects.length == 3
                                    ? '${subjects[0]}, ${subjects[1]} and ${subjects[2]}'
                                    : null,
                                classType == "Preschool"
                                    ? "preschoolers"
                                    : classType == "Junior"
                                    ? "junior"
                                    : classType == "Advanced"
                                    ? "advanced"
                                    : null,
                                day,
                                "$startTimeHour:$startTimeMinute",
                                "$endTimeHour:$endTimeMinute",
                                teacher);

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        OwnerHome(user, 0)),
                                    (route) => false);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      content: Text(
                                          "Please fill in missing information"),
                                      actions: [
                                        FlatButton(
                                          child: Text(
                                            "OK",
                                            style:
                                            TextStyle(color: Colors.blue),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ]);
                                });
                          }
                        },
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromRGBO(23, 142, 137, 1),
                          ),
                          child: Center(
                              child: Text(
                                "CREATE EVENT",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    )
                  ],
                ))
          ])
        ]));
  }
}
