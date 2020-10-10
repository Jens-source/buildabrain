import 'dart:io';

import 'package:buildabrain/services/userManagement.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../calendar.dart';

class OwnerCalendar extends StatefulWidget {
  OwnerCalendar(this.student);

  final student;

  @override
  _OwnerCalendarState createState() => _OwnerCalendarState(this.student);
}

class _OwnerCalendarState extends State<OwnerCalendar> {
  _OwnerCalendarState(this.student);
  final student;
  List<DocumentSnapshot> schedules;
  List<DocumentSnapshot> mon = [];
  List<DocumentSnapshot> tue = [];
  List<DocumentSnapshot> wed = [];
  List<DocumentSnapshot> thu = [];
  List<DocumentSnapshot> fri = [];
  List<DocumentSnapshot> sat = [];
  List<DocumentSnapshot> sun = [];
  List fin = [];
  List<DocumentSnapshot> students;
  int monStu = 0;
  int tueStu = 0;
  int wedStu = 0;
  int thuStu = 0;
  int friStu = 0;
  int satStu = 0;
  int sunStu = 0;
  List<int> finStu = [];
  bool ok = false;
  int maxStudentsMon = 0;
  int maxStudentsTue = 0;
  int maxStudentsWed = 0;
  int maxStudentsThu = 0;
  int maxStudentsFri = 0;
  int maxStudentsSat = 0;
  int maxStudentsSun = 0;

  List maxStud = [];

  @override
  initState() {
    super.initState();
    print(student);
    Firestore.instance
        .collection('schedule')
        .where('class', isEqualTo: student)
        .getDocuments()
        .then((docs) async {
      for (int i = 0; i < docs.documents.length; i++) {
        if (DateFormat('EEEE')
                .format(DateTime.parse(docs.documents[i].data['startDate'])) ==
            'Monday') {
          mon.add(docs.documents[i]);
          maxStudentsMon =
              maxStudentsMon + docs.documents[i].data['maxStudents'];
          await Firestore.instance
              .collection('schedule')
              .document(docs.documents[i].documentID)
              .collection('students')
              .getDocuments()
              .then((doc) {
            if (doc.documents.length != 0) {
              monStu = monStu + doc.documents.length;
            }
          });
        }
        if (DateFormat('EEEE')
                .format(DateTime.parse(docs.documents[i].data['startDate'])) ==
            'Tuesday') {
          print(docs.documents[i].documentID);
          tue.add(docs.documents[i]);
          maxStudentsTue =
              maxStudentsTue + docs.documents[i].data['maxStudents'];

          await Firestore.instance
              .collection('schedule')
              .document(docs.documents[i].documentID)
              .collection('students')
              .getDocuments()
              .then((doc) {
            if (doc.documents.length != 0) {
              tueStu = tueStu + doc.documents.length;
            }
          });
        }
        if (DateFormat('EEEE')
                .format(DateTime.parse(docs.documents[i].data['startDate'])) ==
            'Wednesday') {
          print(docs.documents[i].documentID);
          wed.add(docs.documents[i]);
          maxStudentsWed =
              maxStudentsWed + docs.documents[i].data['maxStudents'];

          await Firestore.instance
              .collection('schedule')
              .document(docs.documents[i].documentID)
              .collection('students')
              .getDocuments()
              .then((doc) {
            if (doc.documents.length != 0) {
              wedStu = wedStu + doc.documents.length;
            }
          });
        }
        if (DateFormat('EEEE')
                .format(DateTime.parse(docs.documents[i].data['startDate'])) ==
            'Thursday') {
          print(docs.documents[i].documentID);
          thu.add(docs.documents[i]);
          maxStudentsThu =
              maxStudentsThu + docs.documents[i].data['maxStudents'];

          await Firestore.instance
              .collection('schedule')
              .document(docs.documents[i].documentID)
              .collection('students')
              .getDocuments()
              .then((doc) {
            if (doc.documents.length != 0) {
              thuStu = thuStu + doc.documents.length;
            }
          });
        }
        if (DateFormat('EEEE')
                .format(DateTime.parse(docs.documents[i].data['startDate'])) ==
            'Friday') {
          print(docs.documents[i].documentID);
          fri.add(docs.documents[i]);
          maxStudentsFri =
              maxStudentsFri + docs.documents[i].data['maxStudents'];

          await Firestore.instance
              .collection('schedule')
              .document(docs.documents[i].documentID)
              .collection('students')
              .getDocuments()
              .then((doc) {
            if (doc.documents.length != 0) {
              friStu = friStu + doc.documents.length;
            }
          });
        }
        if (DateFormat('EEEE')
                .format(DateTime.parse(docs.documents[i].data['startDate'])) ==
            'Saturday') {
          print(docs.documents[i].documentID);
          sat.add(docs.documents[i]);
          maxStudentsSat =
              maxStudentsSat + docs.documents[i].data['maxStudents'];

          await Firestore.instance
              .collection('schedule')
              .document(docs.documents[i].documentID)
              .collection('students')
              .getDocuments()
              .then((doc) {
            if (doc.documents.length != 0) {
              satStu = satStu + doc.documents.length;
            }
          });
        }
        if (DateFormat('EEEE')
                .format(DateTime.parse(docs.documents[i].data['startDate'])) ==
            'Sunday') {
          print(docs.documents[i].documentID);
          sun.add(docs.documents[i]);
          maxStudentsSun =
              maxStudentsSun + docs.documents[i].data['maxStudents'];

          await Firestore.instance
              .collection('schedule')
              .document(docs.documents[i].documentID)
              .collection('students')
              .getDocuments()
              .then((doc) {
            if (doc.documents.length != 0) {
              sunStu = sunStu + doc.documents.length;
            }
          });
        }
      }
      fin = [mon, tue, wed, thu, fri, sat, sun];
      finStu = [monStu, tueStu, wedStu, thuStu, friStu, satStu, sunStu];

      print(finStu);
      setState(() {
        print("Finished");
        maxStud = [
          maxStudentsMon,
          maxStudentsTue,
          maxStudentsWed,
          maxStudentsThu,
          maxStudentsFri,
          maxStudentsSat,
          maxStudentsSun
        ];
        ok = true;
      });
    });
  }

