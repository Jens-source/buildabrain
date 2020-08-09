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

   String weekday;



   DateTime selectedDate;
   List<DocumentSnapshot> selectedDocs;
  String dropdownValue = 'Classes';


  StreamBuilder scheduleList(weekDay, height, String view) {
    if (view == "Classes") {
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('schedule').where(
              'classDay', isEqualTo: weekDay).orderBy(
              'startTime', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }


            else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, i) {
                    DocumentSnapshot schedule = snapshot.data.documents[i];


                    final endTime = DateTime(
                        DateTime
                            .now()
                            .year,
                        DateTime
                            .now()
                            .month,
                        DateTime
                            .now()
                            .day,
                        int.parse(schedule.data['endTime'].toString().substring(
                            0, 2)),
                        int.parse(schedule.data['endTime'].toString().substring(
                            3, 5)));


                    return new

                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 50, right: 20, bottom: 10),
                          margin: EdgeInsets.only(
                              left: 80, right: 0, bottom: 5, top: 10),
                          height: height / 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius
                                  .circular(15), topLeft: Radius.circular(15)),
                              color: Color.fromRGBO(20, 20, 20, 0.15)
                          ),
                          child: ListTile(
                            subtitle: Text(
                              "${weekDay.toString().substring(0,
                                  3)} ${schedule['startTime']} - ${schedule['endTime']}",
                              style: TextStyle(
                                  fontSize: 18
                              ),),
                            title:
                            Container(
                              padding: EdgeInsets.only(bottom: 5, top: 8),
                              child: Text("${ schedule['subject'].split(
                                  " ")[0]} ${schedule['class'] == "preschoolers"
                                  ? "Preschool"
                                  :
                              schedule['class'] == "junior" ? "Junior" :
                              schedule['class'] == "advanced" ? "Advanced" :
                              " "
                              }", style: TextStyle(
                                fontSize: 22,

                              ),),
                            ),
                          ),


                        ),
                        Positioned(
                          left: 50,
                          top: 10,
                          child:
                          Container(
                            margin: EdgeInsets.all(5),
                            height: height / 7,
                            width: height / 7,
                            child: CircleAvatar(
                                backgroundImage:
                                schedule['subject']
                                    .split(' ')
                                    .length == 3 ?
                                schedule['subject'].split(' ')[0] == "IQ"
                                    ? AssetImage("lib/Assets/iq.png")
                                    :
                                schedule['subject'].split(' ')[0] == "mindmap"
                                    ? AssetImage("lib/Assets/mindmap.png")
                                    :
                                schedule['subject'].split(' ')[0] == "phonics"
                                    ? AssetImage("lib/Assets/phonics.png")
                                    :
                                null :
                                schedule['subject'].split(',')[0] == "IQ"
                                    ? AssetImage("lib/Assets/iq.png")
                                    :
                                schedule['subject'].split(',')[0] == "mindmap"
                                    ? AssetImage("lib/Assets/mindmap.png")
                                    :
                                schedule['subject'].split(',')[0] == "phonics"
                                    ? AssetImage("lib/Assets/phonics.png")
                                    :
                                null,


                                backgroundColor:
                                schedule['class'] == "preschoolers" ? Color
                                    .fromRGBO(
                                    53, 172, 167, 1) :
                                schedule['class'] == "junior" ? Color.fromRGBO(
                                    157, 120, 94, 1) :
                                schedule['class'] == "advanced" ? Color
                                    .fromRGBO(
                                    173, 228, 109, 1) :
                                Colors.green

                            ),
                          ),
                        ),


                        i == 0 ? Positioned(
                          top: 45,
                          child:    Container(
                            padding: EdgeInsets.only(left: 22),
                            height: 45,
                            child: VerticalDivider(
                              color: Colors.orangeAccent,

                              thickness: 2,
                            ),
                          ),
                        ) : Positioned(
                          child:    Container(
                            padding: EdgeInsets.only(left: 22),
                            height: 90,
                            child: VerticalDivider(
                              color: Colors.orangeAccent,

                              thickness: 2,
                            ),
                          ),
                        ),


                        Positioned(
                          left: 15,
                          top: 30,

                          child: Column(
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent,
                                      border: DateTime
                                          .now()
                                          .difference(selectedDate)
                                          .inHours < 0 ? null :

                                      selectedDate
                                          .difference(DateTime.now())
                                          .inHours < 0
                                          ? Border.all(
                                          width: 2, color: Colors.orangeAccent)
                                          :
                                      DateTime
                                          .now()
                                          .difference(endTime)
                                          .inMinutes >= 0
                                          ? Border.all(
                                          width: 2, color: Colors.orangeAccent)
                                          :
                                      null


                                  ),


                                  child: DateTime
                                      .now()
                                      .difference(selectedDate)
                                      .inHours < 0 ? Container() :

                                  selectedDate
                                      .difference(DateTime.now())
                                      .inHours < 0 ? Icon(
                                    Icons.check, color: Colors.white,) :
                                  DateTime
                                      .now()
                                      .difference(endTime)
                                      .inMinutes >= 0 ? Icon(
                                    Icons.check, color: Colors.white,) :
                                  Container()

                              ),




                            ],
                          ),
                        )


                      ],
                    );
                  });
            }
          }
      );
    } else {

      var listKeys = _events.keys.toList();
      var listValues = _events.values.toList();


                    return StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {




                        return ListView.builder(
                            itemCount: listKeys.length,
                            itemBuilder: (BuildContext context, i) {


                              if(DateFormat("yyyy-MM-dd").format(listKeys[i]) == DateFormat("yyyy-MM-dd").format(selectedDate)) {

                                if(listValues[i].length == 1) {
                                  return new
                                  Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 20, bottom: 10),
                                        margin: EdgeInsets.only(
                                            left: 80,
                                            right: 0,
                                            bottom: 5,
                                            top: 10),
                                        height: height / 6,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius
                                                    .circular(15),
                                                topLeft: Radius.circular(15)),
                                            color: Color.fromRGBO(
                                                20, 20, 20, 0.15)
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            child: FadeInImage.assetNetwork(


                                              placeholder: 'assets/loading.gif',

                                              image:listValues[i][0].data['photoUrl'], fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          title: Text(listValues[i][0].data['detail']),
                                        ),


                                      ),


                                      Positioned(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          height: 90,
                                          child: VerticalDivider(
                                            color: Colors.orangeAccent,

                                            thickness: 2,
                                          ),
                                        ),
                                      ),


                                    ],
                                  );
                                }else{
                                  return Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                              top: 8, right: 20, bottom: 10),
                                        margin: EdgeInsets.only(
                                            left: 80,
                                            right: 0,
                                            bottom: 5,
                                            top: 10),
                                        height: height / 6,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius
                                                    .circular(15),
                                                topLeft: Radius.circular(15)),
                                            color: Color.fromRGBO(
                                                20, 20, 20, 0.15)
                                        ),
                                        child: ListTile(


                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(100)),

                                            ),

                                            child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25.0),
                              child: FadeInImage.assetNetwork(


                              placeholder: 'assets/loading.gif',

                              image:listValues[i][1] != 0 ? listValues[i][1] : "https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png", fit: BoxFit.cover,
                              ),)
                                            ),
                                          title: Text(listValues[i][0]),
                                        ),


                                      ),


                                      Positioned(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          height: 90,
                                          child: VerticalDivider(
                                            color: Colors.orangeAccent,

                                            thickness: 2,
                                          ),
                                        ),
                                      ),


                                    ],
                                  );
                                }
                              } else{
                                return new Container();
                              }
                            });
                      }
                    );

    }
  }



   void onSelected(DateTime date, List name){

     setState(() {

       selectedDate = date;
       weekday = DateFormat("EEEE").format(date);
     });

   }

   QuerySnapshot students;



  @override
  void initState() {
    weekday = DateFormat("EEEE").format(DateTime.now());
    _calendarController = CalendarController();





    var holidayItems = holidayQuery.documents;
    var grouped = groupBy(holidayItems, (item) => item['date']);
    var map = grouped.map((date, item) => MapEntry(DateTime.parse(date), List.generate(item.length, (int index) => item[index]['name'])));




    var items = promoQuery.documents;
    var promoGrouped = groupBy(items, (item) => item['date']);
    var promoMap = promoGrouped.map((date, item) => MapEntry(DateTime.parse(date),
        List.generate(item.length, (int index) => item[index],
        )));
    _events = promoMap;
    _holidays = map;
    selectedDate = DateTime.now();







    Firestore.instance.collection('students').getDocuments().then((value) {

      for(int i = 0; i < value.documents.length; i++){
        if(value.documents[i].data['birthday'] != 0){
          _events.putIfAbsent(DateTime.parse(value.documents[0].data['birthday']), () => [value.documents[0]]);
        }
      }
    });








    super.initState();
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

                  Text("What would you like to see?", style: TextStyle(
                    fontSize: 18
                  ),),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 30,
                   padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      border: Border.all(width: 3, color: Colors.black54)
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 20,
                      elevation: 16,

                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['Classes', 'Promotions']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )

                  ),

                ],
              ),
            ),
          ),
              
              
              Positioned(
                top: 60,
                child: Container(
                  height: height/2,
                  width: width,
                  child: scheduleList(weekday, height/1.6, dropdownValue),
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
        color: events[0].toString().split(' ').length >= 2 ? Colors.yellow :

        Colors.lightBlueAccent,
      ),
      width: 10.0,
      height: 10.0,

    );
  }
}

