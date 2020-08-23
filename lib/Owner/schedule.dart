import 'package:buildabrain/Owner/editClass.dart';
import 'package:buildabrain/services/classManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class Schedule extends StatefulWidget {
  Schedule(this.user);
  final user;



  @override
  _ScheduleState createState() => _ScheduleState(this.user);
}

class _ScheduleState extends State<Schedule> {

  _ScheduleState(this.user);
  final user;


   CalendarController _calendarController;
   Map<DateTime, List> _events  = {};
   Map<DateTime, List> _holidays = {};
   List<bool> containerAnimation;
   List<bool> promoAnimation;



   String weekday;
   DateTime selectedDate;
   List<DocumentSnapshot> selectedDocs;
  String dropdownValue = 'Classes';


  bool init;
  bool initPromo;




  SingleChildScrollView scheduleList(weekDay, height, String view) {


    if (view == "Classes") {
      return   SingleChildScrollView(
        child:

        Column(
        children: [

          Container(
            child: Text("Classes", style: TextStyle(
              fontSize: 18
            ),),
          ),

          StreamBuilder<QuerySnapshot>(


              stream: Firestore.instance.collection('schedule').where(
                  'classDay', isEqualTo: weekDay).orderBy(
                  'startTime', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (init == false || snapshot.data.documents.length >
                      containerAnimation.length) {
                    containerAnimation =
                    new List(snapshot.data.documents.length);

                    for (int j = 0; j < containerAnimation.length; j++) {
                      containerAnimation[j] = false;
                    }
                  }


                  init = true;


                  return new ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
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
                            int.parse(schedule.data['endTime']
                                .toString()
                                .substring(
                                0, 2)),
                            int.parse(schedule.data['endTime']
                                .toString()
                                .substring(
                                3, 5)));


                        return new

                        Stack(
                          children: [
                            GestureDetector(

                              child:
                              Container(
                                padding: EdgeInsets.only(
                                    left: 30, bottom: 5),
                                margin: EdgeInsets.only(
                                    left: 80, right: 0, bottom: 5, top: 5),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius
                                            .circular(15),
                                        topLeft: Radius.circular(15)),
                                    color: Color.fromRGBO(20, 20, 20, 0.15)
                                ),
                                child: ListTile(

                                  subtitle: Text(
                                    "${weekDay.toString().substring(0,
                                        3)} ${schedule['startTime']} - ${schedule['endTime']}",
                                    style: TextStyle(
                                        fontSize: 14
                                    ),),
                                  title:
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5, top: 8),
                                    child: Text(
                                      "${schedule['subject']}\n${schedule['class'] ==
                                          "preschoolers"
                                          ? "Preschool"
                                          :
                                      schedule['class'] == "junior" ? "Junior" :
                                      schedule['class'] == "advanced"
                                          ? "Advanced"
                                          :
                                      " "
                                      }", style: TextStyle(
                                      fontSize: 16,

                                    ),),
                                  ),
                                ),


                              ),
                            ),

