import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';



class ParentCalendar extends StatefulWidget {
  ParentCalendar(this.childrenSnap);
  final childrenSnap;

  @override
  _ParentCalendarState createState() => _ParentCalendarState(this.childrenSnap);
}

class _ParentCalendarState extends State<ParentCalendar> with SingleTickerProviderStateMixin{

  _ParentCalendarState(this.childrenSnap);

  final childrenSnap;
  TabController tabController;
  List<Tab> tabs = [];
  List<Widget> child = [];
  QuerySnapshot childSchedules;
  QuerySnapshot childTimestamps;


  Future getDocs() async{

    for(int i = 0; i < childrenSnap.data.documents.length; i++){


      tabs.add(Tab(child: Text(childrenSnap.data.documents[i].data['nickName'], style: TextStyle(
          fontFamily: 'Balsamiq',
          fontSize: 20
      ),),));


      await Firestore.instance.collection('students/${childrenSnap.data.documents[i].documentID}/schedules').getDocuments().then((value) {
        setState(() {
          childSchedules = value;
        });

      });
      await Firestore.instance.collection('students/${childrenSnap.data.documents[i].documentID}/timestamps').getDocuments().then((volue) {
        setState(() {
          childTimestamps = volue;
        });

      });






      if(childSchedules.documents.length != 0) {
        setState(() {
          child.add(Tab(
              child: Child(childrenSnap.data.documents[i], childSchedules,
                  childTimestamps))
          );
        });

      }

    }

}


  @override
  void initState() {
    setState(() {
      tabs.clear();
    });
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: childrenSnap.data.documents.length, vsync: this);

    setState(() {
      getDocs();
    });

  }




  @override
  Widget build(BuildContext context) {

    if( child.length != tabs.length){
      return new Center(
        child: CircularProgressIndicator(),
      );
    }
    else return
         Container(
           padding: EdgeInsets.only(top: 80),
           child: Column(

            children: [
              TabBar(
                  controller: tabController,
                  labelStyle: TextStyle(fontSize: 14),
                  unselectedLabelColor: Colors.black54,
                  labelColor: Colors.black,
                  indicatorColor: Color.fromRGBO(166, 133, 119, 1),
                  isScrollable: false,
                  tabs: tabs
              ),


              Expanded(
                child: new TabBarView(
                    controller: tabController,
                    children: child

                ),
              )
            ],




    ),
         );
  }
}



class Child extends StatefulWidget {
  Child(this.childrenSnap, this.childSchedules, this.childTimestamps);
  final childrenSnap;
  final childSchedules;
  final childTimestamps;




  @override
  _ChildState createState() => _ChildState(this.childrenSnap, this.childSchedules, this.childTimestamps);
}

class _ChildState extends State<Child> {
  _ChildState(this.childrenSnap, this.childSchedules, this.childTimestamps);

  QuerySnapshot childTimestamps;
  DocumentSnapshot childrenSnap;
  QuerySnapshot childSchedules;


  int count;


  CalendarController _calendarController;
  Map<DateTime, List> _events ;


  Container _scheduleCard(title, className, weekDay, startTime, endTime,) {
    String _title;
    AssetImage assetImage;

    if (title == "preschoolers") {
      _title = "PRESCHOOL";
      assetImage = AssetImage('lib/Assets/preschool.png');

    }
    else if (title == "junior") {
      _title = "JUNIOR";
      assetImage = AssetImage('lib/Assets/junior.png');

    }
    else if (title == "advanced") {
      _title = "ADVANCED";
      assetImage = AssetImage('lib/Assets/advanced.png');

    }



    return new Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color.fromRGBO(153, 107, 55, 1),
      ),

