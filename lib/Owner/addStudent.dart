import 'package:buildabrain/services/studentManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class AddStudent extends StatefulWidget {
  AddStudent(this.schedule , this.studentNameList);
  final schedule;

  final studentNameList;
  @override
  _AddStudentState createState() => _AddStudentState(this.schedule, this.studentNameList);
}

class _AddStudentState extends State<AddStudent> {
  _AddStudentState(this.schedule, this.studentNameList);
  final DocumentSnapshot schedule;
  final QuerySnapshot studentNameList;


  bool newStudent = false;
  bool gender = false;

  String nickName;


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

    return new Scaffold(

      appBar: AppBar(
        backgroundColor: schedule['class'] == "preschoolers" ?

        Color.fromRGBO(66, 140, 137, 1) :

        schedule['class'] == "junior" ?

        Color.fromRGBO(147, 110, 72, 1) :
        schedule['class'] == "advanced" ?

        Color.fromRGBO(155, 195, 96, 1) :
        Color.fromRGBO(0, 0, 0, 0),

        leading: Icon(Icons.event, color: Colors.white,),
        title: Text("${schedule['classDay']} \t${schedule['startTime']} - ${schedule['endTime']}"),
        actions: [
          FlatButton(
            child: Text("CANCEL", style: TextStyle(
                color: Colors.white70
            ),),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            )
        ),
      ) ,
      body: Container(
        padding: EdgeInsets.all(15),
        child: Stack(

          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 100,
                width: 100,
                child:
            schedule['class'] == "preschoolers" ?

            Image.asset("lib/Assets/preschool.png") :

            schedule['class'] == "junior" ?

            Image.asset("lib/Assets/junior.png") :


            schedule['class'] == "advanced" ?

            Image.asset("lib/Assets/advanced.png") :
            Container(),
              ),
            ),


        ListView(
          children: [
            Text(schedule['class'] == "preschoolers" ?

            "Preschool Student" :

          schedule['class'] == "junior" ?

        "Junior Student" :
        schedule['class'] == "advanced" ?

        "Advanced Student" :
          "Student", style: TextStyle(
              fontSize: 20
            ),),
            SizedBox(
              height: 30,
            ),

            Text("Current students:", style: TextStyle(
                fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            ListView.builder(
              shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: studentNameList.documents.length,
                itemBuilder: (BuildContext context, i){

                  return Container(
                    padding: EdgeInsets.only(top: 7),
                    child: Text("${i+1}. \t${studentNameList.documents[i].data['firstName']}", style: TextStyle(
                      fontSize: 14
                    ),),
                  );

            }),
            SizedBox(
              height: 20,
            ),

         Container(
                height: 35,

                margin: EdgeInsets.only(left: 100, right: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: schedule['class'] == "preschoolers" ?

                  Color.fromRGBO(66, 140, 137, 1) :

                  schedule['class'] == "junior" ?

                  Color.fromRGBO(147, 110, 72, 1) :
                  schedule['class'] == "advanced" ?

                  Color.fromRGBO(155, 195, 96, 1) :
                  Color.fromRGBO(0, 0, 0, 0),

                ),
                child: Center(
                  child: DropdownButton<String>(
                    hint: Text("ADD A STUDENT", style: TextStyle(
                      color: Colors.white
                    ),),
                    underline: Container(),

          
               


                    iconEnabledColor: Colors.white,

                    elevation: 16,
                    onChanged: (String newValue) {
                      if(newValue == "Add new student"){
                        setState(() {
                          newStudent = true;

                        });
                      }
                      if(newValue == "Add from existing"){

                      }

                    },
                    items: <String>['Add new student', 'Add from existing']
                        .map<DropdownMenuItem<String>>((String value) {




                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

            SizedBox(
              height: 15,
            ),

            newStudent == true ? Card(
              color: schedule['class'] == "preschoolers" ?

              Color.fromRGBO(66, 140, 137, 0.1) :

              schedule['class'] == "junior" ?

              Color.fromRGBO(147, 110, 72, 0.1) :
              schedule['class'] == "advanced" ?

              Color.fromRGBO(155, 195, 96, 0.1) :
              Color.fromRGBO(0, 0, 0, 0),

              child: Container(
                padding: EdgeInsets.all(15),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,

                  children: [
                    Row(
                      children: [
                        Text("Student Nickname:"),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: width/2.7,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide()
                              )
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(

                              hintStyle: TextStyle(
                                  fontSize: 16
                              ),

                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder
                                  .none,
                            ),

                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Balsamiq',
                                color: Colors.black54
                            ),
                            onChanged: (value) {
                              setState(() {
                                nickName = value;


                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        Text("Student gender:"),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              gender = true;
                            });
                          },
                          child:
                        Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: gender == false ? Colors.grey : Colors.orangeAccent
                            
                          ),
                          child: Center(child: Text("Male"))
                        ),
                        ),
                        SizedBox(
                          width: 20,
                        ),

                        GestureDetector(
                          onTap: (){
                            setState(() {
                              gender = false;

                            });
                          },
                          child:
                          Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                color: gender == true ? Colors.grey : Colors.orangeAccent

                            ),
                            child: Center(child: Text("Female"))
                        ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    GestureDetector(
                      onTap: () async {
                        if (nickName != null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content: Container(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                );
                              });

                          await StudentManagement().storeNewStudent(
                              nickName,
                              gender == true ? "male" : "female",
                              schedule).then((val) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                        }
                        else{
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Oops!.."),
                                    content: Container(
                                      child:  Text("You forgot to add a name"),


                                    ),
                                  actions: [
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();

                                      },
                                      child: Text("OK", style: TextStyle(
                                        color: Colors.blue),),
                                    )
                                  ],

                                );
                              });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 60, right: 60),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: schedule['class'] == "preschoolers" ?

                          Color.fromRGBO(66, 140, 137, 1) :

                          schedule['class'] == "junior" ?

                          Color.fromRGBO(147, 110, 72, 1) :
                          schedule['class'] == "advanced" ?

                          Color.fromRGBO(155, 195, 96, 1) :
                          Color.fromRGBO(0, 0, 0, 0),

                        ),
                        child: Center(
                          child: Text("Finished", style: TextStyle(
                              color: Colors.white
                          ),),
                        ),
                      ),

                    )

                  ],
                ),
              ),
            ) : Container(),





          ],
        ),
      ]
        ),
      ),
    );
  }
}
