import 'package:buildabrain/services/userManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';



class StudentInfo extends StatefulWidget {


  @override
  _StudentInfo createState() => _StudentInfo();
}

class _StudentInfo extends State<StudentInfo> {

  List<DocumentSnapshot> preschoolers = [];
  List<DocumentSnapshot> junior = [];
  List<DocumentSnapshot> advanced =[];
  List<DocumentSnapshot> unset;
  List mother = [];
  List father = [];
  List<int> paidPre = [];
  List<int> paidJun = [];
  List<int> paidAdv = [];
  List paidPreDates = [];
  List paidJunDates = [];
  List paidAdvDates = [];
  bool ok = false;


  

    initPreschoolers() async{

    await Firestore.instance.collection('students')
        .where('classType', isEqualTo: 'preschoolers')
        .getDocuments()
        .then((val) async {
          for(int i = 0; i < val.documents.length; i++) {
            print("Student: ${val.documents[i].data['firstName']}");
            preschoolers.add(val.documents[i]);
             await Firestore.instance.collection('students')
            .document(val.documents[i].documentID)
                .collection('timestamps')
                .getDocuments()
                .then((docc){
                  if(docc != null)
                    {
                      setState(() {
                        paidPreDates.add(docc.documents);
                        paidPre.add(docc.documents.length);
                      });

                    }
                  else
                    setState(() {
                      paidPreDates.add(0);
                      paidPre.add(0);
                    });

                  ok = true;

            });

          }
    }).then((col ){
      for(int i = 0; i < preschoolers.length; i++)
      {
        print(preschoolers.length);
        if(preschoolers[i]['motherUid'] != 0)
        {
          Firestore.instance.collection('users')
              .where('uid', isEqualTo: preschoolers[i]['motherUid'])
              .getDocuments()
              .then((docs){
            setState(() {
              mother.add(docs.documents[0]);
            });

          });
        }
        else if(preschoolers[i]['motherUid'] == 0)
        {

          setState(() {
            mother.add(0);
          });
        }


        if(preschoolers[i]['fatherUid'] != 0)
        {
          Firestore.instance.collection('users')
              .where('uid', isEqualTo: preschoolers[i]['fatherUid'])
              .getDocuments()
              .then((docs){
            setState(() {
              father.add(docs.documents[0]);
            });

          });
        }
        else if(preschoolers[i]['fatherUid'] == 0)
        {
          setState(() {
            father.add(0);
          });

        }
      }
    });



  }
  
  initJunior() {
    Firestore.instance.collection('students')
        .where('classType', isEqualTo: 'junior')
        .getDocuments()
        .then((val) {
      junior = val.documents;
      for (int i = 0; i < val.documents.length; i++) {
        Firestore.instance.collection('students')
            .document(val.documents[i].documentID)
            .collection('timestamps')
            .getDocuments()
            .then((docc) {
          paidJunDates = docc.documents;
          if (docc != null) {
            setState(() {
              paidJunDates.add(docc.documents);
              paidJun.add(docc.documents.length);
              print("Paid ${paidJun}");
            });
          }

          else
            setState(() {
              paidJunDates.add(0);
              paidJun.add(0);
              print("Paid ${paidJun}");
            });
        });
      }
    }).then((ergfr) {
      for (int i = 0; i < junior.length; i++) {
        if (junior[i]['motherUid'] != 0) {
          Firestore.instance.collection('users')
              .where('uid', isEqualTo: junior[i]['motherUid'])
              .getDocuments()
              .then((docs) {
            mother.add(docs.documents[0]);
          });
        }
        else if (junior[i]['motherUid'] == 0) {
          mother.add(0);
        }


        if (junior[i]['fatherUid'] != 0) {
          Firestore.instance.collection('users')
              .where('uid', isEqualTo: junior[i]['fatherUid'])
              .getDocuments()
              .then((docs) {
            father.add(docs.documents[0]);
          });
        }
        else if (junior[i]['fatherUid'] == 0) {
          father.add(0);
        }
      }
    });
  }
  
