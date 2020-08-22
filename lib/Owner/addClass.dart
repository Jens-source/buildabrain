import 'dart:io';
import 'dart:ui';

import 'package:buildabrain/Owner/ownerHome.dart';
import 'package:buildabrain/services/promotionManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';




class AddClass extends StatefulWidget {
  AddClass(this.date, this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);

  final user;
  final date;
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
  _AddClassState createState() => _AddClassState(this.date, this.startDate, this.endDate, this.startTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);
}

class _AddClassState extends State<AddClass> {
  _AddClassState(this.date, this.day, this.endDate, this.startTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);

  final user;
  final DateTime date;

  GoogleMapController _controller;

  String time;
  InputBorder border;
  String teacher;
  List<String> teacherNames;




  var eventPhoto;
  String day;
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
  int classesAmount = 1;
  String classType = "Preschool";


  List <String> subjects;



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


                            print(location);




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


    Firestore.instance.collection('users')
    .where('identity', isEqualTo: "Teacher")
    .getDocuments().then((value) {
      teacherNames = new List(value.documents.length);
      for(int j = 0; j < value.documents.length; j++){
        setState(() {
          teacherNames[j] = value.documents[j].data['firstName'];
        });
      }
    }).asStream();
    subjects = new List(classesAmount);
    dragStartBehavior = DragStartBehavior.down;
    time = "00:00 AM";
    startTime = TimeOfDay(hour: 12, minute: 0);
    endTime = TimeOfDay(hour: 14, minute: 0);



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
          title: Text("Create a new class"),
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


        body: new ListView(
          children: [


        new Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(15),
                            child: Stack(

                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Class detail", style: TextStyle(
                                        fontSize: 22
                                    ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text("Day", style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16
                                        ),),
                                        SizedBox(
                                          width: 20,
                                        ),


                                        DropdownButton<String>(
                                          icon: Icon(Icons.edit),
                                          iconSize: 20,
                                          underline: Container(),
                                          value: day,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              day = newValue;
                                            }
                                            );
                                          },
                                          items: <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),


                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Class type", style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16
                                        ),),
                                        SizedBox(
                                          width: 20,
                                        ),


                                        DropdownButton<String>(
                                          icon: Icon(Icons.edit),
                                          iconSize: 20,
                                          underline: Container(),
                                          value: classType,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              classType = newValue;
                                            }
                                            );
                                          },
                                          items: <String>["Preschool", "Junior", "Advanced"]
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
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

                                    Row(
                                      children: [
                                        Text("Amount of subjects in this class: "),
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child:  DropdownButton<int>(
                                            underline: Container(),
                                            value: classesAmount,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                            ),
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 16,
                                            onChanged: (int newValue) {
                                              setState(() {
                                                classesAmount = newValue;
                                                subjects = new List(classesAmount);
                                              });
                                            },
                                            items: <int>[1, 2, 3,]
                                                .map<DropdownMenuItem<int>>((int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),

                                    ListView.builder(

                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,

                                      itemCount: classesAmount,
                                        itemBuilder: (BuildContext context, i){
                                        return Container(
                                          child: Row(
                                            children: [
                                              Text("${i + 1}. Subject: "),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child:  DropdownButton<String>(
                                                      underline: Container(),
                                                      value: subjects[i],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black
                                                      ),
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      iconSize: 30,
                                                      elevation: 16,
                                                      onChanged: (String newValue) {
                                                        setState(() {
                                                          subjects[i] = newValue;
                                                        });
                                                      },
                                                      items: <String>["Mindmap", "IQ", "Phonics", "Science"]
                                                          .map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(value.toString()),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          )
                                        );
                                        }),

                                



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
                                                  "lib/Assets/teacher.png",
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
                                                    Text("Teacher",
                                                      style: TextStyle(
                                                          fontSize: 16
                                                      ),),
                                                    DropdownButton<String>(
                                                      underline: Container(),

                                                      value: teacher,
                                                      hint: Text("Name"),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black
                                                      ),
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      iconSize: 30,
                                                      elevation: 16,
                                                      onChanged: (String newValue) {
                                                        setState(() {
                                                        teacher = newValue;
                                                        });
                                                      },
                                                      items: teacherNames
                                                          .map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(value.toString()),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )

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




                                      if( day != null && startTime != null && endTime != null &&
                                          subjects[0] != null && teacher.length < 3) {


                                        showDialog(
                                            context: context,
                                            builder: (
                                                BuildContext context) {
                                              return AlertDialog(
                                                content:
                                                Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: CircularProgressIndicator()),

                                              );
                                            }
                                        );

                                        

                                        await PromotionManagement().storePromotion(
                                            eventPhoto,
                                            name,
                                            day,
                                            endDate != null ? DateFormat("yyyy-MM-dd").format(endDate) : endDate,
                                            "${startTime.hour}:${startTime.minute}",
                                            "${endTime.hour}:${endTime.minute}",
                                            host,
                                            description,
                                            locationUrl,
                                            material,
                                            dressCode
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    OwnerHome(user)));

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
                                      child: Center(child: Text("CREATE EVENT", style: TextStyle(
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
    ]
        )
              );

  }

  _handleTap(LatLng point) {
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
  }

}




class ImageEdit extends StatefulWidget{
  ImageEdit(this.date, this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);
  final user;
  final date;
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
  _ImageEditState createState() => _ImageEditState(this.date, this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.date, this.startDate, this.endDate, this.startTime, this.endTime, this.description,
      this.host, this.name, this.location, this.material, this.dressCode, this.eventPhoto, this.user);
  final user;
  final date;
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
                                  AddClass(this.date, this.startDate, this.endDate, this.startTime, this.endTime, this.description,
                                      this.host, this.name, this.location, this.material, this.dressCode, downloadUrl, this.user)));




                    },
                  )
                ],
              ),
            ],
          )
      );
}




