import 'dart:ui';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:intl/intl.dart';

import 'parentSignup.dart';

import '../services/userManagement.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;


class ChildInfo extends StatefulWidget {

  ChildInfo( this.document, this.picUrl);

  final document;
  final picUrl;






  @override

  _ChildInfoState createState() => _ChildInfoState( this.document, this.picUrl);
}

class _ChildInfoState extends State<ChildInfo> {
  _ChildInfoState(this.document, this.picUrl,);


  DocumentSnapshot document;
  bool backdrop = true;
  bool changedName = false;
  File newProfilePic;
  String picUrl;
  String dropdownValue = 'Mother';
  String dropdownInclude = 'No';
  String _number;
  String _street;
  String _district;
  String _province;
  String partnerUid;
  String currentUid;
  bool selectPic = true;
  String firstName;
  String lastName;
  String about;
  FirebaseUser user;
  String birthday = DateFormat('yyy-MM-dd').format(DateTime.now());
  List<String> allergies;
  bool genderChanged;
  bool gender;
  int alCount = 0;

  QuerySnapshot classes;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (document.data['gender'] == "male") {
      gender = false;
    }


    else if (document.data['gender'] == "female") {
      gender = true;
    }

    Firestore.instance.collection('students/${document.documentID}/schedules')
        .getDocuments()
        .then((value) {
      setState(() {
        classes = value;
      });
    });
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


    if (classes == null) {
      return new Center(
        child: CircularProgressIndicator(),
      );
    }