  List<String> week = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  @override
  Widget build(BuildContext context) {
    if (ok == false) {
      return new Scaffold(
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
    } else
      // TODO: implement build
      return new Scaffold(
          backgroundColor: Color.fromRGBO(200, 244, 255, 1),
          appBar: AppBar(
            title: new Text("Available dates"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return new StudentAv();
                }));
              },
            ),
          ),
          body: new ListView.builder(
              itemCount: 7,
              itemBuilder: (BuildContext context, i) {
                return new GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return new TimeSlots(student, week[i], fin[i]);
                      }));
                    },
                    child: new Container(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [BoxShadow()]),
                          child: new ListTile(
                            leading: Text((i + 1).toString()),
                            title: new Text(week[i]),
                            trailing: Text(
                                "Max: ${maxStud[i]}, Available: ${(maxStud[i] - finStu[i]).toString()}"),
                          ),
                        )));
              }));
  }
}

class StudentAv extends StatefulWidget {
  @override
  _StudentAvState createState() => _StudentAvState();
}

class _StudentAvState extends State<StudentAv> {
  List<String> week = ['preschoolers', 'junior', 'advanced'];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: Color.fromRGBO(200, 244, 255, 1),
        appBar: AppBar(
          title: new Text("Student type"),
        ),
        body: new ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, i) {
              return new GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return OwnerCalendar(week[i]);
                    }));
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: [BoxShadow()]),
                        child: new ListTile(
                          leading: Text((i + 1).toString()),
                          title: new Text(week[i]),
                        ),
                      )));
            }));
  }
}

class TimeSlots extends StatefulWidget {
  TimeSlots(this.student, this.weekDay, this.schedules);

  final schedules;

  final student;
  final weekDay;

  @override
  _TimeSlotsState createState() =>
      _TimeSlotsState(this.student, this.weekDay, this.schedules);
}

