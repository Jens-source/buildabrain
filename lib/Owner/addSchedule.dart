import 'dart:io';
import 'dart:ui';

import 'package:buildabrain/Owner/ownerHome.dart';
import 'package:buildabrain/services/promotionManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';




class AddSchedule extends StatefulWidget {
  AddSchedule( this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);

  final user;

  final startDate;
  final endDate;
  final startTime;
  final endTime;
  final description;
  final host;
  final name;
  final location;
  final material;
  final dressCode;
  final eventPhoto;



  @override
  _AddScheduleState createState() => _AddScheduleState( this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);
}

class _AddScheduleState extends State<AddSchedule> {
  _AddScheduleState( this.startDate, this.endDate, this.startTime, this.endTime ,this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);

  final user;


  GoogleMapController _controller;

  String time;
  InputBorder border;


  var eventPhoto;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String topic = "TOPIC";
  String description;
  String name;
  LatLng location;
  String material;
  String dressCode;
  String host;
  DragStartBehavior dragStartBehavior;
  List<Marker> allMarkers = [];
  bool locationAdded;
  bool change;



  void mapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;



    });
  }


  void googleDialog() async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {


        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
                title: Center(child: Text("Choose location")),
                actions: [
                  FlatButton(
                    child: Text("OK", style: TextStyle(
                        color: Colors.blue
                    ),),
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        location  = allMarkers[0].position;
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("CANCEL", style: TextStyle(
                        color: Colors.blue
                    ),),
                    onPressed: (){
                      allMarkers = [];

                      allMarkers.add(Marker(
                          markerId: MarkerId('myMarker'),
                          draggable: true,
                          onTap: () {

                            print(allMarkers[0].position);

                            setState(() {
                              location = allMarkers[0].position;
                            });







                          },
                          position: LatLng(13.7563, 100.5018)));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Container(
                  height: 400,
                  width: 400,
                  child: GoogleMap(

                    onTap: (point){
                      setState(() {
                        _handleTap(point);
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(13.7563, 100.5018),
                      zoom: 12.0,
                    ),



                    onMapCreated: mapCreated,
                    markers: Set.from(allMarkers),

                  ),
                )
            );
          },
        );

      },
    );
  }

  @override
  void initState() {
    dragStartBehavior = DragStartBehavior.down;

    if(location != null && description != null){
      setState(() {
        change = true;
      });
    }

    if(location == null) {

      setState(() {
        allMarkers.add(Marker(
            markerId: MarkerId('myMarker'),
            draggable: true,
            onTap: () {

              print(allMarkers[0].position);



            },
            position: LatLng(13.7563, 100.5018)));

        locationAdded = false;
      });
    } else{
      setState(() {
        locationAdded = true;

        allMarkers.add(Marker(
            markerId: MarkerId('myMarker'),
            draggable: true,
            onTap: () {

              print(allMarkers[0].position);

            },
            position: LatLng(location.latitude, location.longitude)));

      });

    }

    time = "00:00 AM";

    if(startTime == null){
      startTime = TimeOfDay(hour: 12, minute: 0);
      endTime = TimeOfDay(hour: 14, minute: 0);
    }


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
        backgroundColor: Colors.white,

        appBar: AppBar(


          leading: Icon(Icons.event, color: Colors.white,),
          title: Text("Create a new event"),
          actions: [
            FlatButton(
              child: Text("CANCEL", style: TextStyle(
                  color: Colors.white70
              ),),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              )
          ),
        ),


        body: new CustomScrollView(
            dragStartBehavior: dragStartBehavior,


            slivers: <Widget>[

              SliverAppBar(

                  backgroundColor: Colors.white,
                  leading: Container(),

                  iconTheme: IconThemeData(
                      color: Colors.white
                  ),

                  pinned: true,
                  forceElevated: true,

                  automaticallyImplyLeading: true,
                  primary: true,

                  floating: false,
                  expandedHeight: height / 3 + 60,
                  flexibleSpace: new FlexibleSpaceBar(
                      background:

                      Container(


                          child:
                          Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [

                                Container(
                                    padding: EdgeInsets.only(
                                        left: 15, top: 15, bottom: 15),
                                    child: Text(
                                      "Event details", style: TextStyle(
                                        fontSize: 22
                                    ),)),


                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ImageEdit(this.startDate, this.endDate, this.startTime, this.endTime, this.description,
                                                      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user)));

                                    },
                                    child:
                                    Container(
                                      color: Colors.grey,
                                      height: height / 3,
                                      width: width,

                                      child: Center(


                                        child: eventPhoto == null ?
                                        Container(
                                          height: 35,
                                          width: 190,

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .all(
                                                  Radius.circular(15)),
                                              color: Colors.white

                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Icon(Icons
                                                  .add_photo_alternate),
                                              Text("ADD COVER PHOTO")
                                            ],
                                          ),
                                        ) : FadeInImage.assetNetwork(
                                          placeholder: 'assets/loading.gif',
                                          placeholderScale: 1,
                                          image: eventPhoto, fit: BoxFit.cover,
                                          width: width,
                                        ))

                                      ),
                                    )

                              ])


                      )

                  )
              ),
              SliverList(

                  delegate: SliverChildListDelegate(
                      [
                        Container(
                            padding: EdgeInsets.all(15),
                            child: Stack(

                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [
                                        Text("Date", style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16
                                        ),),
                                        SizedBox(
                                          width: 10,
                                        ),


                                        GestureDetector(
                                          onTap: () async {
                                            await showDatePicker(
                                                context: context,
                                                initialDate: startDate,
                                                firstDate: DateTime(DateTime
                                                    .now()
                                                    .year),
                                                lastDate: DateTime(DateTime
                                                    .now()
                                                    .year + 5)).then((
                                                value) async {
                                              if (value != null) {
                                                startDate = value;
                                                await showDialog(
                                                    context: context,
                                                    builder: (
                                                        BuildContext context) {
                                                      return AlertDialog(
                                                        content: Text(
                                                            "Is this event more than 1 day?"),
                                                        actions: [
                                                          FlatButton(
                                                            onPressed: () async {
                                                              await showDatePicker(

                                                                  helpText: "SELECT END DATE",
                                                                  context: context,
                                                                  initialDate: startDate,

                                                                  firstDate: startDate,
                                                                  lastDate: DateTime(
                                                                      DateTime
                                                                          .now()
                                                                          .year +
                                                                          5))
                                                                  .then((
                                                                  volue) async {
                                                                if (volue !=
                                                                    null) {
                                                                  endDate =
                                                                      volue;
                                                                  await showTimePicker(
                                                                    initialTime: TimeOfDay
                                                                        .now(),
                                                                    context: context,
                                                                    builder: (
                                                                        BuildContext context,
                                                                        Widget child) {
                                                                      return Material(
                                                                        type: MaterialType
                                                                            .transparency,
                                                                        child: MediaQuery(
                                                                          data: MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .copyWith(
                                                                              alwaysUse24HourFormat: true),
                                                                          child: Container(
                                                                            child: Column(
                                                                              children: [
                                                                                Text(
                                                                                  "Start Time",
                                                                                  style: TextStyle(
                                                                                      fontSize: 28,
                                                                                      color: Colors
                                                                                          .white
                                                                                  ),),
                                                                                child
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((val) {
                                                                    setState(() {
                                                                      if (val !=
                                                                          null) {
                                                                        startTime =
                                                                            val;
                                                                      }
                                                                    });
                                                                  });
                                                                  await showTimePicker(
                                                                    initialTime: TimeOfDay(
                                                                        hour: startTime
                                                                            .hour +
                                                                            2,
                                                                        minute: startTime
                                                                            .minute),
                                                                    context: context,
                                                                    builder: (
                                                                        BuildContext context,
                                                                        Widget child) {
                                                                      return Material(
                                                                        type: MaterialType
                                                                            .transparency,
                                                                        child: MediaQuery(
                                                                          data: MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .copyWith(
                                                                              alwaysUse24HourFormat: true),
                                                                          child: Container(
                                                                            child: Column(
                                                                              children: [
                                                                                Text(
                                                                                  "End Time",
                                                                                  style: TextStyle(
                                                                                      fontSize: 28,
                                                                                      color: Colors
                                                                                          .white
                                                                                  ),),
                                                                                child
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((vol) {
                                                                    setState(() {
                                                                      if (vol !=
                                                                          null) {
                                                                        endTime =
                                                                            vol;
                                                                      }

                                                                      Navigator
                                                                          .pop(
                                                                          context);
                                                                    });
                                                                  });
                                                                }
                                                              });
                                                            },
                                                            child: Text("YES"),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () async {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("NO"),
                                                          )
                                                        ],

                                                      );
                                                    });
                                              }
                                            });
                                          },
                                          child:
                                          Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(100))
                                              ),

                                              height: 35,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Text("${DateFormat("yMMMd")
                                                      .format(
                                                      startDate)}"),

                                                  endDate != null ?
                                                  Text("  -  ${DateFormat(
                                                      "yMMMd").format(
                                                      endDate)}") :
                                                  Container(),

                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Icon(Icons.edit, size: 20,
                                                    color: Colors.black54,)
                                                ],
                                              )

                                          ),
                                        ),

                                        SizedBox(
                                          width: 15,
                                        ),


                                      ],
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Row(
                                      children: [
                                        Text("Start Time:   ${startTime.format(
                                            context)}", style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16
                                        ),),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          constraints: BoxConstraints(
                                              maxHeight: 40),

                                          onPressed: () async {
                                            await showTimePicker(
                                              initialTime: TimeOfDay
                                                  .now(),
                                              context: context,
                                              builder: (BuildContext context,
                                                  Widget child) {
                                                return Material(
                                                  type: MaterialType
                                                      .transparency,
                                                  child: MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                        alwaysUse24HourFormat: true),
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Text("Start Time",
                                                            style: TextStyle(
                                                                fontSize: 28,
                                                                color: Colors
                                                                    .white
                                                            ),),
                                                          child
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then((val) {
                                              setState(() {
                                                if (val != null) {
                                                  startTime = val;

                                                }
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.edit, size: 20,
                                            color: Colors.black54,),
                                        )
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text("End Time:   ${endTime.format(
                                            context)}", style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16
                                        ),),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          constraints: BoxConstraints(
                                              maxHeight: 40),
                                          onPressed: () async {
                                            await showTimePicker(
                                              initialTime: TimeOfDay
                                                  .now(),
                                              context: context,
                                              builder: (BuildContext context,
                                                  Widget child) {
                                                return Material(
                                                  type: MaterialType
                                                      .transparency,
                                                  child: MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                        alwaysUse24HourFormat: true),
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Text("End Time",
                                                            style: TextStyle(
                                                                fontSize: 28,
                                                                color: Colors
                                                                    .white
                                                            ),),
                                                          child
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then((val) {
                                              setState(() {
                                                if (val != null) {
                                                  endTime = val;
                                                }
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.edit, size: 20,
                                            color: Colors.black54,),
                                        )
                                      ],
                                    ),


                                    SizedBox(


                                      child:
                                      TextField(

                                        maxLines: 1,

                                        maxLengthEnforced: true,


                                        decoration: InputDecoration(
                                          hintText: name == null ? "EVENT NAME" : name,
                                          hintStyle: TextStyle(
                                              fontSize: 22
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),

                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Balsamiq',
                                            color: Colors.black54
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            name = value;
                                          });
                                        },
                                      ),
                                    ),


                                    Row(

                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Text("HOSTED BY : "),
                                        ),
                                        Container(
                                          width: width / 2.5,

                                          height: 20,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide()
                                                )
                                            ),
                                            child:
                                            TextFormField(
                                              decoration: InputDecoration(
                                                hintText: host,
                                                hintStyle: TextStyle(
                                                    fontSize: 16
                                                ),

                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder: InputBorder
                                                    .none,
                                              ),

                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Balsamiq',
                                                  color: Colors.black54
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  host = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),

                                    SizedBox(
                                      height: 15,
                                    ),

                                    Row(
                                      children: [
                                        Container(

                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  "lib/Assets/pencil.png",
                                                  height: 60,
                                                ),

                                                SizedBox(
                                                  width: 15,
                                                ),


                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text("Description",
                                                      style: TextStyle(
                                                          fontSize: 16
                                                      ),),
                                                    Container(
                                                      width: width / 1.5,
                                                      child: TextField(
                                                        maxLines: 1,
                                                        maxLength: 40,
                                                        decoration: InputDecoration(
                                                          hintText: description == null ? "Add a description" : description,
                                                          hintStyle: TextStyle(
                                                              fontSize: 16
                                                          ),
                                                          border: InputBorder
                                                              .none,
                                                          focusedBorder: InputBorder
                                                              .none,
                                                          enabledBorder: InputBorder
                                                              .none,
                                                          errorBorder: InputBorder
                                                              .none,
                                                          disabledBorder: InputBorder
                                                              .none,
                                                        ),

                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily: 'Balsamiq',
                                                            color: Colors
                                                                .black54
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            description = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )

                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(

                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  "lib/Assets/location.png",
                                                  height: 60,
                                                ),

                                                SizedBox(
                                                  width: 15,
                                                ),


                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text("Location",
                                                      style: TextStyle(
                                                          fontSize: 16
                                                      ),),


                                                    allMarkers[0].position.latitude == 13.7563 ?
                                                    Container(
                                                      child: FlatButton(
                                                        onPressed: (){
                                                          googleDialog();

                                                        },
                                                        child: Text("ADD LOCATION", style: TextStyle(
                                                          color: Colors.blue
                                                        ),),
                                                      ),


                                                    ) : Row(
                                                      children: [
                                                        Text("LOCATION ADDED", style: TextStyle(
                                                            color: Colors.green
                                                        ),),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        FlatButton(
                                                          onPressed: (){
                                                            googleDialog();
                                                          },
                                                          child:  Text("CHANGE?", style: TextStyle(
                                                              color: Colors.blue
                                                          ),),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            )

                                        ),
                                      ],
                                    ),



                                    Row(
                                      children: [
                                        Container(

                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  "lib/Assets/material.png",
                                                  height: 60,
                                                ),

                                                SizedBox(
                                                  width: 15,
                                                ),


                                                Column(

                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(top: 10),
                                                      child: Text("Material",
                                                        style: TextStyle(
                                                            fontSize: 16
                                                        ),),
                                                    ),
                                                    Container(

                                                      width: width / 1.4,
                                                      child: TextField(
                                                        maxLines: 2,

                                                        decoration: InputDecoration(
                                                          hintText: material == null ? "What to bring?" : material,
                                                          hintStyle: TextStyle(
                                                              fontSize: 16
                                                          ),
                                                          border: InputBorder
                                                              .none,
                                                          focusedBorder: InputBorder
                                                              .none,
                                                          enabledBorder: InputBorder
                                                              .none,
                                                          errorBorder: InputBorder
                                                              .none,
                                                          disabledBorder: InputBorder
                                                              .none,
                                                        ),

                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily: 'Balsamiq',
                                                            color: Colors
                                                                .black54
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            material = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),


                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Container(

                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "lib/Assets/dresscode.png",
                                                height: 60,
                                              ),

                                              SizedBox(
                                                width: 15,
                                              ),


                                              Column(

                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Text("Dress Code",
                                                      style: TextStyle(
                                                          fontSize: 16
                                                      ),),
                                                  ),
                                                  Container(

                                                    width: width / 1.4,
                                                    child: TextField(
                                                      maxLines: 2,

                                                      decoration: InputDecoration(
                                                        hintText: dressCode == null ? "What to wear?" : dressCode,
                                                        hintStyle: TextStyle(
                                                            fontSize: 16
                                                        ),
                                                        border: InputBorder
                                                            .none,
                                                        focusedBorder: InputBorder
                                                            .none,
                                                        enabledBorder: InputBorder
                                                            .none,
                                                        errorBorder: InputBorder
                                                            .none,
                                                        disabledBorder: InputBorder
                                                            .none,
                                                      ),

                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Balsamiq',
                                                          color: Colors
                                                              .black54
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dressCode = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),




                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                                Positioned(
                                  right: 10,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                        "lib/Assets/colorwheel.png"),
                                  ),
                                ),

                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: ()async {








                                      if( eventPhoto != null && name != null && startDate != null
                                          && startTime != null && endTime != null &&
                                      host != null && description != null && location != null &&
                                      material != null && dressCode != null) {
                                        String locationUrl = "https://maps.google.com/?q=${location.latitude},${location.longitude}";






                                        String startTimeHour = startTime.hour < 10 ? "0${startTime.hour}" : startTime.hour.toString();
                                        String startTimeMinute = startTime.minute < 10 ? "0${startTime.minute}" : startTime.minute.toString();

                                        String endTimeHour = endTime.hour < 10 ? "0${endTime.hour}" : endTime.hour.toString();
                                        String endTimeMinute = endTime.minute < 10 ? "0${endTime.minute}" : endTime.minute.toString();


                                        BuildContext dialogContext;
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            dialogContext = context;
                                            return AlertDialog(
                                              title: Center(child: CircularProgressIndicator()),

                                            );
                                          },
                                        );

                                        print(locationUrl);



                                        change == false ?
                                        await PromotionManagement().storePromotion(
                                          eventPhoto,

                                          name,
                                          DateFormat("yyyy-MM-dd").format(startDate),
                                          endDate == null ? null : DateFormat("yyyy-MM-dd").format(endDate),

                                          "$startTimeHour:$startTimeMinute",
                                          "$endTimeHour:$endTimeMinute",
                                          host,
                                          description,
                                          locationUrl,
                                          material,
                                          dressCode,
                                        ) :
                                        await PromotionManagement().updateSchedule(
                                          eventPhoto,

                                          name,
                                          DateFormat("yyyy-MM-dd").format(startDate),
                                          endDate == null ? null : DateFormat("yyyy-MM-dd").format(endDate),

                                          "$startTimeHour:$startTimeMinute",
                                          "$endTimeHour:$endTimeMinute",
                                          host,
                                          description,
                                          locationUrl,
                                          material,
                                          dressCode,

                                        );
                                        Navigator.pop(dialogContext);
                                        Navigator.pop(context);


                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (
                                                BuildContext context) {
                                              return AlertDialog(
                                                  content: Text(
                                                      "Please fill in missing information"),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text("OK", style: TextStyle(
                                                        color: Colors.blue
                                                      ),),
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ]
                                              );
                                            }
                                        );
                                      }

                                    },
                                    child:
                                  Container(
                                    height: 30,
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                       borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Color.fromRGBO(23, 142, 137, 1),

                                  ),
                                    child: Center(child: Text(change == false ? "CREATE EVENT" : "EDIT EVENT", style: TextStyle(
                                      color: Colors.white
                                    ),)),
                                  ),
                                  ),
                                )

                              ],
                            )


                        )
                      ]
                  )
              )
            ]));
  }

  _handleTap(LatLng point) {
    setState(() {
      allMarkers = [];
      allMarkers.add(
          Marker(
              markerId: MarkerId(point.toString()),
              position: point

          )
      );
    });
  }

}




