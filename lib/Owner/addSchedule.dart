import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';




class AddSchedule extends StatefulWidget {
  AddSchedule(this.date);
  final date;

  @override
  _AddScheduleState createState() => _AddScheduleState(this.date);
}

class _AddScheduleState extends State<AddSchedule> {
  _AddScheduleState(this.date);

  final DateTime date;
  GoogleMapController _controller;


  String time;
  InputBorder border;


  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String topic = "TOPIC";
  String description;
  String name;
  String location;
  String material;
  String dressCode;
  String host;
  DragStartBehavior dragStartBehavior;
  List<Marker> allMarkers = [];


  void mapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;






    });
  }

  @override
  void initState() {
    dragStartBehavior = DragStartBehavior.down;
    time = "00:00 AM";
    startDate = date;
    startTime = TimeOfDay(hour: 12, minute: 0);
    endTime = TimeOfDay(hour: 14, minute: 0);
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {

          print(allMarkers[0].position);



        },
        position: LatLng(13.7563, 100.5018)));




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

                                    },
                                    child:
                                    Container(
                                      color: Colors.grey,
                                      height: height / 3,
                                      width: width,

                                      child: Center(
                                        child: Container(
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
                                        ),

                                      ),
                                    )
                                ),
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
                                                initialDate: date,
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
                                                  endTime = TimeOfDay(
                                                      hour: startTime.hour,
                                                      minute: startTime.minute);
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
                                          hintText: "EVENT NAME",
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
                                                      width: width / 2,
                                                      child: TextField(
                                                        maxLines: 2,
                                                        maxLength: 40,
                                                        decoration: InputDecoration(
                                                          hintText: "Add a description",
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
                                                          showDialog(
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

                                                                            setState(() {

                                                                            });
                                                                            Navigator.of(context).pop();

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
                                                                              print(point.toString());
                                                                              allMarkers = [];
                                                                              allMarkers.add(
                                                                                  Marker(
                                                                                      markerId: MarkerId(point.toString()),
                                                                                      position: point

                                                                                  )
                                                                              );

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


                                                        },
                                                        child: Text("ADD LOCATION", style: TextStyle(
                                                          color: Colors.blue
                                                        ),),
                                                      ),


                                                    ) : Text("LOCATION ADDED", style: TextStyle(
                                                        color: Colors.blue
                                                    ),),
                                                  ],
                                                )
                                              ],
                                            )

                                        ),
                                      ],
                                    )


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

    });
  }

}
