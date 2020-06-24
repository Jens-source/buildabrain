import 'dart:io';
import 'dart:ui';

import 'package:buildabrain/main.dart';
import 'package:buildabrain/selectprofilepic.dart';
import 'package:buildabrain/services/userManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';



enum SingingCharacter { male, female }


SingingCharacter _character = SingingCharacter.male;



class AddChild extends StatefulWidget {


  AddChild(this.motherUid, this.fatherUid, this.profilePic);

  final motherUid;
  final fatherUid;
  final profilePic;

  @override

  _AddChildState createState() => _AddChildState(this.motherUid, this.fatherUid, this.profilePic);
}

class _AddChildState extends State<AddChild> {

  _AddChildState(this.motherUid, this.fatherUid, this.profilePic);

  final profilePic;

  final motherUid;
  final fatherUid;

  var firstName;
  var lastName;
  var nickName;
  var mother;
  var father;
  var allergies;
  var birthday;
  var school;
  var gender = "male";
  String picUrl = 'https://i.stack.imgur.com/34AD2.jpg';
  bool backdrop = true;
  var qrCode;

  String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  File qr;


  Future<String> findChildfromMother(motherId) async {
    print("Mother Uid: ${motherId}");
    await Firestore.instance.collection('students')
        .where('motherUid', isEqualTo: motherId)
        .getDocuments()
        .then((docs) {

          for(int i = 0; i < docs.documents.length; i++)
            {
              if(docs.documents[i].data["qrCodeUrl"] == 0)
                {
                  makeRequestMother(docs.documents[i].documentID);
                }
            }




    });
  }

  Future<String> findChildfromFather(fatherId) async {
    await Firestore.instance.collection('students')
        .where('fatherUid', isEqualTo: fatherId)
        .getDocuments()
        .then((docs) {

      for(int i = 0; i < docs.documents.length; i++)
      {
        if(docs.documents[i].data["qrCodeUrl"] == 0)
        {
          makeRequestFather(docs.documents[i].documentID);
        }
      }
    });
  }

  Future<String> makeRequestFather(studentID) async {
    File qr;
    var uri = (Uri.parse("https://pierre2106j-qrcode.p.rapidapi.com/api")
    );
    var response1;


    print("StudentID ${studentID}");
    response1 = await http.get(uri.replace(queryParameters: <String, String>{

      "backcolor": "ffffff",
      "pixel": "9",
      "ecl": "L %7C M%7C Q %7C H",
      "forecolor": "000000",
      "type": "text %7C url %7C tel %7C sms %7C email",
      "text": studentID,


    },), headers: {
      "x-rapidapi-host": "pierre2106j-qrcode.p.rapidapi.com",
      "x-rapidapi-key": "f9f7a1b65fmsh8040df99eaf90e5p164474jsn2ed53a118bcd"
    });


//    print("response.body: ${response1.body}");
//    var cacheManager = await CacheManager.getInstance();
//    File file = await cacheManager.getFile(response1.body);
//    var time = DateTime.now();
//    StorageUploadTask task;
//    print("File: ${file}");
//
//
//      final StorageReference firebaseStorageRef =
//      FirebaseStorage.instance.ref().child('studentQrCodes/${time}.png');
//      task = firebaseStorageRef.putFile(file);
//


//    StorageTaskSnapshot snapshot = await task.onComplete;
//    String downloadUrl = await snapshot.ref.getDownloadURL();
//    await UserManagement.updateProfilePictureFirstFather(downloadUrl);
  }


