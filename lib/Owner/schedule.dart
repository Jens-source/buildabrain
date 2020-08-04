import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class Schedule extends StatefulWidget {

  Schedule(this.promoQuery);

  final promoQuery;

  @override
  _ScheduleState createState() => _ScheduleState(this.promoQuery);
}

class _ScheduleState extends State<Schedule> {

  _ScheduleState(this.promoQuery);
  final QuerySnapshot promoQuery;

  CalendarController _calendarController;
  Map<DateTime, List> _events = {};
  final Map<DateTime, List> _holidays = {
    DateTime(2020, 7, 28): ["King Vajiralongkorn's Birthday"],
    DateTime(2020, 8, 12): ["Her Majesty the Queen Mother's Birthday"],
    DateTime(2020, 10, 13): ["Passing of His Majesty the Late King"],
    DateTime(2020, 10, 23): ["Chulalongkorn Memorial Day"],
    DateTime(2020, 12, 5): ["His Majesty the Late King's Birthday"],
    DateTime(2020, 12, 7): ["His Majesty the Late King's Birthday Holiday"],
    DateTime(2020, 12, 10): ["Constitution Day"],
    DateTime(2020, 12, 25): ["Christmas Day"],
  };



  List<DateTime> promoDates;











  @override
  void initState() {
    _calendarController = CalendarController();





    for (int i = 0; i < promoQuery.documents.length; i++){

      promoDates.add(DateTime.parse(promoQuery.documents[i].data['date']));
    }


    print(promoDates);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(

      extendBody: true,
      body: Center(
        child: Container(
          child: Stack(


            children: [

          Positioned(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.blue,

                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.add, color: Colors.white,),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Add an event "),
                                  content: Container(
                                    height: 300,
                                    child: Column(
                                      children: [
                                        new TextField(
                                          decoration: InputDecoration(
                                            hintText: "Enter your event",
                                            hintStyle: TextStyle(
                                              fontSize: 20
                                            ),

                                            disabledBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,

                                          ),

                                          onChanged: (value) {
                                            setState(() {

                                            });
                                          },
                                        ),



                                        Container(
                                          child: Text("Choose date"),
                                        ),

                                        Container(
                                          child: Text("${DateFormat("EEEE").format(DateTime.now())}, "
                                              "}, "
                                              ""),
                                        ),



                                      ],
                                    ),
                                  ),

                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                      },
                                      child: Text("ADD", style: TextStyle(
                                          color: Colors.blue
                                      ),),
                                    ),

                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("CANCEL", style: TextStyle(
                                          color: Colors.blue
                                      ),),
                                    ),
                                  ],


                                );
                              });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),


              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 45),
                      color: Color.fromRGBO(23, 142, 137, 1),
                      child: TableCalendar(
                        initialSelectedDay: DateTime.now(),
                        formatAnimation: FormatAnimation.slide,
                        events: _events,
                        holidays: _holidays,


                        builders: CalendarBuilders(
                          markersBuilder: (context, date, events, holidays) {
                            final children = <Widget>[];

                            if (events.isNotEmpty) {
                              children.add(
                                Positioned(
                                  child: _buildEventsMarker(date, events),
                                ),
                              );
                            }
                            if (holidays.isNotEmpty) {
                              children.add((
                                  Center(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            color: Colors.white38

                                        ),
                                      )
                                  )
                              ),
                              );
                            }
                            return children;
                          },
                        ),
                        calendarStyle: CalendarStyle(


                          todayStyle: TextStyle(
                            color: Colors.black
                          ),
                          todayColor: Color.fromRGBO(247,165,0, 1),
                          selectedColor: Color.fromRGBO(196, 89, 0, 1),

                          holidayStyle: TextStyle(

                          ),

                          weekdayStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 20
                          ),
                          weekendStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 20

                          ),
                          markersColor: Colors.white,


                          highlightToday: true,
                          highlightSelected: true,
                          outsideDaysVisible: true,

                        ),

                        initialCalendarFormat: CalendarFormat.twoWeeks,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'weekly',
                          CalendarFormat.twoWeeks: 'monthly ',
                        },

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
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: events.length == 8
            ? Colors.red[500] :
        date.isBefore(DateTime.now())?
        Colors.orange
            : Colors.blue[800],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

}
