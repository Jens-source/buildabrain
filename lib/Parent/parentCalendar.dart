import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';



class ParentCalendar extends StatefulWidget {
  ParentCalendar(this.childrenSnap, this.child, this.tabController, this.tabs);
  final childrenSnap;
  final child;

  final tabController;
  final tabs;

  @override
  _ParentCalendarState createState() => _ParentCalendarState(this.childrenSnap, this.child,  this.tabController, this.tabs);
}

class _ParentCalendarState extends State<ParentCalendar> with SingleTickerProviderStateMixin{

  _ParentCalendarState(this.childrenSnap, this.child, this.tabController, this.tabs);

  final childrenSnap;
  TabController tabController;
  final tabs ;
  final child ;












  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: childrenSnap.documents.length, vsync: this);

  }


  @override
  Widget build(BuildContext context) {




     return
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
  List <DateTime> availableDates = [];


  int count;
  int initialCount = 0;


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
                Text(endTime, style: TextStyle(
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
                Text(
                  "${8 - childTimestamps.documents.length}/8", style: TextStyle(
                    color: Colors.white
                ),),

              ],
            ),

          ],
        )


    );
  }

  DateTime now = DateTime.now();

  Paint paint = Paint();


  @override
  initState() {
    super.initState();
    paint.color = Colors.white38;
    paint.strokeWidth = 10;
    paint.style = PaintingStyle.fill;

    _calendarController = CalendarController();
    availableDates.clear();
    count = 8 - childTimestamps.documents.length;
    int listLength = childTimestamps.documents.length + 1;


    List<String> previousTimestamps = [];
    bool search = false;











    for(int i = 0; i  < childTimestamps.documents.length; i++){
      _events[DateTime.parse(childTimestamps.documents[i].data['date'])] = new List(i + 1);
      previousTimestamps.add(childTimestamps.documents[i].data['date']);
    }


    previousTimestamps.sort((a, b){
      return a.compareTo(b);
    });

    print(previousTimestamps.last);
    DateTime lastDay = DateTime.parse(previousTimestamps.last);
    int missedDates = 0;



    while(search == false) {
      if (childSchedules.documents.length == 1) {
        if (DateFormat("yyy-MM-dd").format(lastDay) ==
            DateFormat("yyyy-MM-dd").format(DateTime.now())) {
          search = true;
        }

        else {
          lastDay = lastDay.add(Duration(days: 1));
          if (DateFormat("EEEE").format(lastDay) ==
              childSchedules.documents[0].data['classDay'].toString()) {
            missedDates++;
          }
        }
      }
      if (childSchedules.documents.length == 2) {
        if (DateFormat("yyy-MM-dd").format(lastDay) ==
            DateFormat("yyyy-MM-dd").format(DateTime.now())) {
          search = true;
        }

        else {
          lastDay = lastDay.add(Duration(days: 1));
          if (DateFormat("EEEE").format(lastDay) ==
              childSchedules.documents[0].data['classDay'].toString() || DateFormat("EEEE").format(lastDay) ==childSchedules.documents[1].data['classDay'].toString()) {
            missedDates++;
          }
        }
      }
    }

    print(missedDates);


    count = count - missedDates;
    listLength = listLength + missedDates;














      while(count > 0 ){
        if(childSchedules.documents.length == 2){

          if(DateFormat("EEEE").format(now) ==  childSchedules.documents[0].data['classDay'] ||
              DateFormat("EEEE").format(now) == childSchedules.documents[1].data['classDay']
          ){
            setState(() {
              _events[now] = List(listLength);
              now =  now.add(Duration(days: 1));


              listLength=  listLength + 1;

            });
            count--;
          }
          else{
            now =  now.add(Duration(days: 1));

          }
        }
        if(childSchedules.documents.length == 1){
          if(DateFormat("EEEE").format(now).toString() == childSchedules.documents[0].data['classDay'].toString()){
            setState(() {
              _events[now] = new List(listLength);
              now =  now.add(Duration(days: 1));
              listLength=  listLength + 1;
            });
            count--;
          }
          else{

            now =  now.add(Duration(days: 1));

          }
        }
      }

      print(_events);

    }


  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    availableDates.clear();
    return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),


              new Container(
                padding: EdgeInsets.only(left: 10, right: 10),
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

                  child: TableCalendar(
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
                          children.add(
                            Positioned(
                              right: -2,
                              top: -2,
                              child: _buildHolidaysMarker(),
                            ),
                          );
                        }



                        return children;
                      },
                    ),
                    calendarStyle: CalendarStyle(

                      holidayStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
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


                      highlightToday: false,
                      highlightSelected: false,
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
              )


            ],

          )
        ]
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
  Widget _buildHolidaysMarker() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        color: Colors.white
      ),
    );

      Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }
}