      padding: EdgeInsets.all(15),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.start,


            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: assetImage,
                    backgroundColor: Colors.white38,
                  ),
                  SizedBox(width: 10,),
                  Text(_title, style: TextStyle(
                      color: Colors.white
                  ),
                  ),
                ],
              ),

              SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(className, style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),),

                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(weekDay, style: TextStyle(
                      color: Colors.white
                  ),),
                  SizedBox(
                    width: 5,
                  ),
                  Text(startTime, style: TextStyle(
                      color: Colors.white
                  ),),
                  SizedBox(
                    width: 5,
                  ),
                  Text("-", style: TextStyle(
                      color: Colors.white
                  ),),
                  SizedBox(
                    width: 5,
                  ),
                  Text(startTime, style: TextStyle(
                      color: Colors.white
                  ),),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text("COURSE AMOUNT", style: TextStyle(
                      color: Colors.white
                  ),),
                  SizedBox(
                    width: 10,
                  ),
                  Text("${8 - childTimestamps.documents.length}/8", style: TextStyle(
                      color: Colors.white
                  ),),

                ],
              ),

            ],
          )


    );
  }

  @override
  initState() {
    super.initState();
    _calendarController = CalendarController();
  }


  List<DateTime> availableDates = [];




  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
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

    for(int i = 0; i < 8 - childTimestamps.documents.length; i++){
      
    }



    return Stack(
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),




                         

                           new Container(
                            padding: EdgeInsets.only(left: 10, right: 10 ),
                            child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(childrenSnap['firstName'],
                                        style: TextStyle(
                                            fontSize: 20
                                        ),)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),


                                  childSchedules.documents.length == 1 ? Row(
                                    children: [
                                      _scheduleCard(
                                        childrenSnap['classType'],
                                        childSchedules.documents[0]['className'],
                                        childSchedules.documents[0]['classDay'],
                                        childSchedules.documents[0]['classStartTime'],
                                        childSchedules.documents[0]['classEndTime'],
                                      ),
                                    ],
                                  ) :
                                  childSchedules.documents.length == 2 ? Row(
                                    children: [
                                      _scheduleCard(
                                        childrenSnap['classType'],
                                        childSchedules.documents[0]['className'],
                                        childSchedules.documents[0]['classDay'],
                                        childSchedules.documents[0]['classStartTime'],
                                        childSchedules.documents[0]['classEndTime'],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      _scheduleCard(
                                        childrenSnap['classType'],
                                        childSchedules.documents[1]['className'],
                                        childSchedules.documents[1]['classDay'],
                                        childSchedules.documents[1]['classStartTime'],
                                        childSchedules.documents[1]['classEndTime'],
                                      ),
                                    ],
                                  ) : Container()




                                ]
                            ),
                          )

            ],
          ),



          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [


              Container(
                  padding: EdgeInsets.only(bottom: 40),
                  color: Color.fromRGBO(23, 142, 137, 1),

                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("students/${childrenSnap.documentID}/timestamps").snapshots(),
                    builder: (context, snapshot) {


                      if(snapshot.hasData){
                        for(int i = 0; i < snapshot.data.documents.length; i++){

                        }
                      }


                      return TableCalendar(

                        formatAnimation: FormatAnimation.slide,
                        events: _events,
                        calendarStyle: CalendarStyle(

                          weekdayStyle: TextStyle(
                            color: Colors.white,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.white,

                          ),
                          markersColor: Colors.white,
                          selectedColor: Colors.orange,
                          todayColor: Colors.orangeAccent,
                          canEventMarkersOverflow: false,
                          outsideDaysVisible: false,

                        ),

                        initialCalendarFormat: CalendarFormat.twoWeeks,

                        headerStyle: HeaderStyle(
                            leftChevronIcon: Icon(
                              Icons.chevron_left, color: Colors.white,),
                            rightChevronIcon: Icon(
                              Icons.chevron_right, color: Colors.white,),
                            formatButtonTextStyle: TextStyle(
                                color: Colors.white
                            ),

                            formatButtonDecoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                            centerHeaderTitle: true,
                            titleTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            )
                        ),
                        calendarController: _calendarController,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(color: Colors.white),
                          weekendStyle: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  )

              ),
            ],

          )
        ]
    );

  }
}