  initAdvanced() {
    Firestore.instance.collection('students')
        .where('classType', isEqualTo: 'advanced')
        .getDocuments()
        .then((val){
      advanced = val.documents;
      for(int i = 0; i < val.documents.length; i++) {
        Firestore.instance.collection('students')
            .document(val.documents[i].documentID)
            .collection('timestamps')
            .getDocuments()
            .then((docc){
          paidAdvDates = docc.documents;
          if(docc != null)
          {
            setState(() {
              paidAdvDates.add(docc.documents);
              paidAdv.add(docc.documents.length);
              print("Paid ${paidAdv}");
            });

          }

          else
            setState(() {
              paidAdvDates.add(0);
              paidAdv.add(0);
              print("Paid ${paidAdv}");
            });


        });

      }
    });

    if(advanced != null)
    for(int i = 0; i < advanced.length; i++)
    {
      if(advanced[i]['motherUid'] != 0)
      {
        Firestore.instance.collection('users')
            .where('uid', isEqualTo: advanced[i]['motherUid'])
            .getDocuments()
            .then((docs){
          mother.add(docs.documents[0]);
        });
      }
      else if(advanced[i]['motherUid'] == 0)
      {
        mother.add(0);
      }


      if(advanced[i]['fatherUid'] != 0)
      {
        Firestore.instance.collection('users')
            .where('uid', isEqualTo: advanced[i]['fatherUid'])
            .getDocuments()
            .then((docs){
          father.add(docs.documents[0]);
        });
      }
      else if(advanced[i]['fatherUid'] == 0)
      {
        father.add(0);
      }
    }
  }



  initUnset() {
    Firestore.instance.collection('students')
        .where('classType', isEqualTo: 0)
        .getDocuments()
        .then((val){

      unset = val.documents;
    }).then((val) {
      for(int i = 0; i < unset.length; i++)
      {
        if(unset[i]['motherUid'] != 0)
        {

          Firestore.instance.collection('users')
              .where('uid', isEqualTo: unset[i]['motherUid'])
              .getDocuments()
              .then((docs){

            mother.add(docs.documents[0]);
          });
        }
        else if(unset[i]['motherUid'] == 0)
        {
          mother.add(0);
        }
        if(unset[i]['fatherUid'] != 0)
        {
          Firestore.instance.collection('users')
              .where('uid', isEqualTo: unset[i]['fatherUid'])
              .getDocuments()
              .then((docs){
            father.add(docs.documents[0]);
          });
        }
        else if(unset[i]['fatherUid'] == 0)
        {
          father.add(0);
        }

      }
    });

  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      initUnset();

    });



    
  }

  @override
  Widget build(BuildContext context) {



    if(ok == false)
    {
      return new Scaffold(
        appBar: AppBar(),
        body:
      Center(child: CircularProgressIndicator(),)
      );
    }
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Unset Students"),
      ),
        backgroundColor: Color.fromRGBO(226, 235, 255, 1),
        body: ListView(
          children: <Widget>[




          ],
        )
    );
  }
}


class Preschoolers extends StatefulWidget {




  @override
  _PreschoolersState createState() => _PreschoolersState();
}

class _PreschoolersState extends State<Preschoolers> {


  List<DocumentSnapshot> children;

  bool ok = false;

  var all = [];
  var newMap;


  List<DocumentSnapshot> preschoolers = [];
  List<DocumentSnapshot> junior = [];
  List<DocumentSnapshot> advanced =[];
  List<DocumentSnapshot> unset;
  List mother = [];
  List father = [];
  List<int> paidPre = [];
  List<int> paidJun = [];
  List<int> paidAdv = [];
  List paidPreDates = [];
  List paidJunDates = [];
  List paidAdvDates = [];






