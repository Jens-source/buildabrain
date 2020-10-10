import 'package:buildabrain/services/userManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffInfo extends StatefulWidget {
  @override
  _StaffInfo createState() => _StaffInfo();
}

class _StaffInfo extends State<StaffInfo> with SingleTickerProviderStateMixin {
  final List<String> log = <String>[];
  List<DateTime> daysDif = new List<DateTime>();
  List dayDoc = [];

  bool sort = false;
  bool ok = false;
  bool counted = false;
  int num;

  List<DocumentSnapshot> teachers = [];
  List<DocumentSnapshot> selectedUsers = [];

  wait() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return new AlertDialog(
              title: Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
        });
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        teachers.sort(
            (a, b) => a.data['displayName'].compareTo(b.data['displayName']));
      } else {
        teachers.sort(
            (a, b) => b.data['displayName'].compareTo(a.data['displayName']));
      }
    }
  }

  onSelectedRow(bool selected, DocumentSnapshot doc) async {
    setState(() {
      if (selected) {
        selectedUsers.add(doc);
      } else {
        selectedUsers.remove(doc);
      }
    });
  }

  deleteSelected() async {
    if (selectedUsers.isNotEmpty) {
      List<DocumentSnapshot> temp = [];
      temp.addAll(selectedUsers);
      for (DocumentSnapshot doc in temp) {
        UserManagement.deleteUser(doc.data['uid']);
      }
    }
  }

  int countMin = 0;
  QuerySnapshot payDates;
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    Firestore.instance
        .collection('users')
        .where('identity', isEqualTo: 'Teacher')
        .getDocuments()
        .then((docs) {
      setState(() {
        teachers = docs.documents;
        ok = true;
      });
    });
  }

  _calling(num) async {
    String url = 'tel:${num}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _moreDetail(startDate, endDate, teacher, dayDocs, totMin) async {
    int hours = totMin ~/ 60;
    int minutes = totMin % 60;

    bool load = false;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;

            return Scaffold(
              appBar: AppBar(
                title: Text("Payroll"),
              ),
              backgroundColor: Color.fromRGBO(240, 240, 240, 1),
              body: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Teacher:",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${teacher.data['firstName']} ${teacher.data['lastName']}",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "School:",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Buildabrain, Sai 2',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Time frame:",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${DateFormat('MMMd').format(DateTime.parse(startDate))} - ${DateFormat('MMMd').format(DateTime.parse(endDate))}',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Total Hours:",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${hours}:${minutes}',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 30,
                          width: 100,
                          child: Center(
                              child: Text(
                            "Start date",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ))),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                          height: 30,
                          width: 90,
                          child: Center(
                              child: Text(
                            "End date",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ))),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Future<DateTime> selectedDate = showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2005),
                              lastDate: DateTime.now(),
                            ).then((val) {
                              setState(() {
                                startDate =
                                    DateFormat('yyyy-MM-dd').format(val);
                              });
                            });
                          },
                          child: Container(
                            height: 35,
                            width: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  startDate,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Future<DateTime> selectedDate = showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.parse(startDate),
                              lastDate: DateTime.now(),
                            ).then((val) {
                              setState(() {
                                endDate = DateFormat('yyyy-MM-dd').format(val);
                              });
                            });
                          },
                          child: Container(
                            height: 35,
                            width: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  endDate,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        load == true;
                        dayDoc.clear();
                        daysDif.clear();
                      });

                      int dif = DateTime.parse(endDate)
                          .difference(DateTime.parse(startDate))
                          .inDays;

                      for (int j = 0; j <= dif; j++) {
                        dayDoc.add(0);
                        daysDif.add(
                            DateTime.parse(startDate).add(Duration(days: j)));
                      }

                      await Firestore.instance
                          .collection('users/${teacher.documentID}/timestamps')
                          .where('date', isGreaterThanOrEqualTo: startDate)
                          .getDocuments()
                          .then((onValue) {
                        int totMin = 0;

                        for (int i = 0; i < daysDif.length; i++) {
                          for (int j = 0; j < onValue.documents.length; j++) {
                            if (daysDif[i] ==
                                DateTime.parse(
                                    onValue.documents[j].data['date'])) {
                              setState(() {
                                dayDoc[i] = onValue.documents[j];
                                totMin = totMin +
                                    onValue.documents[j].data['minutes'];
                              });
                            }
                          }
                        }

                        print(dayDoc);

                        setState(() {
                          Navigator.of(context).pop();
                          _moreDetail(
                              startDate, endDate, teacher, dayDoc, totMin);
                        });
                      });
                    },
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.only(left: 60, right: 60),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Colors.green),
                        child: Center(
                          child: Text(
                            "Calculate",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                              height: 35,
                              width: width / 4,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(220, 220, 220, 1)),
                                  color: Colors.blue),
                              child: Center(
                                  child: Text(
                                "Date",
                                style: TextStyle(color: Colors.white),
                              )))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              height: 35,
                              width: width / 5,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(220, 220, 220, 1)),
                                  color: Colors.blue),
                              child: Center(
                                  child: Text(
                                "In",
                                style: TextStyle(color: Colors.white),
                              )))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              height: 35,
                              width: width / 5,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(220, 220, 220, 1)),
                                  color: Colors.blue),
                              child: Center(
                                  child: Text(
                                "Out",
                                style: TextStyle(color: Colors.white),
                              )))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              height: 35,
                              width: width / 5,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(220, 220, 220, 1)),
                                  color: Colors.blue),
                              child: Center(
                                  child: Text(
                                "Hours",
                                style: TextStyle(color: Colors.white),
                              )))
                        ],
                      ),
                    ],
                  ),
                  load == false
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dayDocs.length,
                          itemBuilder: (BuildContext context, i) {
                            return new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                        height: 35,
                                        width: width / 4,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    220, 220, 220, 1)),
                                            color: i.isOdd
                                                ? Color.fromRGBO(
                                                    245, 245, 245, 1)
                                                : Colors.white),
                                        child: Center(
                                            child: Text(DateFormat('yyyy-MM-dd')
                                                .format(DateTime.parse(
                                                        startDate)
                                                    .add(Duration(days: i))))))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        height: 35,
                                        width: width / 5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    220, 220, 220, 1)),
                                            color: i.isOdd
                                                ? Color.fromRGBO(
                                                    245, 245, 245, 1)
                                                : Colors.white),
                                        child: Center(
                                            child: dayDocs[i] == 0
                                                ? Text("-")
                                                : Text(dayDocs[i]
                                                    .data['time']
                                                    .toString())))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        height: 35,
                                        width: width / 5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    220, 220, 220, 1)),
                                            color: i.isOdd
                                                ? Color.fromRGBO(
                                                    245, 245, 245, 1)
                                                : Colors.white),
                                        child: Center(
                                            child: dayDocs[i] == 0
                                                ? Text("-")
                                                : Text(dayDocs[i]
                                                    .data['timeOut']
                                                    .toString())))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        height: 35,
                                        width: width / 5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    220, 220, 220, 1)),
                                            color: i.isOdd
                                                ? Color.fromRGBO(
                                                    245, 245, 245, 1)
                                                : Colors.white),
                                        child: Center(
                                            child: dayDocs[i] == 0
                                                ? Text("-")
                                                : Text(
                                                    "${(dayDocs[i].data['minutes'] ~/ 60)}: ${dayDocs[i].data['minutes'] % 60 == 0 ? "00" : dayDocs[i].data['minutes'] % 60}")))
                                  ],
                                )
                              ],
                            );
                          })
                      : CircularProgressIndicator()
                ],
              ),
            );
          });
        });
  }

  Future<void> _teacherInfo(teacher) async {
    bool addressMore;
    List fin = [];

    setState(() {
      addressMore = false;
    });

    counted = false;
    countMin = 0;

    String weekday = DateFormat('EEEE').format(DateTime.now());

    if (weekday == 'Monday')
      num = 0;
    else if (weekday == 'Tuesday')
      num = 1;
    else if (weekday == 'Wednesday')
      num = 2;
    else if (weekday == 'Thursday')
      num = 3;
    else if (weekday == 'Friday')
      num = 4;
    else if (weekday == 'Saturday')
      num = 5;
    else if (weekday == 'Sunday') num = 6;

    if (counted == false) {
      wait();
    }

    await Firestore.instance
        .collection('users/${teacher.documentID}/timestamps')
        .where('date',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd')
                .format(DateTime.now().subtract(Duration(days: num))))
        .getDocuments()
        .then((onValue) {
      List dates = [];

      print(num);

      for (int i = num; i >= 0; i--) {
        fin.add(0);

        dates.add(DateFormat('yyy-MM-dd')
            .format(DateTime.now().subtract(Duration(days: i))));
      }

      for (int j = 0; j < dates.length; j++) {
        for (int k = 0; k < onValue.documents.length; k++) {
          if (DateTime.parse(dates[j]) ==
              DateTime.parse(onValue.documents[k].data['date'])) {
            setState(() {
              fin[j] = onValue.documents[k];
            });
          }
        }
      }

      print(fin);

      for (int j = 0; j < onValue.documents.length; j++) {
        setState(() {
          countMin = countMin + onValue.documents[j].data['minutes'];
          counted = true;
        });
      }
    });

    Navigator.of(context).pop();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            int hours = countMin ~/ 60;
            int minutes = countMin % 60;

            String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
            String weekStart = DateFormat('yyyy-MM-dd')
                .format(DateTime.now().subtract(Duration(days: num)));

            return Scaffold(
                backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                appBar: AppBar(
                  title: new Text("Teacher's Info"),
                ),
                body: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(
                        child: Container(
                          height: 120,
                          width: 120,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(teacher.data['photoUrl']),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "${teacher.data['firstName']} ${teacher.data['lastName']}",
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () {
                            _calling(teacher.data['number']);
                          },
                        )
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Card(
                            child: ListTile(
                          title: Text(
                            "About",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(teacher.data['about']),
                        ))),
                    SizedBox(
                      height: 10,
                    ),
                    AnimatedContainer(
                      height: addressMore ? 190 : 60,
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: 1000),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: SingleChildScrollView(
                        child: Card(
                            child: !addressMore
                                ? ListTile(
                                    title: Text(
                                      "Address",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    trailing: IconButton(
                                        icon: AnimatedIcon(
                                          icon: AnimatedIcons.arrow_menu,
                                          progress: controller,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            addressMore = !addressMore;

                                            addressMore
                                                ? controller.reverse()
                                                : controller.forward();
                                          });
                                        }),
                                  )
                                : Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          "Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        trailing: IconButton(
                                            icon: AnimatedIcon(
                                              icon: AnimatedIcons.arrow_menu,
                                              progress: controller,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                addressMore = !addressMore;
                                                addressMore
                                                    ? controller.reverse()
                                                    : controller.forward();
                                              });
                                            }),
                                      ),
                                      SingleChildScrollView(
                                          child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    'Building:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  child: Text(
                                                      teacher['addressLine2']),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    'Street:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  child: Text(
                                                      teacher['addressLine1']),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    'District:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  child:
                                                      Text(teacher['district']),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    'Province:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  child:
                                                      Text(teacher['province']),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    'Zip:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  child: Text(teacher['zip']),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black54,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          "Hours taught",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Center(
                        child: minutes == 0
                            ? Text("${hours} hours")
                            : Text(
                                "${hours} h ${minutes} min",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.blue,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          "${weekStart} to ${today} ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          _moreDetail(weekStart, today, teacher, fin, countMin);
                        },
                        child: Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.blue),
                              child: Center(
                                child: Text(
                                  "More detail",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            )))
                  ],
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (ok == false) {
      return new Scaffold(
          appBar: AppBar(),
          body: Center(
            child: CircularProgressIndicator(),
          ));
    }
    return new Scaffold(
        appBar: AppBar(
          title: Text("Staff information"),
        ),
        body: ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (BuildContext context, i) {
              return new Container(
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.green,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _teacherInfo(teachers[i]);
                    },
                    child: ListTile(
                      leading: Text((i + 1).toString()),
                      title: new Text(teachers[i].data['firstName'].toString()),
                    ),
                  ),
                ),
              );
            }));
  }
}