class ImageEdit extends StatefulWidget{
  ImageEdit( this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);
  final user;

  final startDate;
  final endDate;
  final startTime;
  final endTime;
  final description;
  final host;
  final name;
  final location;
  final material;
  final dressCode;
  final eventPhoto;

  @override
  _ImageEditState createState() => _ImageEditState( this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState( this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);
  final user;

  final startDate;
  final endDate;
  final startTime;
  final endTime;
  final description;
  final host;
  final name;
  final location;
  final material;
  final dressCode;
  final eventPhoto;
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    selected = await ImageCropper.cropImage(
        sourcePath: selected.path,
        aspectRatio: CropAspectRatio(ratioY: 300, ratioX: 450,),
        maxWidth: 700,
        maxHeight: 700
    );

    setState(() {
      _imageFile = selected;
    });
  }


  Future getImageGallery() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = tempImage;
    });
    _cropImage();
  }

  Future getImageCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = tempImage;
    });
    _cropImage();
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatio: CropAspectRatio(ratioY: 300, ratioX: 500,),
        maxWidth: 700,
        maxHeight: 700
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });

  }

  void _clear() {
    setState(() => _imageFile = null);
  }


  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://buildabrain-a8cce.appspot.com/');

  StorageUploadTask _uploadTask;

  String filePath;
  String filePaths;
  bool wait = false;


  @override
  Widget build(BuildContext context) =>
      new Scaffold(
          backgroundColor: Colors.white,


          body: _imageFile == null ?

          Container(

              child:  Container(

                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[


                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Container(
                            height: 80,
                            width: 80,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: Colors.blueAccent,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.photo_camera, color: Colors.white,),
                              onPressed: () {
                                _pickImage(ImageSource.camera);
                              },
                            ),
                          ),

                          SizedBox(
                            width: 50,
                          ),

                          Container(
                            height: 80,
                            width: 80,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: Colors.blueAccent,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.photo_library, color: Colors.white,),
                              onPressed: () {
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text("Camera", style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                          SizedBox(
                            width: 80,
                          ),
                          Container(
                            child: Text("Gallery", style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                  color: Colors.black.withOpacity(0.4),
              )
          ) :

          wait == true ?
          new Container(
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          ) :
          new ListView(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Center(
                  child:
                  Container(

                      child: Image.file(_imageFile),

                  )
              ),

              SizedBox(
                height: 50,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.crop, size: 50, color: Colors.black,),
                    onPressed: _cropImage,
                  ),
                  FlatButton(
                    child: Icon(Icons.refresh, size: 50, color: Colors.black,),
                    onPressed: _clear,
                  ),
                  FlatButton(
                    child: Icon(Icons.file_upload, size: 50, color: Colors.black,),
                    onPressed: () async {
                      wait = true;
                      FirebaseUser user = await FirebaseAuth.instance.currentUser();

                      filePath = 'eventPhotos/${DateTime.now()}.png';
                      setState(() {
                        _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);

                      });


                      StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
                      String downloadUrl =  await snapshot.ref.getDownloadURL();

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                 AddSchedule( this.startDate, this.endDate, this.startTime, this.endTime, this.description,
                                     this.host, this.name, this.location, this.material, this.dressCode, downloadUrl, this.user)));




                    },
                  )
                ],
              ),
            ],
          )
      );
}