  void initState() {
    super.initState();
    setState(() {
      Firestore.instance.collection('students')
          .where('classType', isEqualTo: 0)
          .getDocuments()
          .then((val){

            print(val);
        unset = val.documents;
      }).then((val) {
        for(int i = 0; i < unset.length; i++)
        {
          if(unset[i]['motherUid'] != 0)
          {

            Firestore.instance.collection('users')
                .where('uid', isEqualTo: unset[i]['motherUid'])
                .getDocuments()
                .then((docs){

              mother.add(docs.documents[0]);
            });
          }
          else if(unset[i]['motherUid'] == 0)
          {
            mother.add(0);
          }
          if(unset[i]['fatherUid'] != 0)
          {
            Firestore.instance.collection('users')
                .where('uid', isEqualTo: unset[i]['fatherUid'])
                .getDocuments()
                .then((docs){
              father.add(docs.documents[0]);
            });
          }
          else if(unset[i]['fatherUid'] == 0)
          {
            father.add(0);
          }



        }

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



  Future<void> studentInfo(student, mother, father, paidDate) async {
    int birthday = DateTime.now().difference(DateTime.parse(student['birthday'])).inDays;
    double month = double.parse((birthday / 365).toStringAsFixed(1));

    String classDay = "Monday";
    String classStartTime = DateFormat('Hm').format(DateTime.now());
    String classEndTime = DateFormat('Hm').format(DateTime.now());
    String classType = 'preschoolers';
    String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());


    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: StatefulBuilder( // You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {


                    print(paidDate);

                    return Container(
                      height: 500,
                      width: 300,
                      child:
                      ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text("${student['firstName'].toString()} ${student['lastName'].toString()}", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                        ),

                        Center(
                          child: Container(
                            height: 70,
                    width: 70,
                    child:

                          CircleAvatar(
                            backgroundImage: NetworkImage(student['photoUrl']),
                          ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.accessibility_new, size: 40,),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(student['gender'])
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.cake, size: 40,),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(DateFormat('yMMMMd').format(DateTime.parse(student['birthday'])))
                              ],
                           ),

                            SizedBox(
                              width: 10,
                            ),


                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.format_color_text, size: 40,),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("${month.toString()} years")

                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),


                        paidDate != null ? Text("Sign In Dates", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),) : Container(),





                        paidDate != 0 ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                          itemCount: paidDate.length,
                            itemBuilder: (BuildContext context, j){

                              String dateTime = DateFormat('yMMMd').format(paidDate[j]["timestamp"].toDate());

                            return new SizedBox(

                              height: 30,

                              child:
                            ListTile(
                              leading: Text((j+1).toString()),
                              title: Text(dateTime, style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                            )
                            );

                            }) : Container(width: 1,),


                        SizedBox(
                          height: 10,
                        ),


                        Text("Parents", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),),

                        mother == 0 ? Container() :
                            ListTile(
                              title: Text("Mother: ${mother['firstName']}"),
                              trailing: IconButton(
                                icon: Icon(Icons.call),
                                onPressed: (){
                                  _calling(mother['number']);
                                },
                              ),
                            ),

                        father == 0 ? Container() :
                        ListTile(
                          title: Text("Father: ${father['firstName']}"),
                          trailing: IconButton(
                            icon: Icon(Icons.call),
                            onPressed: (){
                              setState(() {
                                _calling(father['number']);
                              });

                            },
                          ),
                        ),


                        Text("Class", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),),


                        ListTile(
                          leading: Text("Start date"),
                          title: Text(startDate, style: TextStyle(
                              color: Colors.grey
                          ),),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Future<
                                  DateTime> selectedDate = showDatePicker(

                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2018),
                                lastDate: DateTime(2030),

                              ).then((val) {
                                setState(() {
                                  startDate =
                                      DateFormat('yyyy-MM-dd').format(val);
                                });
                              });
                            },
                          )

                        ),


                        ListTile(
                            leading: Text("Class"),
                            title: DropdownButton<String>(
                              value: classType,

                              elevation: 16,

                              onChanged: (String newValue) {
                                setState(() {
                                  classType = newValue;
                                });
                              },
                              items: <String>[
                                'preschoolers',
                                'junior',
                                'advanced',
                              ]
                                  .map<DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                                  .toList(),
                            )

                        ),


                        ListTile(
                          leading: Text("Start Time"),
                          title:  Text(classStartTime, style: TextStyle(
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
                                  classStartTime = DateFormat('Hm').format(t);

                                });
                              });
                            },
                          )

                        ),


                        ListTile(
                          leading: Text("End Time"),
                          title: Text(classEndTime, style: TextStyle(
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
                                  classEndTime = DateFormat('Hm').format(t);

                                });
                              });
                            },
                          )

                        ),






                        FloatingActionButton.extended(

                          label: Text("Change Class"),
                          onPressed: () {

                            UserManagement.updateStudentClass(student['qrCodeUrl'], classStartTime, classEndTime, classType, startDate, student['nickName'], student['firstName']).then((val){
                              Navigator.of(context).pop();

                            });

                          },
                        )
                      ],
                      )
                    );
                  }
              )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {



    if(ok == false){
      return new Scaffold(
        body: Center(child: CircularProgressIndicator(),));
    }




    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: Text("Student information"),
        ),
        backgroundColor: Color.fromRGBO(226, 235, 255, 1),
        body: ListView(
            children: <Widget>[


              SizedBox(
                height: 50,
              ),
              Center(
                  child: Text("Unset Students", style: TextStyle(
                              fontSize: 30
                          ),)
              ),

              SizedBox(
                  height: 20
              ),

              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ok == false  ? 0 : unset.length,
                  itemBuilder: (BuildContext context, i) {

                    print("father: ${father}");
                    return new

                    Container(
                      padding: EdgeInsets.all(5),
                      child:

                      Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.green



                        ),
                        child:
                        ListTile(
                      leading: Text((i +1).toString()),
                      title: Text(children[i]['firstName']),
                      subtitle: Row(
                        children: <Widget>[
                          all[i]['mother'] == 0 ? Container() :
                              Text("Mother ${all[i]['mother']['firstName'].toString()}"),

                          all[i]['father'] == 0 ? Container() :
                          Text("Father ${all[i]['father']['firstName'].toString()}"),

                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          studentInfo(all[i]['children'],all[i]['mother'], all[i]['father'], all[i]['paidDates']);
                        },
                      ),
                        )
                    )




                    );
                  })
            ]
        )
    );
  }
}




