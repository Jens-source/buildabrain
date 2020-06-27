import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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



  @override
   initState()  {
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

    return Container(
      padding: EdgeInsets.only(top: height/9),
      child:
           TableCalendar(
            initialCalendarFormat: CalendarFormat.week,
            calendarController: _calendarController,
          )

      );
  }
}