                            GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  containerAnimation[i] =
                                  !containerAnimation[i];
                                });
                              },
                              child:
                              AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: containerAnimation[i] == false
                                    ? 80
                                    : height / 2,
                                padding: EdgeInsets.only(
                                    left: 15,
                                    right: 10,
                                    bottom: 10,
                                    top: height / 5),
                                margin: EdgeInsets.only(
                                    left: 80, right: 0, bottom: 5, top: 5),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius
                                            .circular(15),
                                        topLeft: Radius.circular(15)),
                                    color: Color.fromRGBO(20, 20, 20, 0.05)
                                ),
                                child:
                                SingleChildScrollView(
                                  child:
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Topic:", style: TextStyle(
                                              fontSize: 18
                                          ),),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Walk in the beach",
                                            style: TextStyle(
                                                fontSize: 18
                                            ),),

                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),


                                      StreamBuilder<QuerySnapshot>(
                                          stream: Firestore.instance.collection(
                                              'schedule/${snapshot.data
                                                  .documents[i]
                                                  .documentID}/students')
                                              .snapshots(),
                                          builder: (context, students) {
                                            if (!students.hasData) {
                                              return new Container();
                                            }


                                            return Container(
                                                height: 85,
                                                child: ListView.builder(
                                                    itemCount: 10,
                                                    itemBuilder: (
                                                        BuildContext context,
                                                        k) {
                                                      int f = k + 10;

                                                      return new Container(
                                                          child: Stack(

                                                            children: [

                                                              Positioned(
                                                                child: Container(
                                                                  child: k <=
                                                                      students
                                                                          .data
                                                                          .documents
                                                                          .length -
                                                                          1 ?
                                                                  Text("${k +
                                                                      1} ${students
                                                                      .data
                                                                      .documents[k]
                                                                      .data['firstName']}",
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                    ),) :
                                                                  Text(
                                                                    "${k + 1}",
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                    ),),

                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 120,
                                                                child: Container(
                                                                  child: f <=
                                                                      students
                                                                          .data
                                                                          .documents
                                                                          .length -
                                                                          1 ?
                                                                  Text("${f +
                                                                      1} ${students
                                                                      .data
                                                                      .documents[f]
                                                                      .data['firstName']}",
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                    ),) :
                                                                  Text(
                                                                    "${f + 1}",
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                    ),),

                                                                ),
                                                              )


                                                            ],
                                                          )

                                                      );
                                                    })
                                            );
                                          }
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                                top: 23,
                                right: 16,

                                child:
                                AnimatedContainer(
                                  height: 30,
                                  width: 30,
                                  duration: Duration(milliseconds: 400),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      color: containerAnimation[i] == true
                                          ? Color.fromRGBO(0, 0, 0, 0.2)
                                          :
                                      Color.fromRGBO(0, 0, 0, 0)
                                  ),

                                )
                            ),

                            Positioned(
                              top: 15,
                              right: 18,

                              child:
                              AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(100)),

                                ),

                                child: containerAnimation[i] == true ?  DropdownButton<String>(


                                  underline: Container(),
                                  icon: Icon(Icons.keyboard_arrow_down, size: 25,
                                      color: containerAnimation[i] == true
                                          ? Colors.white
                                          : Color.fromRGBO(0, 0, 0, 0)),


                                  iconDisabledColor: Colors.white,
                                  iconEnabledColor: Colors.white,
                                  elevation: 16,
                                  isExpanded: false,
                                  onChanged: (String newValue) {
                                    if (newValue == "Add Students") {

                                      print("Add Students");

                                    }
                                    if (newValue == "Edit Class") {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) {
                                                return EditClass( schedule['classDay'], schedule['teacher'],
                                                    TimeOfDay.fromDateTime(DateTime(2020, 1, 1,
                                                        int.parse(schedule['startTime'].toString().substring(0, 2)),
                                                        int.parse(schedule['startTime'].toString().substring(3, 5)),
                                                        )),
                                                    TimeOfDay.fromDateTime(DateTime(2020, 1, 1,
                                                      int.parse(schedule['endTime'].toString().substring(0, 2)),
                                                      int.parse(schedule['endTime'].toString().substring(3, 5)),
                                                    )),
                                                  user,
                                                    schedule['class'],
                                                  schedule['subject'],
                                                  schedule.documentID

                                                );
                                              }
                                          )
                                      );


                                    }
                                    if (newValue == "Remove Students") {

                                      showDialog(context: context,
                                          builder: (BuildContext context){
                                            return new

                                            AlertDialog(
                                              title: Text("Removing class"),
                                              content: Text("Are you sure you want to remove this class?"),
                                              actions: [
                                                FlatButton(
                                                  onPressed: (){
                                                    ClassManagement().removeClass(schedule.documentID);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK", style: TextStyle(
                                                      color: Colors.blue
                                                  ),),
                                                ),
                                                FlatButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("CANCEL", style: TextStyle(
                                                      color: Colors.blue
                                                  ),),
                                                )
                                              ],
                                            );
                                          });
                                    }
                                    if (newValue == "Remove Class") {

                                      showDialog(context: context,
                                      builder: (BuildContext context){
                                        return new AlertDialog(
                                          title: Text("Removing class"),
                                          content: Text("Are you sure you want to remove this class?"),
                                          actions: [
                                            FlatButton(
                                              onPressed: (){
                                                ClassManagement().removeClass(schedule.documentID);
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK", style: TextStyle(
                                                color: Colors.blue
                                              ),),
                                            ),
                                            FlatButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },  
                                              child: Text("CANCEL", style: TextStyle(
                                                  color: Colors.blue
                                              ),),
                                            )
                                          ],
                                        );
                                      });
                                    }

                                  },

                                  items: <String>[
                                    'Add Students',
                                    'Remove Students',
                                    'Edit Class',
                                    'Remove Class'
                                  ]
                                      .map<
                                      DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        height: 20,
                                        child: Text(value, style: TextStyle(
                                          fontSize: 14
                                        ),),
                                      ),
                                    );
                                  }).toList(),
                                ) : Container(),


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
                                    schedule['subject'].split(' ')[0] ==
                                        "mindmap"
                                        ? AssetImage("lib/Assets/mindmap.png")
                                        :
                                    schedule['subject'].split(' ')[0] ==
                                        "phonics"
                                        ? AssetImage("lib/Assets/phonics.png")
                                        :
                                    null :
                                    schedule['subject'].split(',')[0] == "IQ"
                                        ? AssetImage("lib/Assets/iq.png")
                                        :
                                    schedule['subject'].split(',')[0] ==
                                        "mindmap"
                                        ? AssetImage("lib/Assets/mindmap.png")
                                        :
                                    schedule['subject'].split(',')[0] ==
                                        "phonics"
                                        ? AssetImage("lib/Assets/phonics.png")
                                        :
                                    null,
                                    backgroundColor:
                                    schedule['class'] == "preschoolers" ? Color
                                        .fromRGBO(
                                        53, 172, 167, 1) :
                                    schedule['class'] == "junior" ? Color
                                        .fromRGBO(
                                        157, 120, 94, 1) :
                                    schedule['class'] == "advanced" ? Color
                                        .fromRGBO(
                                        173, 228, 109, 1) :
                                    Colors.green

                                ),
                              ),
                            ),


                            snapshot.data.documents.length == 1 ?
                            Positioned(
                              top: 45,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                padding: EdgeInsets.only(left: 22),
                                height: containerAnimation[i] == false
                                    ? 0
                                    : height / 2,
                                child: VerticalDivider(
                                  color: Colors.orangeAccent,

                                  thickness: 2,
                                ),
                              ),
                            ) :


                            i == 0 ? Positioned(
                              top: 45,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                padding: EdgeInsets.only(left: 22),
                                height: containerAnimation[i] == false
                                    ? height / 4.5
                                    : height / 2,
                                child: VerticalDivider(
                                  color: Colors.orangeAccent,

                                  thickness: 2,
                                ),
                              ),
                            ) : i == snapshot.data.documents.length - 1
                                ? Positioned(
                              bottom: 45,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                padding: EdgeInsets.only(left: 22),
                                height: containerAnimation[i] == false
                                    ? height / 4.5
                                    : height / 2,
                                child: VerticalDivider(
                                  color: Colors.orangeAccent,

                                  thickness: 2,
                                ),
                              ),
                            )
                                :

                            Positioned(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                padding: EdgeInsets.only(left: 22),
                                height: containerAnimation[i] == false
                                    ? height / 4.5
                                    : height / 1.8,
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
                                              width: 2,
                                              color: Colors.orangeAccent)
                                              :
                                          DateTime
                                              .now()
                                              .difference(endTime)
                                              .inMinutes >= 0
                                              ? Border.all(
                                              width: 2,
                                              color: Colors.orangeAccent)
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
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('promotions').where(
                  'date',
                  isEqualTo: DateFormat("yyyy-MM-dd").format(selectedDate))
                  .snapshots(),
              builder: (context, promotion) {
                if (!promotion.hasData) {
                  return Center(
                    child: Container()
                  );
                }


                else {



                  if(initPromo == false || promotion.data.documents.length > promoAnimation.length) {
                    promoAnimation = new List(promotion.data.documents.length);

                    for(int j = 0; j < promoAnimation.length; j++){


                      promoAnimation[j] = false;


                    }
                  }


                  initPromo = true;


                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),

                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: promotion.data.documents.length,
                      itemBuilder: (BuildContext context, i) {
                        DocumentSnapshot promo = promotion.data.documents[i];

                        return new
                        Column(
                          children: [

                            i == 0 ? Container(
                              child: Text("Promotions", style: TextStyle(
                                  fontSize: 18
                              ),),
                            ) : Container(),


                            Stack(
                              children: [


                        GestureDetector(
                        onTap: (){

                        setState(() {
                        promoAnimation[i] = !promoAnimation[i];
                        });

                        },
                        child:
                            Container(
                              padding: EdgeInsets.only(
                                left: 10, right: 20,),
                              margin: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  bottom: 5,
                                  top: 10),
                              height: height / 6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius
                                        .circular(15),
                                  ),
                                  color: Color.fromRGBO(
                                      20, 20, 20, 0.15)
                              ),
                              child: ListTile(
                                leading: Container(
                                  child: FadeInImage.assetNetwork(


                                    placeholder: 'assets/loading.gif',

                                    image: promo.data['photoUrl'],
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                title: Text(
                                    promo.data['detail']),
                              ),


                            ),
                        ),
                              GestureDetector(
                              onTap: (){

                        setState(() {
                        promoAnimation[i] = !promoAnimation[i];
                        });

                        },
                        child:
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height:  promoAnimation[i] == false ? 70 : height / 2,

                                  padding: EdgeInsets.only(top: 80, left: 15),
                                  margin: EdgeInsets.only(
                                      left: 30, right: 30, bottom: 5, top: 10),

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius
                                          .circular(15)),
                                      color: Color.fromRGBO(20, 20, 20, 0.05)
                                  ),
                                  child:
                                  SingleChildScrollView(
                                    child:



                                           Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Date:", style: TextStyle(
                                                      fontSize: 14
                                                  ),),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    width: 220,
                                                    child: Text("${DateFormat("yMMMd").format(DateTime.parse(promo.data['date']))}  ${promo.data['startTime']} - ${promo.data['endTime']}", style: TextStyle(
                                                        fontSize: 14
                                                    ),),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Host:", style: TextStyle(
                                                      fontSize: 14
                                                  ),),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    width: 220,
                                                    child: Text(promo.data['host'], style: TextStyle(
                                                        fontSize: 14
                                                    ),),
                                                  ),

                                                ],
                                              ),


                                              Row(
                                                children: [
                                                  Text("Description:", style: TextStyle(
                                                      fontSize: 14
                                                  ),),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    width: 220,
                                                    child: Text(promo.data['description'], style: TextStyle(
                                                        fontSize: 14
                                                    ),),
                                                  ),

                                                ],
                                              ),


                                              Row(
                                                children: [
                                                  Text("Detail:", style: TextStyle(
                                                      fontSize: 14
                                                  ),),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    width: 220,
                                                    child: Text(promo.data['detail'], style: TextStyle(
                                                        fontSize: 14
                                                    ),),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Text("Dress Code:", style: TextStyle(
                                                      fontSize: 14
                                                  ),),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    width: 220,
                                                    child: Text(promo.data['dressCode'], style: TextStyle(
                                                        fontSize: 14
                                                    ),),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Text("Material:", style: TextStyle(
                                                      fontSize: 14
                                                  ),),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5),
                                                    width: 220,
                                                    child: Text(promo.data['material'], style: TextStyle(
                                                        fontSize: 14
                                                    ),),
                                                  ),
                                                ],
                                              ),








                                            ],

                                        ),



                                  ),
                                ),
                              ),


                              ]
                            )


                          ],
                        );
                      }
                  );
                }
              }
          ),


          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('holidays').where(
                  'date', isEqualTo: DateFormat("yyyy-MM-dd").format(selectedDate))
                  .snapshots(),
              builder: (context, holidays) {
                if (!holidays.hasData) {
                  return Center(
                    child: Container(),
                  );
                }


                else {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),

                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: holidays.data.documents.length,
                      itemBuilder: (BuildContext context, i) {
                        DocumentSnapshot holiday = holidays.data.documents[i];

                        return new
                        Column(
                          children: [
                            i == 0 ? Container(
                              child: Text("Holidays", style: TextStyle(
                                  fontSize: 18
                              ),),
                            ) : Container(),


                            Container(
                              padding: EdgeInsets.only(
                                left: 10, right: 20,),
                              margin: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  bottom: 5,
                                  top: 10),
                              height: height / 6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius
                                        .circular(15),
                                  ),
                                  color: Colors.greenAccent

                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: EdgeInsets.only(top: 10),

                                    child: Icon(Icons.star, color: Colors.orangeAccent, size: 50,)),

                                title: Text(
                                    holiday.data['name']),
                              ),
                            ),


                          ],
                        );
                      }
                  );
                }
              }
          ),


        ],
        )
      );
    }
  }



   void onSelected(DateTime date, List name){
     setState(() {

       init = false;
       initPromo = false;
       containerAnimation = new List<bool>();
       selectedDate = date;
       weekday = DateFormat("EEEE").format(date);
     });
   }

   QuerySnapshot students;


  @override
  void initState() {
    selectedDate = DateTime.now();
    weekday = DateFormat("EEEE").format(DateTime.now());
    _calendarController = CalendarController();



    initPromo = false;
    init = false;


    Firestore.instance.collection('promotions').getDocuments().then((value) {

        for(int i = 0; i  < value.documents.length; i++){
          setState(() {
          _events.putIfAbsent(DateTime.parse(value.documents[i].data['date']), () => [value]);


        });
        }

    });

    Firestore.instance.collection('holidays').getDocuments().then((value) {

        for(int i = 0; i  < value.documents.length; i++){
          setState(() {
          _holidays.putIfAbsent(DateTime.parse(value.documents[i].data['date']), () => [value]);
          });

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
                top: 20,
                child: Column(
                  children: [

                    Container(
                      height: height/2,
                      width: width,
                      child: scheduleList(weekday, height/1.6, dropdownValue),
                    ),
                  ],
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