    return new Scaffold(

      backgroundColor: document.data['classType'] == "preschoolers" ? Color
          .fromRGBO(23, 142, 137, 1) :
      document.data['classType'] == "junior" ? Color.fromRGBO(127, 90, 64, 1) :
      document.data['classType'] == "advanced"
          ? Color.fromRGBO(143, 198, 79, 1)
          :
      Color.fromRGBO(23, 142, 137, 1),


      body: Stack(
          children: <Widget>[
            CustomPaint(
              painter: DrawTriangle(
                document.data['classType'] == "preschoolers" ? Color.fromRGBO(
                    53, 172, 167, 1) :
                document.data['classType'] == "junior" ? Color.fromRGBO(
                    157, 120, 94, 1) :
                document.data['classType'] == "advanced" ? Color.fromRGBO(
                    173, 228, 109, 1) :
                Color.fromRGBO(23, 142, 137, 1),


              ),
              size: Size(height / 5, width / 3),


            ),
            Positioned(
                right: width / 20,
                top: height / 20,
                child: Column(
                  children: <Widget>[
                    Container(
                        child: document.data['classType'] == "preschoolers"
                            ? Image.asset(
                          'lib/Assets/preschool.png', height: height / 10,)
                            :
                        document.data['classType'] == "junior" ? Image.asset(
                          'lib/Assets/junior.png', height: height / 10,) :
                        document.data['classType'] == "preschoolers" ? Image
                            .asset(
                          'lib/Assets/advanced.png', height: height / 10,) :
                        null
                    ),

                    Text(document.data['classType'] == "preschoolers"
                        ? "Preschool"
                        :
                    document.data['classType'] == "junior" ? "Junior" :
                    document.data['classType'] == "advanced" ? "Advanced" : "",
                      style: TextStyle(
                          fontSize: 27,
                          color: Colors.white
                      ),),


                  ],
                )
            ),


            Positioned(
              top: height / 5,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ImageEdit(picUrl, document)));
                  });
                },
                child:

                Container(
                  height: height / 1.3,
                  width: height / 1.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3000)),
                    color: Colors.white,

                  ),
                ),
              ),


            ),


            Positioned(
              top: height / 8,
              left: width / 3.3,
              child: selectPic == false ? Container() :

              GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ImageEdit(picUrl, document)));
                  });
                },
                child:
                Container(


                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: picUrl == null ? AssetImage(
                              "lib/Assets/defaultPro.jpg") : NetworkImage(
                              picUrl),
                          fit: BoxFit.cover
                      ),

                      borderRadius: BorderRadius.all(
                          Radius.circular(75.0)),
                      border: Border.all(width: 3, color: Colors.grey)
                  ),

                ),
              ),

            ),


            Positioned(
              top: height / 4.6,
              left: width / 2.1,
              child: selectPic == false ? Container() :
              Container(


                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    color: Colors.white,


                    borderRadius: BorderRadius.all(
                        Radius.circular(75.0)),
                    border: Border.all(width: 2, color: Colors.grey)
                ),
                child: Center(
                  child:

                  new IconButton(
                      icon: Icon(
                        Icons.add, color: Colors.grey,
                        size: 20,),
                      onPressed: () {
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ImageEdit(picUrl, document)));
                        });
                      }
                  ),
                ),

              ),

            ),


            Container(
                padding: EdgeInsets.only(top: height / 4),
                child: ListView(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: width / 10),
                            child: Text(
                              "${document.data['nickName']}'s Profile: ",
                              style: TextStyle(
                                  fontSize: 23
                              ),),
                          ),


                          SizedBox(
                            height: 10,
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              Text("Gender", style: TextStyle(
                                  fontSize: 18
                              ),),
                              SizedBox(
                                width: 46,
                              ),


                              GestureDetector(
                                onTap: () {
                                  if (gender == null) {
                                    setState(() {
                                      gender = false;
                                      genderChanged = true;
                                    });
                                  }

                                  else
                                    setState(() {
                                      gender = !gender;
                                    });
                                },
                                child:
                                Container(
                                    width: width / 4.3,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              15)),
                                      color: gender == false ? Colors
                                          .greenAccent : Color.fromRGBO(
                                          220, 220, 220, 1),
                                    ),
                                    child: Center(
                                      child: Text("MALE", style: TextStyle(
                                        fontFamily: 'Balsamiq',

                                      ),),
                                    )
                                ),
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              GestureDetector(
                                onTap: () {
                                  if (gender == null) {
                                    setState(() {
                                      gender = true;
                                      genderChanged = true;
                                    });
                                  }

                                  else
                                    setState(() {
                                      gender = !gender;
                                    });
                                },
                                child:
                                Container(
                                    width: width / 4.3,
                                    height: 37,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              15)),
                                      color: gender == true ? Colors
                                          .greenAccent : Color.fromRGBO(
                                          220, 220, 220, 1),
                                    ),
                                    child: Center(
                                      child: Text("FEMALE", style: TextStyle(
                                        fontFamily: 'Balsamiq',

                                      ),),
                                    )
                                ),
                              ),


                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),

                              Text("First Name", style: TextStyle(
                                  fontSize: 18
                              ),),
                              SizedBox(
                                width: 10,
                              ),

                              Container(
                                  width: width /1.9,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            15)),
                                    color: Color.fromRGBO(220, 220, 220, 1),
                                  ),

                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 15, bottom: 3),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),


                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Balsamiq'
                                        ),
                                        onChanged: (value) {
                                          changedName = true;
                                          firstName = value;
                                        },
                                      ),
                                    ),
                                  )


                              )


                            ],
                          ),


                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),

                              Text("Last Name", style: TextStyle(
                                  fontSize: 18
                              ),),
                              SizedBox(
                                width: 12,
                              ),

                              Container(
                                  width: width /1.9,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            15)),
                                    color: Color.fromRGBO(220, 220, 220, 1),
                                  ),

                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 15, bottom: 3),
                                      child: TextFormField(
                                        decoration: InputDecoration(

                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),


                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Balsamiq'
                                        ),
                                        onChanged: (value) {
                                          lastName = value;
                                        },
                                      ),
                                    ),
                                  )


                              )


                            ],
                          ),


                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),

                              Text("Birthday", style: TextStyle(
                                  fontSize: 18
                              ),),
                              SizedBox(
                                width: 33,
                              ),


                              GestureDetector(
                                  onTap: () {
                                    Future<
                                        DateTime> selectedDate = showDatePicker(

                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1970),
                                      lastDate: DateTime.now(),

                                    ).then((val) {
                                      setState(() {
                                        birthday =
                                            DateFormat('yyyy-MM-dd')
                                                .format(val);
                                      });
                                    });
                                  },
                                  child:
                                  Container(
                                    width: width /1.9,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              15)),
                                      color: Color.fromRGBO(220, 220, 220, 1),
                                    ),

                                    child: Center(
                                      child: Container(


                                          child: Row(
                                            children: <Widget>[

                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(birthday, style: TextStyle(
                                                  fontSize: 16
                                              ),),

                                              SizedBox(
                                                width: 60,
                                              ),

                                              Icon(
                                                Icons.edit,
                                                color: Colors.grey,
                                                size: 20,),

                                            ],
                                          )


                                      ),

                                    ),
                                  )


                              )


                            ],
                          ),


                          SizedBox(
                            height: 40,
                            child: ListTile(

                              title: Text("Classes", style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),),

                            ),
                          ),


                          Container(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            child:
                            Row(
                              children: <Widget>[
                                Text("${classes.documents[0].data['classDay']}",
                                  style: TextStyle(
                                      fontSize: 16
                                  ),),
                                SizedBox(
                                  width: 15,
                                ),
                                Text("${classes.documents[0]
                                    .data['classStartTime']}", style: TextStyle(
                                    fontSize: 16
                                ),),
                                SizedBox(
                                  width: 7,
                                ),
                                Text("-", style: TextStyle(
                                    fontSize: 16
                                ),),
                                SizedBox(
                                  width: 7,
                                ),
                                Text("${classes.documents[0]
                                    .data['classEndTime']}", style: TextStyle(
                                    fontSize: 16
                                ),),


                              ],
                            ),
                          ),


                          classes.documents.length == 2 ?
                          Container(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            child:
                            Row(
                              children: <Widget>[
                                Text("${classes.documents[1].data['classDay']}",
                                  style: TextStyle(
                                      fontSize: 16
                                  ),),
                                SizedBox(
                                  width: 15,
                                ),
                                Text("${classes.documents[1]
                                    .data['classStartTime']}", style: TextStyle(
                                    fontSize: 16
                                ),),
                                SizedBox(
                                  width: 7,
                                ),
                                Text("-", style: TextStyle(
                                    fontSize: 16
                                ),),
                                SizedBox(
                                  width: 7,
                                ),
                                Text("${classes.documents[1]
                                    .data['classEndTime']}", style: TextStyle(
                                    fontSize: 16
                                ),),


                              ],
                            ),
                          ) : Container(),


                          SizedBox(
                            height: 35,
                            child:
                            ListTile(

                              contentPadding: EdgeInsets.only(
                                  right: width / 6, left: 15),
                              title: Text("Allergies: ", style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),),
                              trailing: IconButton(
                                icon: Icon(Icons.add_circle, color: Colors
                                    .grey,),
                                onPressed: () {
                                  setState(() {
                                    alCount++;
                                  });
                                },
                              ),
                            ),
                          ),


                          SizedBox(
                            height: 15,
                          ),


                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: alCount,
                              itemBuilder: (BuildContext context, i) {
                                return new Column(
                                  children: <Widget>[


                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),

                                        Text("Allergy", style: TextStyle(
                                            fontSize: 18
                                        ),),
                                        SizedBox(
                                          width: width/10,
                                        ),

                                        Container(
                                            width: width/2,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      15)),
                                              color: Color.fromRGBO(
                                                  220, 220, 220, 1),
                                            ),

                                            child: Center(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 15, bottom: 3),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      icon: Icon(Icons.clear,
                                                        color: Colors.grey,),
                                                      onPressed: () {
                                                        setState(() {
                                                          alCount--;
                                                        });
                                                      },
                                                    ),

                                                    border: InputBorder.none,
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
                                                      fontSize: 18,
                                                      fontFamily: 'Balsamiq'
                                                  ),
                                                  onChanged: (value) {
                                                    allergies[i] = value;
                                                  },

                                                ),
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                );
                              }),


                        ],
                      ),
                    ]
                )
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Center(
                child: Container(

                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      border: Border.all(width: 5, color: Colors.white)
                  ),
                  child:
                  IconButton(
                    onPressed: () async {
                      if (firstName == null || lastName == null ||
                          birthday == null) {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                    return new AlertDialog(
                                      title: Center(
                                        child: Text(
                                            "Please, fill in all the information"),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },

                                          child: Text("OK", style: TextStyle(
                                              color: Colors.blue
                                          ),),
                                        )
                                      ],
                                    );
                                  });
                            });
                      }

                      else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                    return new AlertDialog(
                                        title: Center(
                                            child: CircularProgressIndicator()
                                        )

                                    );
                                  });
                            });


                        if (genderChanged != null) {
                          if (gender == false) {
                            UserManagement.updateStudentGender("male", document
                                .documentID);
                          }
                          if (gender == true) {
                            UserManagement.updateStudentGender(
                                "female", document.documentID);
                          }
                        }
                        UserManagement.updateFirstNameStudent(
                            firstName, document.documentID);
                        UserManagement.updateLastNameStudent(
                            lastName, document.documentID);
                        UserManagement.updateBirthdayStudent(
                            birthday, document.documentID);
                        await UserManagement.updateProfilePictureStudent(
                            picUrl, document.documentID);

                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        user = await FirebaseAuth.instance.currentUser();


                        Navigator.push(
                            context, MaterialPageRoute(builder: (
                            BuildContext context) => MyChild(user)));
                      }
                    },

                    icon: Icon(Icons.arrow_forward_ios, color: Colors.white,
                      size: 35,),
                  ),
                ),
              ),
            )
          ]
      ),

    );
  }
}