  Future<String> makeRequestMother(studentID) async {
    File qr;
    var uri = (Uri.parse("https://pierre2106j-qrcode.p.rapidapi.com/api")
    );
    var response1;


    print("StudentID ${studentID}");
    response1 = await http.get(uri.replace(queryParameters: <String, String>{

      "backcolor": "ffffff",
      "pixel": "9",
      "ecl": "L %7C M%7C Q %7C H",
      "forecolor": "000000",
      "type": "text %7C url %7C tel %7C sms %7C email",
      "text": studentID,


    },), headers: {
      "x-rapidapi-host": "pierre2106j-qrcode.p.rapidapi.com",
      "x-rapidapi-key": "f9f7a1b65fmsh8040df99eaf90e5p164474jsn2ed53a118bcd"
    });


//    print("response.body mother: ${response1.body}");
//    var cacheManager = await CacheManager.getInstance();
//    File file = await cacheManager.getFile(response1.body);
//    var time = DateTime.now();
//    StorageUploadTask task;
//    print("File: ${file}");
//
//
//
//
//      final StorageReference firebaseStorageRef =
//      FirebaseStorage.instance.ref().child('studentQrCodes/${time}.png');
//      task = firebaseStorageRef.putFile(file);





//    StorageTaskSnapshot snapshot = await task.onComplete;
//    String downloadUrl = await snapshot.ref.getDownloadURL();
//    print("DownloadUrl: ${downloadUrl}");
//
//      await UserManagement.updateProfilePictureFirstMother(downloadUrl).then((ef){
//        print("Hellooooo");
//      });


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      FirebaseAuth.instance.currentUser().then((val){
        print(val.uid);
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
        body: new Stack(
          children: <Widget>[

            backdrop == true ? Container() : Container(
                width: width,
                height: height,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                  child: Container(
                    child: Center(
                      child:
                      CircularProgressIndicator(),

                    ),
                    color: Colors.black.withOpacity(0.2),
                  ),
                )
            ),


            new ListView(
              children: <Widget>[
                Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Child Detail", style: TextStyle(
                          fontSize: 25,
                          color: Colors.blueAccent
                      ),),)
                ),
                SizedBox(
                  height: 30,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(

                        width: 100,

                        height: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: profilePic == 0 ? NetworkImage(
                                  picUrl) : NetworkImage(profilePic),
                              colorFilter: ColorFilter.mode(
                                  Colors.black54, BlendMode.darken),
                              fit: BoxFit.cover
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        ),
                        child: new IconButton(
                            icon: Icon(
                              Icons.add_a_photo, color: Colors.white,
                              size: 30,),
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return ImageEdit(
                                            picUrl, motherUid, fatherUid);
                                      }
                                  )
                              );
                            }
                        )
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),


                Container(


                  height: 35,
                  child: ListTile(
                    leading: Text("First Name"),
                    title: TextField(

                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.child_care),
                          border: OutlineInputBorder()
                      ),
                      onChanged: (value) {
                        firstName = value;
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Container(


                  height: 35,
                  child: ListTile(
                    leading: Text("Last Name"),
                    title: TextField(

                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.child_care),
                          border: OutlineInputBorder()
                      ),
                      onChanged: (value) {
                        lastName = value;
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Container(


                  height: 35,
                  child: ListTile(
                    leading: Text("Nickname"),
                    title: Container(
                      padding: EdgeInsets.only(left: 5),
                      child:
                      TextField(

                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.child_care),
                            border: OutlineInputBorder()
                        ),
                        onChanged: (value) {
                          nickName = value;
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                ListTile(
                  leading: Text("Birthday"),
                  title: Text(startDate, style: TextStyle(
                      color: Colors.grey
                  ),),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Future<DateTime> selectedDate = showDatePicker(

                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2005),
                        lastDate: DateTime.now(),

                      ).then((val) {
                        setState(() {
                          startDate =
                              DateFormat('yyyy-MM-dd').format(val);
                        });
                      });
                    },
                  ),

                ),

                SizedBox(
                  height: 30,
                ),

                new Row(

                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.only(left: 15, right: 50),
                      child: Text("Gender"),
                    ),


                    new Text(
                      'Male',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                        value: SingingCharacter.male,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                            gender = "male";
                          });
                        }),

                    new Text(
                      'Female',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                        value: SingingCharacter.female,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                            gender = "female";
                          });
                        }),
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 270,
                        height: 40,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color.fromRGBO(81, 113, 100, 0.6),
                        ),
                        child: OutlineButton(
                          child: Center(
                              child: Text('Add another child',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  )
                              )
                          ),
                          onPressed: () {
                            if (motherUid == 0) {
                              setState(() {
                                UserManagement.addChild(
                                    fatherUid,
                                    0,
                                    firstName,
                                    lastName,
                                    nickName,
                                    startDate,
                                    gender, 0, 0, 0, 0, 0).then((vn){
                                  findChildfromFather(fatherUid);



                                }   );



                              });


                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return AddChild(
                                            motherUid, fatherUid, 0);
                                      }
                                  )
                              );


                              Navigator.of(context).pop();

                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return AddChild(
                                            motherUid, fatherUid, 0);
                                      }
                                  )
                              );
                            }
                            else if (fatherUid == 0) {
                              setState(() {
                                UserManagement.addChild(
                                    0,
                                    motherUid,
                                    firstName,
                                    lastName,
                                    nickName,
                                    startDate,
                                    gender, 0, 0, 0, 0, 0).then((vn){
                                  findChildfromMother(motherUid);



                                }   );



                              });


                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return AddChild(
                                            motherUid, fatherUid, 0);
                                      }
                                  )
                              );
                            }

                            else {
                              setState(() {
                                UserManagement.addChild(
                                    fatherUid,
                                    motherUid,
                                    firstName,
                                    lastName,
                                    nickName,
                                    startDate,
                                    gender, 0, 0, 0, 0, 0).then((vn){

                                      print(motherUid);
                                  findChildfromMother(motherUid);



                                }   );



                              });


                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return AddChild(
                                            motherUid, fatherUid, 0);
                                      }
                                  )
                              );
                            }
                          },
                        )
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 270,
                        height: 40,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color.fromRGBO(81, 113, 100, 0.6),
                        ),
                        child: OutlineButton(
                          child: Center(
                              child: Text('Finish',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  )
                              )
                          ),
                          onPressed: () {
                            if (motherUid == 0) {
                              setState(() {
                                backdrop = false;
                                UserManagement.addChild(
                                    fatherUid,
                                    0,
                                    firstName,
                                    lastName,
                                    nickName,
                                    startDate,
                                    gender, 0, 0, 0, 0, 0).then((vso) {
                                  findChildfromFather(fatherUid);
                                  UploaderChild(file: qr,
                                    motherUid: 0,
                                    fatherUid: fatherUid,);


                                  Future.delayed(Duration(seconds: 7));
                                });
                              });


                              Container(


                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 0.0, sigmaY: 0.1),
                                    child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        child: Center(
                                          child: Container(
                                              height: 100,
                                              child: Center(
                                                child: Text("Please wait",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),),
                                              )
                                          ),
                                        )
                                    )
                                ),
                              );
                              Future.delayed(Duration(seconds: 7)).then((val) {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) {
                                          return MyHomePage();
                                        }
                                    )
                                );
                              });
                            }
                            else if (fatherUid == 0) {
                              setState(() {
                                backdrop = false;
                                UserManagement.addChild(
                                    0,
                                    motherUid,
                                    firstName,
                                    lastName,
                                    nickName,
                                    startDate,
                                    gender, 0, 0, 0, 0, 0).then((vso) {
                                  findChildfromMother(motherUid);
                                  UploaderChild(file: qr,
                                    fatherUid: 0,
                                    motherUid: motherUid,);


                                  Future.delayed(Duration(seconds: 7));
                                });
                              });


                              Container(


                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 1, sigmaY: 1),
                                    child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        child: Center(
                                          child: Container(
                                              height: 100,
                                              child: Center(
                                                child: Text("Please wait",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),),
                                              )
                                          ),
                                        )
                                    )
                                ),
                              );
                              Future.delayed(Duration(seconds: 7)).then((val) {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) {
                                          return MyHomePage();
                                        }
                                    )
                                );
                              });
                            }

                            else {
                              setState(() {
                                backdrop = false;
                                UserManagement.addChild(
                                    fatherUid,
                                    motherUid,
                                    firstName,
                                    lastName,
                                    nickName,
                                    startDate,
                                    gender, 0, 0, 0, 0, 0).then((vso) {
                                 findChildfromMother(motherUid);
                                  UploaderChild(file: qr,
                                    motherUid: motherUid,
                                    fatherUid: 0,);

                                  Future.delayed(Duration(seconds: 7));
                                });
                              });


                              Container(


                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 1, sigmaY: 1),
                                    child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        child: Center(
                                          child: Container(
                                              height: 100,
                                              child: Center(
                                                child: Text("Please wait",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),),
                                              )
                                          ),
                                        )
                                    )
                                ),
                              );
                              Future.delayed(Duration(seconds: 4)).then((val) {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) {
                                          return MyHomePage();
                                        }
                                    )
                                );
                              });
                            }
                          },
                        )
                    )
                  ],
                )


              ],


            ),
          ],
        )
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
  ImageEdit(this.picUrl, this.motherUid, this.fatherUid);
  final motherUid;
  final fatherUid;
  final picUrl;

  @override
  _ImageEditState createState() => _ImageEditState(this.picUrl, this.motherUid, this.fatherUid);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.picUrl, this.motherUid, this.fatherUid);
  final picUrl;
  final motherUid;
  final fatherUid;
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

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
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 512, maxHeight: 512);
    setState(() {

      _imageFile = tempImage;

    });

    _cropImage();
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
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
                      filePath = 'studentImage/${DateTime.now()}.png';


                      setState(() {
                        _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);

                      });


                      StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
                      String downloadUrl =  await snapshot.ref.getDownloadURL();












                        Future.delayed(Duration(seconds: 1)).then((val) {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                     AddChild(motherUid, fatherUid, downloadUrl)));
                        });



                    },
                  )
                ],
              ),
            ],
          )
      );
}


