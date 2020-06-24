import 'dart:ui';

import 'package:buildabrain/ParentHome.dart';
import 'package:buildabrain/welcomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'ChildInfo.dart';
import 'services/userManagement.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';





class ParentSignup extends StatefulWidget {

  ParentSignup( this.name, this.picUrl);
  final picUrl;

  final name;

  @override

  _ParentSignupState createState() => _ParentSignupState( this.name, this.picUrl);
}

class _ParentSignupState extends State<ParentSignup> {
  _ParentSignupState( this.name, this.picUrl);

  String name;




  bool backdrop = true;

  bool changedName = false;

  File newProfilePic;
  String _name;
  String picUrl;
  String dropdownValue = 'Mother';
  String dropdownInclude = 'No';
  String _number;
  String _street;
  String _add1;
  String _add2;
  String _district;
  String _province;
  String _zip;
  String _partnerName;
  String _partnerEmail;
  String _partnerNUmber;
  String partnerUid;
  String currentUid;
  bool selectPic = true;
  String firstName;
  String lastName;
  String about;
  FirebaseUser user;
  String birthday = DateFormat('yyy-MM-dd').format(DateTime.now());



  bool status;
  String parent;


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((users) {
      setState(() {
        picUrl = users.photoUrl;
        user = users;
        currentUid = users.uid;


        print(user.photoUrl);
      });
    }).catchError((e) {
      print(e);
    });
  }


  Future<bool> _onBackPressed() async {
    showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
          content: Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )

      ),
    );


    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance.collection('users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((value) {
      Firestore.instance.document("users/${value.documents[0].documentID}")
          .delete();
    });

    await user.delete();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => WelcomePage()), (
            route) => false);
  }


  UserManagement userManagement = new UserManagement();

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

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(

          backgroundColor: Color.fromRGBO(23, 142, 137, 1),
          body: Stack(


              children: <Widget>[


                CustomPaint(
                  painter: DrawTriangle(),
                  size: Size(height / 5, width / 3),
                ),

                Positioned(
                  right: width / 20,
                  top: height / 10,
                  child: Text("CREATE  \nACCOUNT", style: TextStyle(
                      fontSize: 27,
                      color: Colors.white
                  ),),
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
                                    ImageEdit(picUrl, name)));
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
                                    ImageEdit(picUrl, name)));
                      });
                    },
                    child:
                    Container(


                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: picUrl != null ? NetworkImage(
                                  picUrl) : AssetImage("lib/Assets/defaultPro.jpg"),
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
                                          ImageEdit(picUrl, name)));
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
                          "Parent's Information: ", style: TextStyle(
                            fontSize: 23
                        ),),
                      ),


                      SizedBox(
                        height: 5,
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Text("Status", style: TextStyle(
                              fontSize: 18
                          ),),
                          SizedBox(
                            width: 46,
                          ),



                          GestureDetector(
                            onTap: (){
                              if(status == null){
                                setState(() {
                                  status = true;
                                  parent = "Mother";
                                });

                              }

                              else
                                setState(() {
                                  status = !status;

                                });
                            },
                            child:
                          Container(
                            width: width / 4.3,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  15)),
                              color: status == true ? Colors.greenAccent : Color.fromRGBO(220, 220, 220, 1),
                            ),
                            child: Center(
                              child: Text("MOTHER", style: TextStyle(
                                fontFamily: 'Balsamiq',

                              ),),
                            )
                          ),
                          ),

                          SizedBox(
                            width: 10,
                          ),

                          GestureDetector(
                            onTap: (){
                              if(status == null){
                                setState(() {
                                  status = false;
                                  parent = "Father";
                                });

                              }

                              else
                                setState(() {
                                  status = !status;

                                });
                            },
                            child:
                            Container(
                                width: width / 4.3,
                                height: 37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      15)),
                                  color: status == false ? Colors.greenAccent : Color.fromRGBO(220, 220, 220, 1),
                                ),
                                child: Center(
                                  child: Text("FATHER", style: TextStyle(
                                    fontFamily: 'Balsamiq',

                                  ),),
                                )
                            ),
                          ),










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

                          Text("First Name", style: TextStyle(
                              fontSize: 18
                          ),),
                          SizedBox(
                            width: 10,
                          ),

                          Container(
                              width: width - 200,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    15)),
                                color: Color.fromRGBO(220, 220, 220, 1),
                              ),

                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, bottom: 3),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),

                                    initialValue: name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Balsamiq'
                                    ),
                                    onChanged: (value) {
                                      changedName = true;
                                      name = value;
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
                              width: width - 200,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    15)),
                                color: Color.fromRGBO(220, 220, 220, 1),
                              ),

                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, bottom: 3),
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
                            onTap: (){

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
                              width: width - 200,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
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
                                            Icons.edit, color: Colors.grey,
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
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),

                          Text("Phone", style: TextStyle(
                              fontSize: 18
                          ),),
                          SizedBox(
                            width: 48,
                          ),

                          Container(
                              width: width - 200,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    15)),
                                color: Color.fromRGBO(220, 220, 220, 1),
                              ),

                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, bottom: 3),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
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
                                      _number = value;
                                    },
                                  ),
                                ),
                              )


                          )


                        ],
                      ),


                      Row(
                        children: <Widget>[


                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text("Address: ", style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ],
                      ),


                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),

                          Text("Street", style: TextStyle(
                              fontSize: 18
                          ),),
                          SizedBox(
                            width: 50,
                          ),

                          Container(
                              width: width - 200,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    15)),
                                color: Color.fromRGBO(220, 220, 220, 1),
                              ),

                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, bottom: 3),
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
                                      _street = value;
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

                          Text("District", style: TextStyle(
                              fontSize: 18
                          ),),
                          SizedBox(
                            width: 42,
                          ),

                          Container(
                              width: width - 200,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    15)),
                                color: Color.fromRGBO(220, 220, 220, 1),
                              ),

                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, bottom: 3),
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
                                      _district = value;
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

                          Text("Province", style: TextStyle(
                              fontSize: 18
                          ),),
                          SizedBox(
                            width: 30,
                          ),

                          Container(
                              width: width - 200,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    15)),
                                color: Color.fromRGBO(220, 220, 220, 1),
                              ),

                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, bottom: 3),
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
                                      _province = value;
                                    },
                                  ),
                                ),
                              )


                          )


                        ],
                      ),



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
                        if(name == null || lastName == null || birthday == null
                        || _number == null || _street == null || _district == null
                        || _province == null || status == null){
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                      return new AlertDialog(
                                        title: Center(
                                          child: Text("Please, fill in all the information"),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: (){
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

                        else{
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

                           if(changedName == true){

                              UserManagement.updateFirstName(name);
                           }

                           UserManagement.updateStatus(parent);
                            UserManagement.updateLastName(
                               lastName);
                            UserManagement.updateBirthday(
                               birthday);
                            UserManagement.updateNumber(
                               _number);
                            UserManagement.updateStreet(_street);
                            UserManagement.updateDistrict(
                               _district);
                            UserManagement.updateProvince(
                               _province);
                           await UserManagement.updateProfilePicture(
                               picUrl);

                           Navigator.of(context).pop();
                           Navigator.push(context,
                               MaterialPageRoute(
                                   builder: (BuildContext context) =>
                                     MyChild(parent)));

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
      ),

    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ImageEdit extends StatefulWidget{
  ImageEdit(this.picUrl, this.name);
  final name;

  final picUrl;

  @override
  _ImageEditState createState() => _ImageEditState(this.picUrl,  this.name);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.picUrl,  this.name);
  final name;
  final picUrl;

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
                      FirebaseUser user = await FirebaseAuth.instance.currentUser();

                      filePath = 'parentProfile/${user.uid}.png';
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
                                      ParentSignup(name, downloadUrl)));




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

  DrawTriangle() {
    _paint = Paint()
      ..color = Color.fromRGBO(53, 172, 167, 1)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
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



class MyChild extends StatefulWidget {
  MyChild(this.parent);
  final parent;


  @override
  _MyChildState createState() => _MyChildState(this.parent);
}

class _MyChildState extends State<MyChild>
    with SingleTickerProviderStateMixin {

  _MyChildState(this.parent);
  final parent;


  List <DocumentSnapshot> children = [];
  bool loading;


  bool noChild = false;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('users').where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance.collection(
            'users/${docs.documents[0].documentID}/children')
            .getDocuments()
            .then((childDocs) async {
              if(childDocs.documents.length != 0){
               for(int i = 0; i < childDocs.documents.length; i++){
                 await Firestore.instance.document("students/${childDocs.documents[i].data['childId']}")
                     .get()
                     .then((value) {
                       setState(() {
                         children.add(value);
                       });

                 });
               }

               setState(() {
                 noChild = false;
                 loading = true;
               });

              }
              else{
                setState(() {
                  noChild = true;
                  loading = true;
                });
              }


        }).catchError((error) {
          print(error);
          setState(() {
            noChild = true;
            loading = true;
          });
        });
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
    // TODO: implement build


    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("My Children", style: TextStyle(
            fontFamily: "Balsamiq"
          ),),
        ),

        body: loading == null ?
        Center(
          child: Container(
            padding: EdgeInsets.only(top: height / 2),
            child:

            CircularProgressIndicator(),
          ),
        ) :
        Stack(
          children: <Widget>[


        new ListView(
          children: <Widget>[



            noChild == true ?
            Center(
                child: Container(
                    padding: EdgeInsets.only(top: 20),
                    child:
                    Center(
                        child:
                        Text("Please, add a child", style: TextStyle(
                          fontSize: 25,

                        ),)
                    ))) : Container(),

            noChild == true ?
            Center(
                child: Container(
                  padding: EdgeInsets.only(top: height / 10),
                    child:
                    Center(
                      child:
                      Image.asset('lib/Assets/noChildren.png'),


                    ))) : Container(),


            new ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: children == null ? 0 : children.length,
                itemBuilder: (BuildContext context, i) {
                  return new Container(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      color: children[i].data['gender'] == "female" ? Color.fromRGBO(247, 207, 230, 1):
                        Color.fromRGBO(205, 244, 218, 1),
                      child: ListTile(
                        title: Text("${children[i].data['firstName'].toString() } ${children[i].data['lastName'].toString() }"),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(children[i].data['photoUrl'].toString()),

                        ),
                        subtitle: Text(children[i].data['classType']),

                      ),
                    ),
                  );
                }),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),

                GestureDetector(
                  onTap: ()async {
                    showDialog(
                      context: context,
                      builder: (context) =>
                      new AlertDialog(
                          content: Container(
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )

                      ),
                    );
                    DocumentSnapshot child;
                    FirebaseUser user = await FirebaseAuth.instance.currentUser();
                    String childId = await scanner.scan();
                    if(parent == "Mother"){
                      await Firestore.instance.document('students/${childId}')
                      .get()
                      .then((value) async {
                        child = value;
                        if(value.data['motherUid'] == 0){
                          Firestore.instance.document('students/${childId}')
                              .updateData({
                            "motherUid" : user.uid
                          });
                        }

                        else {
                          Navigator.of(context).pop();
                          await showDialog(
                            context: context,
                            builder: (context) =>
                            new AlertDialog(
                                title:  Center(
                                      child: Text("Child already added")
                                  ),

                              actions: <Widget>[
                                FlatButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK", style: TextStyle(
                                    color: Colors.blue
                                  ),)
                                )
                              ],


                            ),
                          );
                        }
                      });

                    }

                    if(parent == "Father"){

                      await Firestore.instance.document('students/${childId}')
                          .get()
                          .then((value) async {
                        if(value.data['fatherUid'] == 0){
                          Firestore.instance.document('students/${childId}')
                              .updateData({
                            "fatherUid" : user.uid
                          });
                        }

                        else {
                          Navigator.of(context).pop();
                          await showDialog(
                            context: context,
                            builder: (context) =>
                            new AlertDialog(
                              title:  Center(
                                  child: Text("Child already added")
                              ),

                              actions: <Widget>[
                                FlatButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK", style: TextStyle(
                                        color: Colors.blue
                                    ),)
                                )
                              ],


                            ),
                          );
                        }
                      });

                    }

                   await  FirebaseAuth.instance.currentUser().then((user){
                       Firestore.instance.collection('users')
                          .where('uid', isEqualTo: user.uid)
                           .getDocuments()
                           .then((docs) {
                             Firestore.instance.collection('users/${docs.documents[0].documentID}/children')
                                 .add({
                                    'childId': childId,
                             });
                       });
                    });

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChildInfo(child, null)));


                  },


                    child:
                    Container(
                      height: 40,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(3, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.blue
                      ),
                      child: Center(
                        child:  Text(noChild == true ? "SCAN QR-CODE": "ADD MORE" , style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),),
                      )
                    )
                ),

                SizedBox(
                  height: 15,
                ),


                noChild == false ?
                GestureDetector(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
                        BuildContext context) => ParentHome()), (route) => false);
                  },
                  child:
                Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(3, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.green
                    ),
                    child: Center(
                      child:  Text("FINISH" , style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                      ),),
                    )
                )
                ): null

              ],
            )

          ],
        ),
          ],
        )
    );
  }
}







