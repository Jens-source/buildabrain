import 'dart:async';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
with TickerProviderStateMixin {

  List<Widget> todayCards = new List(1);
  int _current = 0;
  TabController tabController;
  int initialDateIndex = 0;
  String weekDay;

  TabController _tabController;
  int tab = 0;


  StreamBuilder scheduleList(weekDay, height) {
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
                  return new Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    margin: EdgeInsets.only(
                        left: 20, right: 20, bottom: 5, top: 10),
                    height: height / 6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color.fromRGBO(20, 20, 20, 0.15)
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${schedule['startTime']} \n   -\n${schedule['endTime']}",
                              style: TextStyle(
                                  fontSize: 18
                              ),)
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),

                        VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                        ),


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
                              schedule['class'] == "advanced" ? Color.fromRGBO(
                                  173, 228, 109, 1) :
                              Colors.green

                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${ schedule['subject'].split(
                                " ")[0]}\n${schedule['class'] == "preschoolers"
                                ? "Preschool"
                                :
                            schedule['class'] == "junior" ? "Junior" :
                            schedule['class'] == "advanced" ? "Advanced" :
                            " "
                            }", style: TextStyle(
                              fontSize: 22,

                            ),),

                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text("Students ${schedule['studentAmount']
                                  .toString()}", style: TextStyle(
                                  fontSize: 18
                              ),),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                });
          }
        }
    );
  }


  Future <String> wd(num) {
    switch (num) {
      case 0 :
        {
          weekDay = "Monday";
        }
        break;
      case 1 :
        {
          weekDay = "Tuesday";
        }
        break;
      case 2 :
        {
          weekDay = "Wednesday";
        }
        break;
      case 3 :
        {
          weekDay = "Thursday";
        }
        break;
      case 4 :
        {
          weekDay = "Friday";
        }
        break;
      case 5 :
        {
          weekDay = "Saturday";
        }
        break;
      case 6 :
        {
          weekDay = "Sunday";
        }
        break;
    }
  }

  QuerySnapshot schedules;
  int initialPlaceholder = 0;
  String cool;


  Future <StreamBuilder> queryList(Stream<QuerySnapshot> studentList) async {
    return new StreamBuilder(
        stream: studentList,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("0");
          }
          return new Text("${snapshot.data.documents.length}");
        }
    );
  }


  Future initSign(height, width,) async {
    List<int> signedIn;
    await Firestore.instance.collection('schedule').where(
        'classDay', isEqualTo: DateFormat("EEEE").format(DateTime.now()))
        .orderBy("startTime", descending: false)
        .getDocuments()
        .then((value) async {
      signedIn = new List(value.documents.length);
      todayCards = List(value.documents.length);


      for (int i = 0; i < value.documents.length; i++) {
        signedIn[i] = 0;
        var format = DateFormat("HH:mm");
        var one = format.parse(DateFormat("HH:mm").format(DateTime.now()));
        var two = format.parse(value.documents[i].data['endTime']);


        if (two.difference(one)
            .inMinutes < 0 &&
            initialPlaceholder != value.documents.length - 1) {
          initialPlaceholder = initialPlaceholder + 1;


          QuerySnapshot studentSnapshot = await Firestore.instance.collection(
              'schedule/${value.documents[i].documentID}/students')
              .getDocuments();

          List <int> finals = new List(studentSnapshot.documents.length);

          print(studentSnapshot.documents.length);


          for (int k = 0; k < studentSnapshot.documents.length; k++) {
            finals[k] = 0;
          }


          await Firestore.instance.collection(
              'students/${studentSnapshot.documents[i].data['uid']}/timestamps')
              .where('date',
              isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
              .snapshots().listen((event) {
            finals[i] = event.documents.length;
            for (int j = 0; j < finals.length; j++) {
              setState(() {
                signedIn[initialPlaceholder] =
                    signedIn[initialPlaceholder] + finals[j];
              });
              print("Signed ${signedIn}");
            }
          });
        }


        todayCards[i] =
            Container(
                padding: EdgeInsets.only(top: width / 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromRGBO(153, 107, 55, 1),
                ),


                child: Stack(
                  children: [


                    Column(
                      children: [
                        Row(
                          children: [

                            SizedBox(
                              width: width / 20,
                            ),
                            Container(
                              height: width / 4,
                              width: width / 4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(100)),
                                  color: Colors.white30
                              ),
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  height: height / 7,
                                  width: height / 7,
                                  child: CircleAvatar(
                                      backgroundImage:
                                      value.documents[i]['subject']
                                          .toString()
                                          .split(' ')
                                          .length == 3 ?
                                      value.documents[i]['subject']
                                          .toString()
                                          .split(' ')[0] == "IQ" ? AssetImage(
                                          "lib/Assets/iq.png") :
                                      value.documents[i]['subject']
                                          .toString()
                                          .split(' ')[0] == "mindmap"
                                          ? AssetImage("lib/Assets/mindmap.png")
                                          :
                                      value.documents[i]['subject']
                                          .toString()
                                          .split(' ')[0] == "phonics"
                                          ? AssetImage("lib/Assets/phonics.png")
                                          :
                                      null :
                                      value.documents[i]['subject']
                                          .toString()
                                          .split(',')[0] == "IQ" ? AssetImage(
                                          "lib/Assets/iq.png") :
                                      value.documents[i]['subject']
                                          .toString()
                                          .split(',')[0] == "mindmap"
                                          ? AssetImage("lib/Assets/mindmap.png")
                                          :
                                      value.documents[i]['subject']
                                          .toString()
                                          .split(',')[0] == "phonics"
                                          ? AssetImage("lib/Assets/phonics.png")
                                          :
                                      null,


                                      backgroundColor:
                                      value.documents[i]['class'] ==
                                          "preschoolers" ? Color.fromRGBO(
                                          53, 172, 167, 1) :
                                      value.documents[i]['class'] == "junior"
                                          ? Color.fromRGBO(
                                          157, 120, 94, 1)
                                          :
                                      value.documents[i]['class'] == "advanced"
                                          ? Color.fromRGBO(
                                          173, 228, 109, 1)
                                          :
                                      Colors.green

                                  ),
                                ),
                              ),

                            ),

                            SizedBox(
                              width: 20,
                            ),


                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Container(
                                  child: Text(
                                    "${value.documents[i].data['classDay']
                                        .toString()
                                        .substring(0, 3)}"
                                        " ${value.documents[i].data['startTime']
                                        .toString()} -"
                                        " ${value.documents[i].data['endTime']
                                        .toString()}",

                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17
                                    ),),


//                                          child: Text("Mon 09:00-10:00 AM",
//                                            style: TextStyle(
//                                                color: Colors.white,
//                                                fontSize: 17
//                                            ),),

                                ),
                                Container(
                                  child: Text(
                                    "${ value.documents[i]['subject'].split(
                                        " ")[0]} ${value
                                        .documents[i]['class'] == "preschoolers"
                                        ? "Preschool"
                                        :
                                    value.documents[i]['class'] == "junior"
                                        ? "Junior"
                                        :
                                    value.documents[i]['class'] == "advanced"
                                        ? "Advanced"
                                        :
                                    " "
                                    }", style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white

                                  ),),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Teacher", style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25
                                      ),),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),

                                    Container(
                                      child: Text(
                                        "Jens", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25
                                      ),),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Text(
                                    "Assistant Bee", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),),
                                ),


                              ],
                            )

                          ],
                        ),

                        SizedBox(
                          height: 15,
                        ),


                      ],
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, left: 25),
                        height: height / 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15)),
                          color: Color.fromRGBO(243, 197, 145, 1),
                        ),


                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start,
                              children: [
                                Container(
                                  child: Text("Students in class",
                                    style: TextStyle(
                                        fontSize: 20
                                    ),),
                                ),
                                SizedBox(
                                  width: 80,
                                ),
                                Container(
                                  child: Text("8", style: TextStyle(
                                      fontSize: 20
                                  ),),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start,
                              children: [
                                Container(
                                  child: Text(
                                    "Checked in", style: TextStyle(
                                      fontSize: 20
                                  ),),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      color: Colors.white
                                  ),
                                  child: Center(
                                    child: Text(signedIn[i].toString(),
                                        style: TextStyle(
                                            fontSize: 20
                                        )

                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  child: Text(
                                    "Absent", style: TextStyle(
                                      fontSize: 20
                                  ),),
                                ),
                                SizedBox(
                                  width: 20,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      color: Colors.white
                                  ),
                                  child: Center(
                                    child: Text("2", style: TextStyle(
                                        fontSize: 20
                                    ),),
                                  ),
                                ),


                              ],
                            ),
                          ],
                        ),


                      ),
                    )

                  ],
                )


            );
      }
    });
  }

  @override
  void initState() {
    initialDateIndex = DateTime
        .now()
        .weekday - 1;
    _tabController = new TabController(length: 5, vsync: this);

    tab = _tabController.index;

    tabController =
    new TabController(length: 7, vsync: this, initialIndex: initialDateIndex);
    wd(tabController.index);
    tabController.addListener(controllerListener);


    super.initState();
  }

  void controllerListener() {
    setState(() {
      wd(tabController.index);
    });
  }


  @override
  void dispose() {
    tabController.dispose();
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


    if (todayCards[0] == null) {
      setState(() {
        initSign(height, width);
      });


      return new Center(
        child: new CircularProgressIndicator(),
      );
    }

    return
      Scaffold(

          bottomNavigationBar: new Material(
            color: Color.fromRGBO(153, 107, 55, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            child: TabBar(
              onTap: (value) {
                setState(() {
                  tab = _tabController.index;
                });
              },
              unselectedLabelColor: Colors.white70,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              controller: _tabController,
              tabs: <Widget>[

                new Tab(child: Container(
                  padding: EdgeInsets.only(top: 4, bottom: 3),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/Assets/home.png", height: 25,
                        color: tab == 0 ? Colors.white : Colors.white70,),
                      Text("HOME", style: TextStyle(fontSize: 7),)
                    ],),),),
                new Tab(child: Container(
                  padding: EdgeInsets.only(top: 4, bottom: 3),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/Assets/schedule.png", height: 25,
                          color: tab == 1 ? Colors.white : Colors.white70),
                      Text("SCHEDULE", style: TextStyle(fontSize: 7),)
                    ],),),),
                new Tab(child: Container(
                  padding: EdgeInsets.only(top: 4, bottom: 3),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/Assets/qrcode.png", height: 30,
                          color: tab == 2 ? Colors.white : Colors.white70),
                      Text("SCAN", style: TextStyle(fontSize: 7),)
                    ],),),),
                new Tab(child: Container(
                  padding: EdgeInsets.only(top: 4, bottom: 3),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/Assets/notify.png", height: 30,
                          color: tab == 3 ? Colors.white : Colors.white70),
                      Text("CHAT", style: TextStyle(fontSize: 7),)
                    ],),),),
                new Tab(child: Container(
                  padding: EdgeInsets.only(top: 4, bottom: 3),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/Assets/settings.png", height: 25,
                          color: tab == 4 ? Colors.white : Colors.white70),
                      Text("SETTINGS", style: TextStyle(fontSize: 7),)
                    ],),),),
              ],
            ),
          ),

          body:

          TabBarView(
            controller: _tabController,
            children: [


              Container(
                padding: EdgeInsets.only(top: 15,),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    CarouselSlider(
                        items: todayCards,
                        options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: initialPlaceholder,
                          enableInfiniteScroll: false,

                          autoPlay: false,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        )
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [

                        Container(
                          height: 47.5,
                          width: ((width - 30) * (initialDateIndex + 1) / 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color.fromRGBO(23, 142, 137, 1),
                          ),
                        ),

                        Container(
                          width: width - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.black26,
                          ),

                          child: TabBar(
                            controller: tabController,
                            labelPadding: EdgeInsets.only(left: 1, right: 1),

                            indicator: CustomTabIndicator(),
                            labelStyle: TextStyle(
                                fontSize: 18
                            ),
                            tabs: [
                              Container(
                                child: Tab(
                                  text: "Mon",
                                ),
                              ),
                              Tab(
                                text: "Tue",
                              ),
                              Tab(
                                text: "Wed",
                              ),
                              Tab(
                                text: "Thu",
                              ),
                              Tab(
                                text: "Fri",
                              ),
                              Tab(
                                text: "Sat",
                              ),
                              Tab(
                                text: "Sun",
                              ),


                            ],
                          ),
                        ),


                      ],
                    ),


                    SizedBox(
                      height: 15,
                    ),


                    Container(
                        height: height / 3.1,
                        width: width,

                        child: TabBarView(
                          controller: tabController,

                          children: [
                            scheduleList(weekDay, height),
                            scheduleList(weekDay, height),
                            scheduleList(weekDay, height),
                            scheduleList(weekDay, height),
                            scheduleList(weekDay, height),
                            scheduleList(weekDay, height),
                            scheduleList(weekDay, height)
                          ],
                        )
                    )


                  ],
                ),
              ),
              Container(),
              Container(),
              Container(),
              Container(),
            ],
          )

      );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) {
    return new _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final Rect rect = offset & configuration.size;
    final Paint paint = Paint();
    paint.color = Colors.orangeAccent;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(15.0)), paint);
  }

}