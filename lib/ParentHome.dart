import 'dart:typed_data';

import 'package:buildabrain/FirstWeek.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParentHome extends StatefulWidget {
  @override
  _ParentHomeState createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> with
SingleTickerProviderStateMixin{



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




  void setPhotoWidgets(context, snapshot){
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;

    List<Widget> photoUrl = [];

    for(int i = 0; i < snapshot.documents.length; i++){
      photoUrl.add( Image.network(snapshot.documents[i].data['photoUrl'], fit: BoxFit.cover, width: width,));

    }


    print(photoUrl);
      photoUrlList = photoUrl;

  }


  List<Widget> photoUrlList = [];
  List<String> descriptionList = [];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
  }



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



    return Scaffold(

        bottomNavigationBar: new Material(
          color: Colors.white,
          child: TabBar(
            unselectedLabelColor: Colors.black38,
            labelColor: Colors.black,
            indicatorColor: Colors.white,

            controller: tabController,
            tabs: <Widget>[
              new Tab(icon: Icon(Icons.home)),
              new Tab(icon: Icon(Icons.location_on)),
              new Tab(icon: Icon(Icons.assignment)),
              new Tab(icon: Icon(Icons.location_on)),
              new Tab(icon: Icon(Icons.assignment)),
            ],
          ),
        ),


        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("lib/Assets/bdblogo.jpg")

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
                title: DropdownButton( //
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

        body:new TabBarView(
            controller: tabController,
            children: <Widget> [
        new CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Color.fromRGBO(23, 142, 137, 1),
                pinned: true,
                expandedHeight: height / 1.5,
                flexibleSpace: new FlexibleSpaceBar(
                  background: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('promotions').snapshots(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData){
                          return new Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        setPhotoWidgets(context, snapshot.data);


                        return Stack(
                    alignment: Alignment.topCenter,
                      children: <Widget>[
                             CarouselSlider(
                              items: photoUrlList,
                              options: CarouselOptions(
                                height: height/2.5,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 5),
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }
                              ),
                            ),
                        Positioned(
                          bottom: height/3.36,
                          child: Container(
                            color: Color.fromRGBO(23, 142, 137, 0.4),
                            width: width,
                            height: 60,
                          ),
                        ),
                        Positioned(
                          bottom: height/3.36,
                          child:
                              Column(
                                children: [
                                  Text(snapshot.data.documents[_current].data['description'], style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,

                                  ),),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: photoUrlList.map((url) {
                            int index = photoUrlList.indexOf(url);
                            return Container(
                              width: 13,
                              height: 13,
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Colors.white
                                    : Colors.white54
                              ),
                            );
                          }).toList(),
                        ),
                          ]
                              )
                        ),
                      ]
                  );
                      }
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                      [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 20),
                          child: Text("Weekly lessons", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                        ),

                        Container(
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child:
                            Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            height: 100,
                                            width: width * (4 / 10),
                                            child:
                                            MaterialButton(
                                              color: Colors.orange,
                                              onPressed: () {

                                              },
                                              child: Text(
                                                "Mindmap", style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white
                                              ),),

                                              shape: RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius
                                                      .circular(
                                                      18.0),
                                                  side: BorderSide(
                                                      color: Colors.orange)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 100,
                                            width: width * (4 / 10),
                                            child:
                                            MaterialButton(
                                              color: Colors.purple,
                                              onPressed: () {},
                                              child: Text(
                                                "IQ", style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white
                                              ),),

                                              shape: RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius
                                                      .circular(
                                                      18.0),
                                                  side: BorderSide(
                                                      color: Colors.purple)
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          SizedBox(
                                              width: 5
                                          ),
                                          Container(
                                            height: 100,
                                            width: width * (4 / 10),
                                            child:
                                            MaterialButton(
                                              color: Colors.blue,
                                              onPressed: () {},
                                              child: Text(
                                                "Art", style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white
                                              ),),

                                              shape: RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius
                                                      .circular(
                                                      18.0),
                                                  side: BorderSide(
                                                      color: Colors.blue)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 100,
                                            width: width * (4 / 10),
                                            child:
                                            MaterialButton(
                                              color: Colors.green,
                                              onPressed: () {},
                                              child: Text(
                                                "Phonics", style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white
                                              ),),

                                              shape: RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius
                                                      .circular(
                                                      18.0),
                                                  side: BorderSide(
                                                      color: Colors.green)
                                              ),
                                            ),
                                          ),

                                        ],
                                      )
                                    ]
                                )
                            )
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 30),
                          child: Text("Upcoming events", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        SizedBox(
                          height: 1000,
                        ),


                      ]
                  )
              )
            ]
        ),
              Container(),
              Container(),
              Container(),
    ])
    );
  }
}