import 'dart:ui';
import 'package:buildabrain/welcomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../Parent/ChildInfo.dart';
import 'ownerHome.dart';
import '../main.dart';
import '../services/userManagement.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;


class LeaderSignup extends StatefulWidget {

  LeaderSignup( this.name, this.picUrl);
  final picUrl;

  final name;

  @override

  _LeaderSignupState createState() => _LeaderSignupState( this.name, this.picUrl);
}

class _LeaderSignupState extends State<LeaderSignup> {
  _LeaderSignupState(this.name, this.picUrl);

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


  Future<String> makeRequest() async {
    File qr;
    var uri = (Uri.parse("https://pierre2106j-qrcode.p.rapidapi.com/api")
    );
    var response1;

    response1 = await http.get(uri.replace(queryParameters: <String, String>{
      "backcolor": "ffffff",
      "pixel": "9",
      "ecl": "L %7C M%7C Q %7C H",
      "forecolor": "000000",
      "type": "text %7C url %7C tel %7C sms %7C email",
      "text": user.uid,


    },), headers: {
      "x-rapidapi-host": "pierre2106j-qrcode.p.rapidapi.com",
      "x-rapidapi-key": "f9f7a1b65fmsh8040df99eaf90e5p164474jsn2ed53a118bcd"
    });

    File file = await DefaultCacheManager().getSingleFile(response1.body);
    var time = DateTime.now();
    StorageUploadTask task;
    print("File: ${file}");

    setState(() {
      final StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('teacherQrCodes/${time}.png');
      task = firebaseStorageRef.putFile(file);
    });



    StorageTaskSnapshot snapshot = await task.onComplete;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    await UserManagement.updateTeacherQrCode(downloadUrl).then((val) {

    });
    Future.delayed(Duration(seconds: 8)).then((value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (
              route) => false);
    });
  }

  bool status;
  String parent;

  QuerySnapshot userFinal;


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((users) {
      setState(() {
        picUrl = users.photoUrl;
        user = users;
        currentUid = users.uid;

        Firestore.instance.collection('users')
        .where('uid', isEqualTo: users.uid)
        .getDocuments()
        .then((value) {
          setState(() {
            userFinal = value;
          });
        });
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
                                "Leader's Information: ", style: TextStyle(
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
                            || _number == null ){
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

                          UserManagement.updateLastName(
                              lastName);
                          UserManagement.updateBirthday(
                              birthday);
                          UserManagement.updateNumber(
                              _number);
                          await UserManagement.updateProfilePicture(
                              picUrl);

                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
                              BuildContext context) =>  OwnerHome(userFinal, 0)), (route) => false);

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

                      filePath = 'leaderProfile/${user.uid}.png';
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
                                  LeaderSignup(name, downloadUrl)));




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

