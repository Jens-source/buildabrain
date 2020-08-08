import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class Schedule extends StatefulWidget {

  Schedule(this.promoQuery, this.holidayQuery);

  final holidayQuery;
  final promoQuery;

  @override
  _ScheduleState createState() => _ScheduleState(this.promoQuery, this.holidayQuery);
}

class _ScheduleState extends State<Schedule> {

  _ScheduleState(this.promoQuery, this.holidayQuery);
  final QuerySnapshot promoQuery;
  final QuerySnapshot holidayQuery;

   CalendarController _calendarController;
   Map<DateTime, List> _events ;
   Map<DateTime, List> _holidays;


   String selectedDate;
   List<DocumentSnapshot> selectedDocs;






   void onSelected(DateTime date, List name){

     print(date);
     print(name);

   }


  @override
  void initState() {
    _calendarController = CalendarController();
    var holidayItems = holidayQuery.documents;
    var grouped = groupBy(holidayItems, (item) => item['date']);
    var map = grouped.map((date, item) => MapEntry(DateTime.parse(date), List.generate(item.length, (int index) => item[index]['name'])));
    var items = promoQuery.documents;
    var promoGrouped = groupBy(items, (item) => item['date']);
    var promoMap = promoGrouped.map((date, item) => MapEntry(DateTime.parse(date), List.generate(item.length, (int index) => item[index]['detail'])));
    print(map);
    _events = promoMap;
    _holidays = map;
    selectedDate = DateFormat("yMMMMd").format(DateTime.now());

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
                        onDaySelected: onSelected,



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

                                    Container(
                                        height: 10,
                                        width: 10,

                                        padding: EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            color: Colors.greenAccent

                                        ),
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
                            color: Colors.white70,
                            fontSize: 20

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
                          outsideDaysVisible: false,

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
        color: Colors.yellow,
      ),
      width: 10.0,
      height: 10.0,

    );
  }

}
