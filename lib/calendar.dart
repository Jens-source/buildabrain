import 'package:buildabrain/services/userManagement.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  Calendar(this.identity);
  final identity;

  @override
  _CalendarState createState() => _CalendarState(this.identity);
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  _CalendarState(this.identity);

  final identity;

  DateTime startDate = DateTime.now().subtract(Duration(days: 20));
  DateTime endDate = DateTime.now().add(Duration(days: 20));
  DateTime selectedDate;
  List<DateTime> markedDates = [
  ];
  List <DocumentSnapshot> schedules = [];
  String formattedMonth;
  String formattedYear;
  int listDays;
  Widget d;
  DateTime start;
  DateTime end;
  bool x = true;
  AnimationController _animationController;
  List dates = [];
  List<bool> selected = new List<bool>();
  List students = [];
  List<DocumentSnapshot> teachers = [];
  List sorted = [];



  @override
  void initState() {
    super.initState();


    var now = new DateTime.now();
    var formatter = new DateFormat('MMM');
    formattedMonth = formatter.format(now);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));


    var formatter2 = new DateFormat('y');
    formattedYear = formatter2.format(now);
    Firestore.instance.collection('schedule')
        .getDocuments()
        .then((docs) {
      for (int i = 0; i < docs.documents.length; i++) {

        setState(() {
          schedules.add(docs.documents[i]);



          for(int j = 0; j <= DateTime.parse(docs.documents[i].data['endDate']).difference(DateTime.parse(docs.documents[i].data['startDate'])).inDays; j++)
          {

            if(DateFormat("EEEE").format(DateTime.parse(schedules[i]['startDate']).add(Duration(days: j))) == DateFormat("EEEE").format(DateTime.parse(docs.documents[i].data['startDate'])))
            {
              setState(() {
                markedDates.add(DateTime.parse(schedules[i]['startDate']).add(Duration(days: j)));
              });

            }
          }

        });
      }
      setState(() {
        print(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now())));
        onSelect(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now())));
      });
    });




  }


  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }


  onSelect(data) async {

    setState(() {

      selectedDate = data;
      dates.clear();
      selected.clear();
    });
    print(schedules.length);

    for (int i = 0; i < schedules.length; i++) {
      if (DateTime.parse(DateFormat('yyyy-MM-dd').format(data)).isAfter(
          DateTime.parse(schedules[i]['startDate'])) ||
          DateTime.parse(DateFormat('yyyy-MM-dd').format(data))
              .isAtSameMomentAs(DateTime.parse(schedules[i]['startDate']))) {
        if (DateTime.parse(DateFormat('yyyy-MM-dd').format(data)).isBefore(
            DateTime.parse(schedules[i]['endDate'])) ||
            DateTime.parse(DateFormat('yyyy-MM-dd').format(data))
                .isAtSameMomentAs(DateTime.parse(schedules[i]['endDate']))) {
          if (DateFormat('EEEE').format(data) == DateFormat('EEEE').format(
              DateTime.parse(schedules[i]['startDate']))) {
            setState(() {

              dates.add(schedules[i]);
              selected.add(false);
              print("Dates: ${dates}");
            });




          }
        }
      }
    }


    setState(() {
      dates.sort((a, b){
        var adate = a['startTime'];
        var bdate = b['startTime'];
        return adate.compareTo(bdate);

      });
    });


    for(int i = 0; i < dates.length; i++){
      await Firestore.instance.document("schedule/${schedules[i].documentID}")
          .collection('students')
          .getDocuments()
          .then((docs) {
        setState(() {
          if (docs.documents.length == 0) {
            setState(() {

              students.add(0);
            });
          }
          else
            setState(() {
              students.add(docs.documents);
            });
        });
      });
    }





  }


  _monthNameWidget(monthName) {
    return Container(
    );
  }

  getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      )
    ]);
  }

  dateTileBuilder(date, selectedDate, rowIndex, dayName, isDateMarked,
      isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle = TextStyle(
        fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  Future<void> selectDate(date) {

    setState(() {
      date = showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        },
      );
      return date;
    });
  }






  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color.fromRGBO(248, 250, 255, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(248, 250, 255, 1),
          title: Row(
            children: <Widget>[
              Text(formattedMonth, style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black

              ),),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(formattedYear, style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black
                ),),
              )

            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.of(context).pop();

            },
          ),
          elevation: 0.0,

          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 20, top: 20),
              child: Text("Today", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo


              ),),
            )
          ],
        ),


        body: new ListView(
          children: <Widget>[
            Container(
                child: CalendarStrip(
                    startDate: startDate,
                    endDate: endDate,
                    onDateSelected: onSelect,
                    dateTileBuilder: dateTileBuilder,
                    iconColor: Colors.black87,
                    monthNameWidget: _monthNameWidget,
                    markedDates: markedDates,
                    containerDecoration: BoxDecoration(color: Colors.white12,)
                )),

            Container(),


            new ListView.builder(

                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount:  dates.length == 0 ? 0 : dates.length,

                itemBuilder: (BuildContext context, i,) {


                  print(dates.length);



                  return new ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,

                      children: <Widget>[

                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),

                            SizedBox(
                                height: 15,
                                width: 30,
                                child:
                                Container(
                                    child:
                                    Material(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.zero,
                                          right: Radius.circular(60)),

                                    )
                                )
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 15),
                                child:
                                Text(dates[i]['startTime'], style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),)
                            ),

                            Container(
                                padding: EdgeInsets.only(left: 150),
                                child: Text(dates[i]['endTime'], style: TextStyle(
                                    fontSize: 16,

                                    color: Colors.grey
                                ),)
                            )

                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected[i] = !selected[i];

                            });
                          },
                          child:
                          AnimatedContainer(
                              height: selected[i] ? students[i] == 0 ? 150 : (100 + (students[i].length * 60)).toDouble() : 100,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(milliseconds: 1000),
                              padding: EdgeInsets.only(left: 30, right: 10),
                              child:
                              !selected[i] ? Card(
                                color: dates[i].data["class"] == 'preschoolers' ? Color.fromRGBO(127, 231, 223, 1)
                                    : dates[i].data["class"] == 'junior' ? Color.fromRGBO(139, 171, 234, 1)
                                    : dates[i].data["class"] == 'advanced' ? Color.fromRGBO(255, 215, 140, 1)
                                    : Color.fromRGBO(255, 190, 140, 1),


                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text("${dates[i].data['subject']}", style: TextStyle(
                                        fontWeight: FontWeight.bold,

                                      ),),
                                      subtitle: Text(dates[i].data['class']),
                                    ),


                                  ],
                                ),
                              ) :
                              Card(
                                color: dates[i].data["class"] == 'preschoolers' ? Color.fromRGBO(127, 231, 223, 1)
                                    : dates[i].data["class"] == 'junior' ? Color.fromRGBO(139, 171, 234, 1)
                                    : dates[i].data["class"] == 'advanced' ? Color.fromRGBO(255, 215, 140, 1)
                                    : Color.fromRGBO(255, 190, 140, 1),

                                child: ListView(

                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text("${dates[i].data['subject']}", style: TextStyle(
                                        fontWeight: FontWeight.bold,

                                      ),),

                                      subtitle: Text(dates[i].data['class']),
                                    ),

                                    Center(
                                      child: Text("Students", style: TextStyle(
                                          fontSize: 18
                                      ),),
                                    ),

                                    students[i] != 0 ?
                                    ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,

                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: students[i].length,
                                        itemBuilder: (BuildContext context, j){

                                          return ListTile(
                                            leading: Text((j+1).toString()),
                                            title: Text( students[i][j].data['firstName'].toString()),
                                          );
                                        })
                                        :
                                    ListTile(
                                      title: Text("No students added to this class, yet. "),
                                    )





                                  ],
                                ),
                              )

                          ),
                        )
                      ]);
                }),
            SizedBox(
              height: 20,
            )

          ],

        )

    );

  }
}



