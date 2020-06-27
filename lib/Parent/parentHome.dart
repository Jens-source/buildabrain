


import 'package:buildabrain/Parent/parentCalendar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../calendar.dart';


class ParentHome extends StatefulWidget {
  @override
  _ParentHomeState createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> with
SingleTickerProviderStateMixin {


  List<Widget> photoUrlList = [];
  List<String> descriptionList = [];
  FirebaseUser user;
  int tab;
  String timeOfDay;
  QuerySnapshot promotions;
  int _current = 0;
  TabController tabController;






  Future getPromotions() async {
    await Firestore.instance.collection('promotions')
        .getDocuments()
        .then((value) {
      this.setState(() {
        promotions = value;
      });
    });
  }


  void setPhotoWidgets(context, snapshot) {
    double width = MediaQuery
        .of(context)
        .size
        .width;


    List<Widget> photoUrl = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      photoUrl.add(Image.network(
        snapshot.documents[i].data['photoUrl'], fit: BoxFit.cover,
        width: width,));
    }

    photoUrlList = photoUrl;
  }



  @override
  void initState() {

    super.initState();
    tabController = new TabController(length: 5, vsync: this);

    tab = tabController.index;


    FirebaseAuth.instance.currentUser().then((value) {
      setState(() {
        user = value;
      });

      setState(() {
        if (DateTime
            .now()
            .hour < 12) {
          timeOfDay = "Good Morning";
        }

        else {
          timeOfDay = "Good Afternoon";
        }
      });
    });
  }

  DocumentSnapshot parent;
  String status;





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;

