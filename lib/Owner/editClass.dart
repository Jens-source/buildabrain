import 'dart:ui';

import 'package:buildabrain/Owner/ownerHome.dart';
import 'package:buildabrain/services/classManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditClass extends StatefulWidget {
  EditClass(this.day, this.teacher, this.startTime, this.endTime, this.user,
      this.classType, this.subject, this.docID);

  final user;

  final teacher;
  final startTime;
  final endTime;
  final day;
  final classType;

  final subject;
  final docID;

  @override
  _EditClassState createState() => _EditClassState(
      this.day,
      this.teacher,
      this.startTime,
      this.endTime,
      this.user,
      this.classType,
      this.subject,
      this.docID);
}

class _EditClassState extends State<EditClass> {
  _EditClassState(this.day, this.teacher, this.startTime, this.endTime,
      this.user, this.classType, this.subject, this.docID);

  final user;

  final docID;

  final subject;

  String teacher;
  List<String> teacherNames;
  String day;
  TimeOfDay startTime;
  TimeOfDay endTime;
  int classesAmount;
  String classType;
  List<String> subjects;

  var sign;

  @override
  void initState() {
    List<String> wordSplit = subject.toString().split(" ");

    subjects = [];

    for (int i = 0; i < wordSplit.length; i++) {
      if (wordSplit[i].contains(",") == true) {
        if (wordSplit[i].replaceAll(RegExp(','), '') == "mindmap") {
          subjects.add("Mindmap");
        }
        if (wordSplit[i].replaceAll(RegExp(','), '') == "IQ") {
          subjects.add("Phonics");
        }
        if (wordSplit[i].replaceAll(RegExp(','), '') == "phonics") {
          subjects.add("IQ");
        }
        if (wordSplit[i].replaceAll(RegExp(','), '') == "science") {
          subjects.add("Science");
        }
      } else if (wordSplit[i].contains("and") == false) {
        if (wordSplit[i] == "mindmap") {
          subjects.add("Mindmap");
        }
        if (wordSplit[i] == "IQ") {
          subjects.add("IQ");
        }
        if (wordSplit[i] == "phonics") {
          subjects.add("Phonics");
        }
        if (wordSplit[i] == "science") {
          subjects.add("Science");
        }
      }
    }

    classesAmount = subjects.length;

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
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
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
          backgroundColor: classType == "preschoolers"
              ? Color.fromRGBO(66, 140, 137, 1)
              : classType == "junior"
                  ? Color.fromRGBO(147, 110, 72, 1)
                  : classType == "advanced"
                      ? Color.fromRGBO(155, 195, 96, 1)
                      : Color.fromRGBO(0, 0, 0, 0),
          leading: Icon(
            Icons.event,
            color: Colors.white,
          ),
          title: Text("Edit this ${day} class"),
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
                          "Class detail",
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              "Day",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            DropdownButton<String>(
                              icon: Icon(Icons.edit),
                              iconSize: 20,
                              underline: Container(),
                              value: day,
                              onChanged: (String newValue) {
                                setState(() {
                                  day = newValue;
                                });
                              },
                              items: <String>[
                                'Monday',
                                'Tuesday',
                                'Wednesday',
                                'Thursday',
                                'Friday',
                                'Saturday',
                                'Sunday'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Class type",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            DropdownButton<String>(
                              icon: Icon(Icons.edit),
                              iconSize: 20,
                              underline: Container(),
                              hint: Text(classType),
                              onChanged: (String newValue) {
                                setState(() {
                                  classType = newValue;
                                });
                              },
                              items: <String>[
                                "Preschool",
                                "Junior",
                                "Advanced"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
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
                                      hint: Text(teacher.toString()),
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
                          List<String> sub = [];

                          for (int i = 0; i < subjects.length; i++) {
                            if (subjects[i] == "Mindmap") {
                              sub.add('mindmap');
                            }
                            if (subjects[i] == "Phonics") {
                              sub.add('phonics');
                            }
                            if (subjects[i] == "IQ") {
                              sub.add('IQ');
                            }
                            if (subjects[i] == "Science") {
                              sub.add('science');
                            }
                          }

                          String startTimeHour = startTime.hour < 10
                              ? "0${startTime.hour}"
                              : startTime.hour.toString();
                          String startTimeMinute = startTime.minute < 10
                              ? "0${startTime.minute}"
                              : startTime.minute.toString();

                          String startFinal = "$startTimeHour:$startTimeMinute";

                          String endTimeHour = endTime.hour < 10
                              ? "0${endTime.hour}"
                              : endTime.hour.toString();
                          String endTimeMinute = endTime.minute < 10
                              ? "0${endTime.minute}"
                              : endTime.minute.toString();

                          String endFinal = "$endTimeHour:$endTimeMinute";

                          await ClassManagement().updateSchedule(
                              day,
                              classType,
                              startFinal,
                              endFinal,
                              subjects.length == 1
                                  ? sub[0]
                                  : subjects.length == 2
                                      ? "${sub[0]} and ${sub[1]}"
                                      : subjects.length == 3
                                          ? "${sub[0]}, ${sub[1]} and  ${sub[2]}"
                                          : null,
                              teacher,
                              docID);
                          setState(() {
                            Navigator.pop(context);
                          });
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
                            "EDIT EVENT",
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