class UploaderChild extends StatefulWidget {
  final File file;
  final fatherUid;
  final motherUid;

  UploaderChild({Key key, this.file, this.motherUid, this.fatherUid}) : super(key: key);

  createState() => _UploaderChildState(this.file, this.motherUid, this.fatherUid);
}

class _UploaderChildState extends State<UploaderChild> {
  _UploaderChildState(this.file, this.motherUid, this.fatherUid);

  final file;
  final motherUid;
  final fatherUid;


  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://buildabrain-a8cce.appspot.com/');

  StorageUploadTask _uploadTask;
  String filePath;
  String filePaths;

  void _startUpload() async {
    filePath = 'studentQrImages/${DateTime.now()}.png';


    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
    String downloadUrl = await snapshot.ref.getDownloadURL();


  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {


    });
  }


  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: <Widget>[
                if(_uploadTask.isComplete)
                  Stack(
                    children: <Widget>[
                      FlatButton(
                          child: Icon(Icons.add, color: Colors.white,),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                      )
                    ],
                  ),


                if(_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow, color: Colors.white,),
                    onPressed: _uploadTask.resume,
                  ),

                if(_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                LinearProgressIndicator(value: progressPercent),
                Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} %'
                )
              ],
            );
          });
    } else {
      return FlatButton.icon(
        label: Text(
          'Upload to firebase', style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.cloud_upload, color: Colors.white,),
        onPressed: _startUpload,
      );
    }
  }
}