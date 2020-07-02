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

class _ParentCalendarState extends State<ParentCalendar> {

  _ParentCalendarState(this.childrenSnap);

  final childrenSnap;

  CalendarController _calendarController;
  Map<DateTime, List> _events;


  Card _scheduleCard(title, className, weekDay, startTime, endTime,) {
    String _title;
    if (title == "preschoolers") {
      _title = "Preschool";
    }
    return new Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [









        ],
      )


    );
  }

  @override
  initState() {
    super.initState();
    _calendarController = CalendarController();
  }




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

    print(childrenSnap.data.documents.length);

    return Stack(
      children: [

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            ListTile(
              title: Text("YOUR CHILD'S COURSES TODAY"),
            ),


            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0),

                itemCount: childrenSnap.data.documents.length,
                itemBuilder: (BuildContext context, i) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection(
                          'students/${childrenSnap.data.documents[i]
                              .documentID}/schedules').snapshots(),
                      builder: (context, snapshot) {


                        return new Container(
                          padding: EdgeInsets.only(left: 15, right: 15, ),
                          child: Column(

                              children: [
                                Row(
                                  children: [
                                    Text(childrenSnap.data
                                        .documents[i]['firstName'],
                                      style: TextStyle(
                                          fontSize: 20
                                      ),)
                                  ],
                                ),

                                snapshot.hasData ?
                                Row(
                                  children: [
                                    _scheduleCard(
                                      childrenSnap.data.documents[i]['classType'],
                                      childrenSnap.data.documents[i]['classType'],
                                      childrenSnap.data.documents[i]['classType'],
                                      childrenSnap.data.documents[i]['classType'],
                                      childrenSnap.data.documents[i]['classType'],


                                    ),

                                  ],
                                ) : Container()


                              ]
                          ),
                        );
                      }
                  );
                }),

          ],
        ),



        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [



            Container(
              padding: EdgeInsets.only(bottom: 40),
                color: Color.fromRGBO(23, 142, 137, 1),

                child: TableCalendar(
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
                        borderRadius: BorderRadius.all(Radius.circular(10))
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
                )

            ),
      ],

    )
    ]
    );
  }
}