    if (user == null) {
      return Center(
          child: CircularProgressIndicator()
      );
    }

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').where(
            'uid', isEqualTo: user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          parent = snapshot.data.documents[0];
          if(parent.data['status'] == "Mother"){
            status = "motherUid";
          }
          else if(parent.data['status'] == "Father"){
            status = "fatherUid";

          }

          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                actionsIconTheme: IconThemeData(color: Colors.white),
                title: Row(
                    children: [

                      Container(
                        width: 50,
                        height: 50,
                        child:
                        CircleAvatar(
                          backgroundImage: NetworkImage(parent['photoUrl']),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),


                      Text(tab == 0 ? "${timeOfDay}... \n${parent['firstName']}" :

                      tab == 1 ? "Schedule" :
                      tab == 2 ? "Check-In" :
                      tab == 3 ? "Notifications" :
                      tab == 4 ? "Settings" : ""),
                    ]
                ),





                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    )
                ),


              ),

              bottomNavigationBar: new Material(
                color: Color.fromRGBO(153, 107, 55, 1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                child: TabBar(
                  onTap: (value){
                    setState(() {
                      tab = tabController.index;
                    });
                  },
                  unselectedLabelColor: Colors.white70,
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  controller: tabController,
                  tabs: <Widget>[

                    new Tab(child: Container(padding: EdgeInsets.only(top: 4),child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset("lib/Assets/home.png", height: 30, color: tab== 0? Colors.white : Colors.white70 , ), Text("HOME", style: TextStyle(fontSize: 9),)],),),),
                    new Tab(child: Container(padding: EdgeInsets.only(top: 4),child:Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset("lib/Assets/schedule.png", height: 30, color: tab == 1? Colors.white : Colors.white70  ), Text("SCHEDULE", style: TextStyle(fontSize: 9),)],),),),
                    new Tab(child: Container(padding: EdgeInsets.only(top: 4),child:Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset("lib/Assets/qrcode.png", height: 30, color: tab == 2? Colors.white : Colors.white70  ), Text("CHECK-IN", style: TextStyle(fontSize: 9),)],),),),
                    new Tab(child: Container(padding: EdgeInsets.only(top: 4),child:Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset("lib/Assets/notify.png", height: 30, color: tab == 3? Colors.white : Colors.white70  ), Text("NOTIFY", style: TextStyle(fontSize: 9),)],),),),

                    new Tab(child: Container(padding: EdgeInsets.only(top: 4),child:Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset("lib/Assets/settings.png", height: 30,  color: tab == 4? Colors.white : Colors.white70 ), Text("SETTINGS", style: TextStyle(fontSize: 9),)],),),),
                  ],
                ),
              ),


              endDrawer: Drawer(

                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage("lib/Assets/bdblogo.jpg",)

                          )
                      ),
                    ),
                    ListTile(
                      title: Text('Profile'),
                      trailing: Icon(Icons.account_circle),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: DropdownButton(
                        hint: Text("Sign into classroom", style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),),
                        elevation: 0,
                        underline: Container(
                          height: 2,
                          color: Colors.white12,
                        ),

                        icon: Container(),
                        style: TextStyle(color: Colors.black),
                        onChanged: (newValue) {
                          setState(() {

                          });
                        },

                      ),
                      trailing: Icon(Icons.av_timer),
                      onTap: () {},
                    ),


                    ListTile(
                      title: Text('Performance'),
                      trailing: Icon(Icons.person),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      title: Text('Payment'),
                      trailing: Icon(Icons.attach_money),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      title: Text("Calendar"),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text("Gallery"),
                      trailing: Icon(Icons.image),
                      onTap: () {

                      },
                    ),

                    ListTile(
                      title: Text("Sign Out"),
                      trailing: Icon(Icons.exit_to_app),
                      onTap: () {

                      },
                    )
                  ],
                ),
              ),
              backgroundColor: Colors.white,
              body: new TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    new CustomScrollView(

                        slivers: <Widget>[
                          SliverAppBar(
                            backgroundColor: Color.fromRGBO(23, 142, 137, 1),
                            actionsIconTheme: IconThemeData(
                                color: Color.fromRGBO(0, 0, 0, 0)
                            ),
                            pinned: false,
                            forceElevated: true,
                            elevation: 10,
                            floating: true,
                            expandedHeight: height / 1.8,
                            flexibleSpace: new FlexibleSpaceBar(
                              background: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection(
                                      'promotions').snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return new Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    setPhotoWidgets(context, snapshot.data);


                                    return Stack(
                                        alignment: Alignment.topCenter,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: height / 11),
                                            child:
                                            CarouselSlider(
                                              items: photoUrlList,
                                              options: CarouselOptions(
                                                  height: height / 3,
                                                  autoPlay: true,
                                                  autoPlayInterval: Duration(
                                                      seconds: 5),
                                                  viewportFraction: 1.0,
                                                  enlargeCenterPage: false,
                                                  onPageChanged: (index,
                                                      reason) {
                                                    setState(() {
                                                      _current = index;
                                                    });
                                                  }
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: height / 4,
                                            child: Container(
                                              color: Color.fromRGBO(
                                                  23, 142, 137, 0.4),
                                              width: width,
                                              height: 60,
                                            ),
                                          ),
                                          Positioned(
                                              bottom: height / 4,
                                              child:
                                              Column(
                                                  children: [
                                                    Text(
                                                      snapshot.data
                                                          .documents[_current]
                                                          .data['description'],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,

                                                      ),),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: photoUrlList
                                                          .map((url) {
                                                        int index = photoUrlList
                                                            .indexOf(url);
                                                        return Container(
                                                          width: 13,
                                                          height: 13,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                              vertical: 10.0,
                                                              horizontal: 2.0),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: _current ==
                                                                  index
                                                                  ? Colors.white
                                                                  : Colors
                                                                  .white54
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),


                                                  ]
                                              )
                                          ),
                                          Positioned(
                                            bottom: height / 6.5,
                                            left: 15,

                                            child: Text(
                                              "WHAT ARE WE \nSTUDYING TODAY?",
                                              style: TextStyle(
                                                  fontSize: 22
                                              ),),
                                          ),


                                          Positioned(
                                            bottom: height / 20,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: height / 10,
                                                  width: height / 10,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(100)),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "lib/Assets/iq.png"),
                                                      )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width / 8,
                                                ),
                                                Container(
                                                  height: height / 10,
                                                  width: height / 10,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(100)),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "lib/Assets/mindmap.png"),
                                                      )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width / 8,
                                                ),
                                                Container(
                                                  height: height / 10,
                                                  width: height / 10,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(100)),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "lib/Assets/conversation.png"),
                                                      )
                                                  ),
                                                ),


                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            left: width / 5.2,
                                            bottom: height / 100,
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "IQ", style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white
                                                  ),),
                                                ),
                                                SizedBox(
                                                  width: width / 6,
                                                ),
                                                Container(
                                                  child: Text(
                                                    "MINDMAP", style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white
                                                  ),),
                                                ),
                                                SizedBox(
                                                  width: width / 17,
                                                ),
                                                Container(
                                                  child: Text("CONVERSATION",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white
                                                    ),),
                                                ),

                                              ],
                                            ),
                                          )


                                        ]
                                    );
                                  }
                              ),
                            ),
                          ),
                          SliverList(

                              delegate: SliverChildListDelegate(
                                  [


                                    Container(
                                        padding: EdgeInsets.only(top: 20,),
                                        child:
                                        Center(
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: <Widget>[

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: <Widget>[

                                                      Container(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: 8,
                                                            top: 10,
                                                            ),
                                                        height: height / 5,
                                                        width: width / 2.35,
                                                        child: Stack(
                                                            children: [



                                                              Positioned(
                                                                left: width/5,
                                                                top: height/30,
                                                                height: height/6.5,
                                                                child: Image.asset("lib/Assets/science.png", color: Colors.white,),
                                                              ),

                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "KNOWLEDGE ABOUT THE NATURAL WORLD AROUND US",
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      wordSpacing: 2,
                                                                    ),),
                                                                  SizedBox(
                                                                    height: height /
                                                                        40,
                                                                  ),
                                                                  Text(
                                                                    "SCIENCE",
                                                                    style: TextStyle(
                                                                        fontSize: 28
                                                                    ),)
                                                                ],
                                                              ),
                                                            ]
                                                        ),
                                                        decoration: BoxDecoration(

                                                            color: Color
                                                                .fromRGBO(
                                                                235, 183, 65,
                                                                1),
                                                            borderRadius: BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10))
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width / 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        children: <Widget>[

                                                          Container(
                                                            padding: EdgeInsets
                                                                .only(

                                                              top: 10,
                                                            ),
                                                            height: height / 5,
                                                            width: width / 2.35,
                                                            child: Stack(
                                                                children: [



                                                                  Positioned(
                                                                    right: width/5,
                                                                    bottom: height/30,
                                                                    height: height/6.5,
                                                                    child: Image.asset("lib/Assets/art.png", color: Colors.white,),
                                                                  ),

                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Container(
                                                                        padding: EdgeInsets.only(left: width/6, top: width/20),
                                                                        child: Text(
                                                                          "ART",
                                                                          style: TextStyle(
                                                                              fontSize: 28
                                                                          ),),
                                                                      ),
                                                                      SizedBox(
                                                                        height: height /
                                                                            400,
                                                                      ),
                                                                      Container(
                                                                        padding: EdgeInsets.only(bottom: 10, left: 24, right: 2 ),
                                                                        child: Text(
                                                                          "THE CREATION OF THINGS WHOSE PURPOSE IS TO BE BEAUTIFUL",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            wordSpacing: 2,
                                                                          ),),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ]
                                                            ),

                                                            decoration: BoxDecoration(
                                                                color: Color
                                                                    .fromRGBO(
                                                                    235, 183, 65,
                                                                    1),
                                                                borderRadius: BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        10))
                                                            ),
                                                          ),
                                                                        ])


                                                    ],
                                                  )
                                                ]
                                            )
                                        )
                                    ),


                                  ]
                              )
                          )
                        ]
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('students').where(status, isEqualTo: parent.data['uid']).snapshots(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ParentCalendar(snapshot);
                      }
                    ),
                    Container(),
                    Container(),
                    Container(),
                  ])
          );
        }
    );
  }
}