class ImageEdit extends StatefulWidget{
  ImageEdit(this.picUrl, this.document);


  final picUrl;
  final document;


  @override
  _ImageEditState createState() => _ImageEditState(this.picUrl,this.document);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.picUrl, this.document);

  final picUrl;
  final document;


  File _imageFile;

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    selected = await ImageCropper.cropImage(
        sourcePath: selected.path,
        aspectRatio: CropAspectRatio(ratioY: 300, ratioX: 300,),
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
        aspectRatio: CropAspectRatio(ratioY: 300, ratioX: 300,),
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
          backgroundColor: Colors.black,


          body: _imageFile == null ?

          Container(

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                child: Container(

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
                ),
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
                      height: 200,
                      width: 200,
                      child: CircleAvatar(

                        backgroundImage: FileImage(_imageFile),

                      )
                  )
              ),

              SizedBox(
                height: 50,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.crop, size: 50, color: Colors.white,),
                    onPressed: _cropImage,
                  ),
                  FlatButton(
                    child: Icon(Icons.refresh, size: 50, color: Colors.white,),
                    onPressed: _clear,
                  ),
                  FlatButton(
                    child: Icon(Icons.file_upload, size: 50, color: Colors.white,),
                    onPressed: () async {
                      wait = true;
                      filePath = 'childProfile/${document.documentID}.png';


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
                                        ChildInfo(document, downloadUrl)));
                    },
                  )
                ],
              ),
            ],
          )
      );
}




class DrawTriangle extends CustomPainter {
  Paint _paint;

  DrawTriangle(color) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size,) {
    var path = Path();
    path.moveTo(size.height, 0);
    path.lineTo(0, size.width);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}