class _TimeSlotsState extends State<TimeSlots> {
  _TimeSlotsState(this.student, this.weekDay, this.schedules);

  final schedules;

  final weekDay;

  final student;

  Future<void> deleteEntry(timeStamp) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Remove Entry"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Are you sure you want to remove this entry?'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('REMOVE'),
                  onPressed: () {
                    setState(() {
                      UserManagement.deleteEntry(timeStamp, weekDay);
                      Future.delayed(Duration(milliseconds: 2000)).then((vk) {
                        List doc = [];
                        Firestore.instance
                            .collection('schedule')
                            .where('class', isEqualTo: student)
                            .getDocuments()
                            .then((docs) {
                          for (int i = 0; i < docs.documents.length; i++) {
                            if (DateFormat('EEEE').format(DateTime.parse(
                                    docs.documents[i].data['startDate'])) ==
                                weekDay) {
                              doc.add(docs.documents[i]);
                            }
                          }

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();

                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return TimeSlots(student, weekDay, doc);
                          }));
                        });
                      });
                    });
                  },
                )
              ]);
        });
  }

  Future<void> addEntry(date) async {
    String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (date != null) {
      startDate = DateFormat('yyyy-MM-dd').format(date);
    }
    String endDate = "Not set";
    String clas = 'preschoolers';
    String subject = "mindmap";
    String startTime = DateFormat('Hm').format(DateTime.now());
    String endTime = "Not set";
    List<String> allClasses = new List<String>();
    bool classNumber = false;
    int numberOfClasses = 0;
    bool none = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content:
              StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 500,
                width: 300,
                child: ListView(
                  children: <Widget>[
                    classNumber == false
                        ? ListTile(
                            leading: Text("Class amount"),
                            title: DropdownButton<int>(
                              value: numberOfClasses,
                              elevation: 16,
                              onChanged: (int newValue) {
                                setState(() {
                                  allClasses.clear();
                                  numberOfClasses = newValue;
                                  for (int i = 0; i < numberOfClasses; i++) {
                                    allClasses.add('mindmap');
                                  }
                                });
                              },
                              items: <int>[0, 1, 2, 3]
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ))
                        : Container(),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: numberOfClasses,
                        itemBuilder: (BuildContext context, i) {
                          return new ListTile(
                              leading: Text("Subject"),
                              title: DropdownButton<String>(
                                value: allClasses[i],
                                elevation: 16,
                                onChanged: (String newValue) {
                                  setState(() {
                                    allClasses[i] = newValue;
                                  });
                                },
                                items: <String>[
                                  'mindmap',
                                  'phonics',
                                  'IQ',
                                  'art',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ));
                        }),
                    ListTile(
                      leading: Text("Start date"),
                      title: Text(
                        startDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Future<DateTime> selectedDate = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2030),
                          ).then((val) {
                            setState(() {
                              startDate = DateFormat('yyyy-MM-dd').format(val);
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: Text("End date"),
                      title: Text(
                        endDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Future<DateTime> selectedDate = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2030),
                          ).then((val) {
                            setState(() {
                              endDate = DateFormat('yyyy-MM-dd').format(val);
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: Text("Start time"),
                      title: Text(
                        startTime,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          ).then((val) {
                            setState(() {
                              final now = new DateTime.now();
                              DateTime t = DateTime(now.year, now.month,
                                  now.day, val.hour, val.minute);
                              startTime = DateFormat('Hm').format(t);
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: Text("End time"),
                      title: Text(
                        endTime,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          ).then((val) {
                            setState(() {
                              final now = new DateTime.now();
                              DateTime t = DateTime(now.year, now.month,
                                  now.day, val.hour, val.minute);
                              endTime = DateFormat('Hm').format(t);
                            });
                          });
                        },
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('CANCEL'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                            child: const Text('ADD'),
                            onPressed: () async {
                              MaterialPageRoute(builder: (context) {
                                return Scaffold(
                                  body: new Center(
                                    child: new CircularProgressIndicator(),
                                  ),
                                );
                              });
                            })
                      ],
                    ),
                  ],
                ));
          }));
        });
  }

  List<DocumentSnapshot> teachers = [];

  Future<void> editEntry(entry) async {
    String startDate = entry['startDate'];
    String endDate = entry['endDate'];
    String clas = entry['class'];
    String subject = entry['subject'];
    String startTime = entry['startTime'];
    String endTime = entry['endTime'];
    int classAmount = (entry['maxStudents'] / 6).round();
    List<String> classes = [];

    setState(() {
      classes.clear();
      for (int i = 0; i < classAmount; i++) {
        classes.add('mindmap');
      }
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content:
              StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 500,
                width: 300,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Edit Entry",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: classAmount,
                        itemBuilder: (BuildContext context, i) {
                          return ListTile(
                              leading: Text("Subject"),
                              title: DropdownButton<String>(
                                value: classes[i],
                                elevation: 16,
                                onChanged: (String newValue) {
                                  setState(() {
                                    classes[i] = newValue;
                                  });
                                },
                                items: <String>[
                                  'mindmap',
                                  'phonics',
                                  'IQ',
                                  'art',
                                  'conversation'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ));
                        }),
                    ListTile(leading: Text("Class"), title: Text(student)),
                    ListTile(
                      leading: Text("Start date"),
                      title: Text(
                        startDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Future<DateTime> selectedDate = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2030),
                          ).then((val) {
                            setState(() {
                              startDate = DateFormat('yyyy-MM-dd').format(val);
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: Text("End date"),
                      title: Text(
                        endDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Future<DateTime> selectedDate = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2030),
                          ).then((val) {
                            setState(() {
                              endDate = DateFormat('yyyy-MM-dd').format(val);
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: Text("Start time"),
                      title: Text(
                        startTime,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          ).then((val) {
                            setState(() {
                              final now = new DateTime.now();
                              DateTime t = DateTime(now.year, now.month,
                                  now.day, val.hour, val.minute);
                              startTime = DateFormat('Hm').format(t);
                            });
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: Text("End time"),
                      title: Text(
                        endTime,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          ).then((val) {
                            setState(() {
                              final now = new DateTime.now();
                              DateTime t = DateTime(now.year, now.month,
                                  now.day, val.hour, val.minute);
                              endTime = DateFormat('Hm').format(t);
                            });
                          });
                        },
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('CANCEL'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: const Text('EDIT'),
                          onPressed: () {
                            setState(() {
                              if (classAmount == 1) {
                                UserManagement.updateEntry(
                                    entry['timeStamp'],
                                    student,
                                    endDate,
                                    startDate,
                                    endTime,
                                    startTime,
                                    '${classes[0]}');
                              }

                              if (classAmount == 2) {
                                UserManagement.updateEntry(
                                    entry['timeStamp'],
                                    student,
                                    endDate,
                                    startDate,
                                    endTime,
                                    startTime,
                                    '${classes[0]} and ${classes[1]}');
                              }

                              if (classAmount == 3) {
                                UserManagement.updateEntry(
                                    entry['timeStamp'],
                                    student,
                                    endDate,
                                    startDate,
                                    endTime,
                                    startTime,
                                    '${classes[0]}, ${classes[1]} and ${classes[2]}');
                              }
                            });

                            Future.delayed(Duration(milliseconds: 300))
                                .then((efef) {
                              List doc = [];
                              Firestore.instance
                                  .collection('schedule')
                                  .where('class', isEqualTo: student)
                                  .getDocuments()
                                  .then((docs) {
                                for (int i = 0;
                                    i < docs.documents.length;
                                    i++) {
                                  if (DateFormat('EEEE').format(DateTime.parse(
                                          docs.documents[i]
                                              .data['startDate'])) ==
                                      weekDay) {
                                    doc.add(docs.documents[i]);
                                  }
                                }
                              }).then((dsdfw) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return TimeSlots(student, weekDay, doc);
                                }));
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ));
          }));
        });
  }

  Future<void> existingStudents(sched) async {
    print("Hello");
    List existingStudents = [];

    await Firestore.instance
        .collection('students')
        .where('daysPerWeek', isLessThan: 2)
        .getDocuments()
        .then((docs) {
      print("Hello");

      print(student);

      for (int i = 0; i < docs.documents.length; i++) {
        if (docs.documents[i].data['classType'] == student) {
          setState(() {
            existingStudents.add(docs.documents[i]);
          });
        }
      }
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content:
              StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 500,
                width: 400,
                child: ListView(children: <Widget>[
                  ListTile(
                    title: Text(
                      "Existing Students",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: existingStudents.length,
                      itemBuilder: (BuildContext context, i) {
                        return new ListTile(
                          title: Text(
                              "Name: ${existingStudents[i].data['nickName']}"),
                          subtitle: Text(
                              "Class: ${existingStudents[i].data['classType']}"),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              await Firestore.instance
                                  .collection(
                                      'schedule/${sched.documentID}/students')
                                  .add({
                                'firstName':
                                    existingStudents[i].data['nickName'],
                                'uid': existingStudents[i].documentID
                              });

                              Firestore.instance
                                  .document(
                                      'students/${existingStudents[i].documentID}')
                                  .updateData({
                                'daysPerWeek': 2,
                              });

                              Firestore.instance
                                  .collection(
                                      'students/${existingStudents[i].documentID}/schedules')
                                  .add({
                                'classEndTime': sched.data['endTime'],
                                'classStartTime': sched.data['startTime'],
                                'classDay': weekDay,
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return TimeSlots(student, weekDay, schedules);
                              }));
                            },
                          ),
                        );
                      })
                ]));
          }));
        });
  }

  Future<void> addStudent(sched) async {
    String birthday = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String endDate = "Not set";
    String clas = 'preschoolers';
    String subject = "mindmap";
    String startTime = DateFormat('Hm').format(DateTime.now());
    String endTime = "Not set";
    List<String> allClasses = new List<String>();
    bool classNumber = false;
    int numberOfClasses = 0;
    bool none = false;
    String name;

    bool gender = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          print("Schedule ${sched.documentID}");
          return AlertDialog(
            content:
                StatefulBuilder(// You need this, notice the parameters below:
                    builder: (BuildContext context, StateSetter setState) {
              return Container(
                  height: 200,
                  width: 400,
                  child: ListView(children: <Widget>[
                    ListTile(
                      title: Text(
                        "Add a new Student",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 35,
                      child: ListTile(
                        leading: Text(
                          "Name",
                          style: TextStyle(),
                        ),
                        title: TextField(
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          color: gender == false ? Colors.green : Colors.white,
                          child: Text(
                            "MALE",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          onPressed: () {
                            setState(() {
                              gender = !gender;
                            });
                          },
                        ),
                        FlatButton(
                          color: gender == false ? Colors.white : Colors.green,
                          child: Text(
                            "FEMALE",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          onPressed: () {
                            setState(() {
                              gender = !gender;
                            });
                          },
                        ),
                      ],
                    ),
                  ]));
            }),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "ADD",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            content: Container(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ));
                      });
                },
              ),
              FlatButton(
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  bool ok = false;
  List<bool> selected = [];
  List stu = [];

  List sorted = [];
  bool none = false;

  Future scan() async {
    for (int k = 0; k < sorted.length; k++) {
      print(sorted[k].data['startTime']);
      await Firestore.instance
          .collection('schedule/${sorted[k].documentID}/students')
          .getDocuments()
          .then((doc) {
        print("doc ${doc.documents}");
        if (doc.documents.length != 0) {
          stu.add(doc);
        } else if (doc.documents.length == 0) {
          stu.add(0);
        }
        print("Students ${stu}");
      });
    }
    setState(() {
      none = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      if (schedules.length == 0) {
        none = true;
      }
    });
    for (int i = 0; i < schedules.length; i++) {
      selected.add(false);
      sorted.add(schedules[i]);
    }
    setState(() {
      sorted.sort((a, b) {
        var adate = a['startTime'];
        var bdate = b['startTime'];
        return adate.compareTo(
            bdate); //to get the order other way just switch `adate & bdate`
      });
    });

    setState(() {
      scan();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (none == false) {
      return new Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // TODO: implement build
    return new Scaffold(
        backgroundColor: Color.fromRGBO(0, 148, 142, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 148, 142, 1),
          elevation: 0,
          title: Container(
            padding: EdgeInsets.only(left: 50),
            child: Text("${student} students"),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          OwnerCalendar(student)),
                  (route) => false);
            },
          ),
          actions: <Widget>[
            Container(
                child: Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    addEntry(DateTime.now());
                  },
                ),
                Container(
                    padding: EdgeInsets.only(top: 3),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 20,
                      ),
                      onPressed: () {
                        addEntry(DateTime.now());
                      },
                    ))
              ],
            ))
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Colors.white),
              child: new Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      title: Center(
                        child: Text("${weekDay} timetable"),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ListView(
                            children: <Widget>[
                              new ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: sorted.length,
                                  itemBuilder: (
                                    BuildContext context,
                                    i,
                                  ) {
                                    return new ListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 50,
                                              ),
                                              SizedBox(
                                                  height: 15,
                                                  width: 30,
                                                  child: Container(
                                                      child: Material(
                                                    color: Colors.orange,
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                            left: Radius.zero,
                                                            right:
                                                                Radius.circular(
                                                                    60)),
                                                  ))),
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: Text(
                                                    sorted[i]['startTime'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 150),
                                                  child: Text(
                                                    sorted[i]['endTime'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                  ))
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selected[i] = !selected[i];
                                              });
                                            },
                                            child: AnimatedContainer(
                                                height: selected[i]
                                                    ? stu[i] == 0
                                                        ? 140
                                                        : (stu[i]
                                                                        .documents
                                                                        .length *
                                                                    33 +
                                                                120)
                                                            .toDouble()
                                                    : 80,
                                                curve: Curves.fastOutSlowIn,
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                padding: EdgeInsets.only(
                                                    left: 30, right: 10),
                                                child: !selected[i]
                                                    ? Card(
                                                        color: sorted[i].data[
                                                                    "subject"] ==
                                                                'mindmap'
                                                            ? Color.fromRGBO(
                                                                127,
                                                                231,
                                                                223,
                                                                1)
                                                            : sorted[i].data[
                                                                        "subject"] ==
                                                                    'IQ'
                                                                ? Color.fromRGBO(
                                                                    139,
                                                                    171,
                                                                    234,
                                                                    1)
                                                                : sorted[i].data["subject"] ==
                                                                        'art'
                                                                    ? Color.fromRGBO(
                                                                        255,
                                                                        215,
                                                                        140,
                                                                        1)
                                                                    : Color.fromRGBO(
                                                                        255,
                                                                        190,
                                                                        140,
                                                                        1),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            ListTile(
                                                              title: Text(
                                                                "${sorted[i].data['subject']}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              subtitle: Text(
                                                                  "Students: ${stu[i] == 0 ? 0 : (stu[i].documents.length).toString()}"),
                                                              trailing:
                                                                  Container(
                                                                      width:
                                                                          100,
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.delete),
                                                                            onPressed:
                                                                                () {
                                                                              deleteEntry(sorted[i]['timeStamp']);
                                                                            },
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.edit),
                                                                            onPressed:
                                                                                () {
                                                                              editEntry(sorted[i]);
                                                                            },
                                                                          )
                                                                        ],
                                                                      )),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Card(
                                                        color: sorted[i].data[
                                                                    "subject"] ==
                                                                'mindmap'
                                                            ? Color.fromRGBO(
                                                                127,
                                                                231,
                                                                223,
                                                                1)
                                                            : sorted[i].data[
                                                                        "subject"] ==
                                                                    'IQ'
                                                                ? Color.fromRGBO(
                                                                    139,
                                                                    171,
                                                                    234,
                                                                    1)
                                                                : sorted[i].data["subject"] ==
                                                                        'art'
                                                                    ? Color.fromRGBO(
                                                                        255,
                                                                        215,
                                                                        140,
                                                                        1)
                                                                    : Color.fromRGBO(
                                                                        255,
                                                                        190,
                                                                        140,
                                                                        1),
                                                        child: ListView(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          children: <Widget>[
                                                            ListTile(
                                                              title: Text(
                                                                "${sorted[i].data['subject']}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              trailing:
                                                                  Container(
                                                                      width:
                                                                          100,
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.delete),
                                                                            onPressed:
                                                                                () {
                                                                              deleteEntry(sorted[i]['timeStamp']);
                                                                            },
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.edit),
                                                                            onPressed:
                                                                                () {
                                                                              editEntry(sorted[i]);
                                                                            },
                                                                          )
                                                                        ],
                                                                      )),
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                "Students",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                            ),
                                                            stu[i] != 0
                                                                ? ListView(
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    shrinkWrap:
                                                                        true,
                                                                    children: <
                                                                        Widget>[
                                                                      ListView.builder(
                                                                          scrollDirection: Axis.vertical,
                                                                          shrinkWrap: true,
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          itemCount: stu[i].documents.length,
                                                                          itemBuilder: (BuildContext context, j) {
                                                                            return new SizedBox(
                                                                                height: 30,
                                                                                child: Container(
                                                                                    padding: EdgeInsets.only(left: 15),
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          "${j + 1}",
                                                                                          style: TextStyle(fontSize: 18),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 20,
                                                                                        ),
                                                                                        Text(
                                                                                          stu[i].documents[j].data['firstName'],
                                                                                          style: TextStyle(fontSize: 18),
                                                                                        ),
                                                                                      ],
                                                                                    )));
                                                                          }),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          FlatButton(
                                                                            child:
                                                                                Text("REMOVE"),
                                                                            onPressed:
                                                                                () async {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(content: StatefulBuilder(// You need this, notice the parameters below:
                                                                                        builder: (BuildContext context, StateSetter setState) {
                                                                                      return Container(
                                                                                          height: 500,
                                                                                          width: 300,
                                                                                          child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: <Widget>[
                                                                                            Center(
                                                                                                child: Text(
                                                                                              "Remove Student",
                                                                                              style: TextStyle(fontSize: 20),
                                                                                            )),
                                                                                            ListView.builder(
                                                                                                scrollDirection: Axis.vertical,
                                                                                                shrinkWrap: true,
                                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                                itemCount: stu[i].documents.length,
                                                                                                itemBuilder: (BuildContext context, j) {
                                                                                                  return new ListTile(
                                                                                                      title: Text(stu[i].documents[j].data['firstName']),
                                                                                                      trailing: IconButton(
                                                                                                          icon: Icon(Icons.clear),
                                                                                                          onPressed: () async {
                                                                                                            await Firestore.instance.collection('schedule').where('timeStamp', isEqualTo: sorted[i]['timeStamp']).getDocuments().then((doc) async {
                                                                                                              Firestore.instance.collection('schedule/${doc.documents[0].documentID}/students').getDocuments().then((docs) {
                                                                                                                Firestore.instance.document('schedule/${doc.documents[0].documentID}/students/${docs.documents[0].documentID}').delete();
                                                                                                              });

                                                                                                              await Firestore.instance.document('students/${stu[i].documents[j].data['uid']}').get().then((value) => {
                                                                                                                    Firestore.instance.document('students/${stu[i].documents[j].data['uid']}').updateData({
                                                                                                                      'daysPerWeek': value.data['daysPerWeek'] - 1
                                                                                                                    })
                                                                                                                  });

                                                                                                              await Firestore.instance.collection('students/${stu[i].documents[j].data['uid']}/schedules').where('classDay', isEqualTo: weekDay).getDocuments().then((value) async {
                                                                                                                await Firestore.instance.document('students/${stu[i].documents[j].data['uid']}/schedules/${value.documents[0].documentID}').delete();
                                                                                                              });
                                                                                                            });

                                                                                                            Navigator.of(context).pop();
                                                                                                            Navigator.of(context).pop();
                                                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                                                                              return TimeSlots(student, weekDay, sorted);
                                                                                                            }));
                                                                                                          }));
                                                                                                }),
                                                                                            ListTile(
                                                                                              trailing: FlatButton(
                                                                                                child: Text(
                                                                                                  "CANCEL",
                                                                                                  style: TextStyle(color: Colors.blue),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                              ),
                                                                                            )
                                                                                          ]));
                                                                                    }));
                                                                                  });
                                                                            },
                                                                          ),
                                                                          FlatButton(
                                                                              child: Text(
                                                                                "ADD",
                                                                                style: TextStyle(),
                                                                              ),
                                                                              onPressed: () {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(content: StatefulBuilder(// You need this, notice the parameters below:
                                                                                          builder: (BuildContext context, StateSetter setState) {
                                                                                        return Container(
                                                                                            height: 300,
                                                                                            width: 300,
                                                                                            child: ListView(children: <Widget>[
                                                                                              Center(
                                                                                                child: Text(
                                                                                                  "Add Student",
                                                                                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 80,
                                                                                              ),
                                                                                              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                                                                                Container(
                                                                                                    height: 100,
                                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.blue, boxShadow: [
                                                                                                      BoxShadow(color: Colors.grey, offset: Offset(1, 2)),
                                                                                                    ]),
                                                                                                    child: FlatButton(
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                          existingStudents(sorted[i]);
                                                                                                        },
                                                                                                        child: Text(
                                                                                                          "Existing",
                                                                                                          style: TextStyle(color: Colors.white),
                                                                                                        ))),
                                                                                                SizedBox(width: 15),
                                                                                                Container(
                                                                                                    height: 100,
                                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.blue, boxShadow: [
                                                                                                      BoxShadow(color: Colors.grey, offset: Offset(1, 2)),
                                                                                                    ]),
                                                                                                    child: FlatButton(
                                                                                                        onPressed: () {
                                                                                                          addStudent(sorted[i]);
                                                                                                        },
                                                                                                        child: Text(
                                                                                                          "New",
                                                                                                          style: TextStyle(color: Colors.white),
                                                                                                        ))),
                                                                                              ]),
                                                                                            ]));
                                                                                      }));
                                                                                    });
                                                                              })
                                                                        ],
                                                                      )
                                                                    ],
                                                                  )
                                                                : Container(
                                                                    child: Center(
                                                                        child: IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add),
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(content: StatefulBuilder(// You need this, notice the parameters below:
                                                                                builder: (BuildContext context, StateSetter setState) {
                                                                              return Container(
                                                                                  height: 300,
                                                                                  width: 300,
                                                                                  child: ListView(children: <Widget>[
                                                                                    Center(
                                                                                      child: Text(
                                                                                        "Add Student",
                                                                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 80,
                                                                                    ),
                                                                                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                                                                      Container(
                                                                                          height: 100,
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.blue, boxShadow: [
                                                                                            BoxShadow(color: Colors.grey, offset: Offset(1, 2)),
                                                                                          ]),
                                                                                          child: FlatButton(
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                                existingStudents(sorted[i]);
                                                                                              },
                                                                                              child: Text(
                                                                                                "Existing",
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ))),
                                                                                      SizedBox(
                                                                                        width: 15,
                                                                                      ),
                                                                                      Container(
                                                                                          height: 100,
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.blue, boxShadow: [
                                                                                            BoxShadow(color: Colors.grey, offset: Offset(1, 2)),
                                                                                          ]),
                                                                                          child: FlatButton(
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                                addStudent(sorted[i]);
                                                                                              },
                                                                                              child: Text(
                                                                                                "New",
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ))),
                                                                                    ]),
                                                                                  ]));
                                                                            }));
                                                                          });
                                                                    },
                                                                  )))
                                                          ],
                                                        ),
                                                      )),
                                          ),
                                        ]);
                                  })
                            ],
                          )))
                ],
              ),
            )));
  }
}
