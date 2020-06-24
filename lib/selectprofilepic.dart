import 'dart:ui';

import 'package:buildabrain/addChild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';
import 'services/userManagement.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';


class SelectprofilepicPage extends StatefulWidget {

  SelectprofilepicPage(this.email, this.password);

  final email;
  final password;




  @override

  _SelectprofilepicPageState createState() => _SelectprofilepicPageState(this.email, this.password);
}

class _SelectprofilepicPageState extends State<SelectprofilepicPage> {
  _SelectprofilepicPageState(this.email, this.password,);

  final email;
  final password;

  bool backdrop = true;


  File newProfilePic;
  String _firstName;
  String _lastName;
  String picUrl;
  String dropdownValue = 'Mother';
  String dropdownInclude = 'No';
  String _number;
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


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        picUrl = user.photoUrl;
        currentUid = user.uid;
        print(email);


        print(user.photoUrl);
      });
    }).catchError((e) {
      print(e);
    });
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
    if (picUrl == null) {
      picUrl = 'https://i.stack.imgur.com/34AD2.jpg';
    }

    return new Scaffold(

        body: Stack(
            children: <Widget>[


              backdrop == true ? Container() : Container(
                  width: width,
                  height: height,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: Container(
                      child: Center(
                        child:
                        CircularProgressIndicator(),

                      ),
                      color: Colors.black.withOpacity(0.4),
                    ),
                  )
              ),


              ListView(
                children: <Widget>[


                  Center(
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(top: 100, bottom: 20),
                              child: Text(
                                " Let's setup your profile", style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold
                              ),)
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 80, right: 80),
                              child: Center(
                                  child:
                                  Text(
                                    " Make it easier for your friends to find ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54
                                    ),))
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 80, right: 80, bottom: 30),
                              child: Center(
                                  child:
                                  Text(
                                    "and connect with you on Buildabrain",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54
                                    ),))
                          ),
                          selectPic == false ? Container() : Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        picUrl),
                                    colorFilter: ColorFilter.mode(
                                        Colors.black54, BlendMode.darken),
                                    fit: BoxFit.cover
                                ),

                                borderRadius: BorderRadius.all(
                                    Radius.circular(75.0)),
                              ),
                              child: new IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo, color: Colors.white,
                                    size: 30,),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ImageEdit(picUrl, email,
                                                      password)));
                                    });
                                  }
                              )
                          ),

                          Container(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Text(
                              "Parent Information: ", style: TextStyle(
                                fontSize: 20
                            ),),
                          ),
                          Row(
                            children: <Widget>[

                              Container(
                                padding: EdgeInsets.only(left: 30, right: 47,),
                                child: Text("What are you of your child?"),
                              ),

                              Container(
                                  height: 30,


                                  color: Colors.black12,
                                  child:

                                  DropdownButton<String>(


                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 0,
                                    style: TextStyle(
                                        color: Colors.black
                                    ),

                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: <String>['Mother', 'Father']
                                        .map<DropdownMenuItem<String>>((
                                        String value) {
                                      return DropdownMenuItem<String>(

                                        value: value,
                                        child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(value)),
                                      );
                                    })
                                        .toList(),

                                  )
                              )
                            ],
                          ),
                          ListTile(
                            leading: new Text("First name"),
                            title: Container(
                              height: 30,
                              child:
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  _firstName = value;
                                },

                              ),

                            ),
                          ),
                          ListTile(
                            leading: new Text("Last Name"),
                            title: Container(
                              height: 30,
                              child:
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  _lastName = value;
                                },

                              ),

                            ),
                          ),

                          ListTile(
                            leading: new Text("Mobile number"),
                            title: Container(
                              height: 30,
                              child:
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  _number = value;
                                },

                              ),

                            ),
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


                          ListTile(
                              leading: new Text("Address Line 1"),
                              title: Container(
                                height: 30,
                                child:
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    _add1 = value;
                                  },
                                ),
                              )
                          ),
                          ListTile(
                              leading: new Text("Address Line 2"),
                              title: Container(
                                height: 30,
                                child:
                                TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()
                                  ),
                                  onChanged: (value) {
                                    _add2 = value;
                                  },
                                ),
                              )
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child:

                                new Text("District"),),
                              Container(
                                height: 30,
                                width: 120,
                                child:
                                TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()
                                  ),
                                  onChanged: (value) {
                                    _district = value;
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child:
                                new Text("Province"),),
                              Container(
                                height: 30,
                                width: 130,
                                child:
                                TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()
                                  ),
                                  onChanged: (value) {
                                    _province = value;
                                  },
                                ),
                              )
                            ],
                          ),


                          SizedBox(
                            height: 15,
                          ),

                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 15,),
                                child: Text("Zip code"),
                              ),

                              Container(
                                padding: EdgeInsets.only(left: 15,),
                                height: 30,
                                width: 120,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()
                                  ),
                                  onChanged: (value) {
                                    _zip = value;
                                  },
                                ),
                              )
                            ],
                          ),


                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: <Widget>[

                              Container(
                                padding: EdgeInsets.only(left: 30, right: 10,),
                                child: Text(
                                    "Do you want to include your partner?"),
                              ),

                              Container(
                                  height: 30,


                                  color: Colors.black12,
                                  child:

                                  DropdownButton(


                                    value: dropdownInclude,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 0,
                                    style: TextStyle(
                                        color: Colors.black
                                    ),

                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownInclude = newValue;
                                      });
                                    },

                                    items: <String>['No', 'Yes']
                                        .map<DropdownMenuItem<String>>((
                                        String value) {
                                      return DropdownMenuItem<String>(

                                        value: value,
                                        child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(value)),
                                      );
                                    })
                                        .toList(),

                                  )
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          dropdownInclude == 'No' ? new Container() :
                          dropdownValue == 'Mother' ? Text(
                            "Father's informmation", style: TextStyle(
                              fontSize: 20
                          ),) :
                          Text("Mother's Information", style: TextStyle(
                              fontSize: 20
                          ),),


                          dropdownInclude == 'No' ? new Container() :


                          ListTile(
                              leading: new Text("Name"),
                              title: Container(
                                height: 30,
                                child:
                                TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()
                                  ),

                                  onChanged: (value) {
                                    _partnerName = value;
                                  },

                                ),
                              )
                          ),

                          dropdownInclude == 'No' ? new Container() :
                          ListTile(
                              leading: new Text("Email"),
                              title: Container(
                                height: 30,
                                child:
                                TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()
                                  ),
                                  onChanged: (value) {
                                    _partnerEmail = value;
                                  },
                                ),
                              )
                          ),

                          dropdownInclude == 'No' ? new Container() :
                          ListTile(
                              leading: new Text("Mobile Number"),
                              title: Container(
                                height: 30,
                                child:
                                TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()
                                  ),
                                  onChanged: (value) {
                                    _partnerNUmber = value;
                                  },
                                ),
                              )
                          ),


                          dropdownInclude == 'No' ? new Container() :
                          dropdownValue == 'Mother' ? Text(
                            "*The Password of your partner will be his mobile number.",
                            style: TextStyle(
                                color: Colors.red
                            ),) :

                          Text(
                            "*The Password of your partner will be her mobile number.",
                            style: TextStyle(
                                color: Colors.red
                            ),),


                          SizedBox(height: 25.0),

                          Container(
                              width: 270,
                              height: 40,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Color.fromRGBO(81, 113, 100, 0.6),
                              ),
                              child: OutlineButton(
                                  child: Center(
                                      child: Text('Next',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                          )
                                      )
                                  ),
                                  onPressed: () async {
                                    backdrop = true;


                                    if (_number != null && _add1 != null &&
                                        _add2 != null && _district != null &&
                                        _province != null && _zip != null) {


                                      await UserManagement.updateFirstName(_firstName);
                                      await UserManagement.updateLastName(_lastName);

                                      await UserManagement.updateNumber(
                                          _number);
                                      await UserManagement.updateAddress1(
                                          _add1);
                                      await UserManagement.updateAddress2(
                                          _add2);
                                      await UserManagement.updateDistrict(
                                          _district);
                                      await UserManagement.updateProvince(
                                          _province);
                                      await UserManagement.updateZip(_zip)
                                          .then((val) {
                                        backdrop = false;
                                      });

                                    }


                                    if (dropdownInclude == 'No') {
                                      if (dropdownValue == 'Mother') {
                                        Navigator.of(context).pop();
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (
                                                    BuildContext context) =>
                                                    AddChild(
                                                        currentUid, 0, 0)));
                                      }
                                      else {
                                        Navigator.of(context).pop();
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (
                                                    BuildContext context) =>
                                                    AddChild(
                                                        0, currentUid, 0)));
                                      }
                                    }


                                    if (dropdownInclude == 'Yes' &&
                                        _partnerNUmber != null &&
                                        _partnerEmail != null &&
                                        _partnerName != null) {
                                      FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                          email: _partnerEmail,
                                          password: _partnerNUmber)
                                          .then((signedInUser) {
                                        FirebaseAuth.instance.currentUser()
                                            .then((val) {
                                          partnerUid = val.uid;
                                          UserUpdateInfo updateUser = UserUpdateInfo();
                                          val.updateProfile(updateUser)

                                              .then((user) {
                                            FirebaseAuth.instance
                                                .currentUser()
                                                .then((user) {
                                              UserManagement()
                                                  .storeNewUser(user, context);
                                              UserManagement.updateFirstName(
                                                  _partnerName);
                                              UserManagement.updateLastName(_lastName);
                                              UserManagement.updateNumber(
                                                  _partnerNUmber);
                                              UserManagement.updateAddress1(
                                                  _add1);
                                              UserManagement.updateAddress2(
                                                  _add2);
                                              UserManagement.updateDistrict(
                                                  _district);
                                              UserManagement.updateProvince(
                                                  _province);
                                              UserManagement.updateZip(_zip);
                                              UserManagement.updatePartner(
                                                  currentUid);

                                              if (dropdownValue == 'Mother') {
                                                UserManagement
                                                    .updateStreet(
                                                    "Father").then((ve){
                                                  FirebaseAuth.instance
                                                      .signInWithEmailAndPassword(
                                                      email: email,
                                                      password: password
                                                  ).then((FirebaseAuth) {
                                                    Firestore.instance.collection(
                                                        "users")
                                                        .where('uid',
                                                        isEqualTo: FirebaseAuth
                                                            .uid)
                                                        .getDocuments()
                                                        .then((docs) {
                                                      Firestore.instance.document(
                                                          '/users/${docs
                                                              .documents[0]
                                                              .documentID}')
                                                          .updateData({
                                                        'partnerUid': partnerUid
                                                      });
                                                    });
                                                  })
                                                      .catchError((e) {
                                                    print(e);
                                                  });
                                                });

                                                Navigator.of(context).pop();
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (
                                                            BuildContext context) =>
                                                            AddChild(currentUid,
                                                                partnerUid,
                                                                0)));
                                              }
                                              else {
                                                UserManagement
                                                    .updateStreet(
                                                    "Mother").then((wef){
                                                  FirebaseAuth.instance
                                                      .signInWithEmailAndPassword(
                                                      email: email,
                                                      password: password
                                                  ).then((FirebaseAuth) {
                                                    Firestore.instance.collection(
                                                        "users")
                                                        .where('uid',
                                                        isEqualTo: FirebaseAuth
                                                            .uid)
                                                        .getDocuments()
                                                        .then((docs) {
                                                      Firestore.instance.document(
                                                          '/users/${docs
                                                              .documents[0]
                                                              .documentID}')
                                                          .updateData({
                                                        'partnerUid': partnerUid
                                                      });
                                                    });
                                                  })
                                                      .catchError((e) {
                                                    print(e);
                                                  });
                                                });
                                                Navigator.of(context).pop();
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (
                                                            BuildContext context) =>
                                                            AddChild(partnerUid,
                                                                currentUid,
                                                                0)));
                                              }





                                            }).catchError((e) {
                                              print(e);
                                            });
                                          }).catchError((e) {
                                            print(e);
                                          });
                                        }).catchError((e) {
                                          print(e);
                                        });
                                      });
                                    }
                                  }
                              )
                          )


                        ],
                      )
                  )
                ],
              )
            ]
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
  ImageEdit(this.picUrl, this.email, this.password);
  final email;
  final password;
  final picUrl;

  @override
_ImageEditState createState() => _ImageEditState(this.picUrl, this.email, this.password);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.picUrl, this.email, this.password);
  final picUrl;
  final email;
  final password;
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
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
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
                        filePath = 'parentImages/${DateTime.now()}.png';


                        setState(() {
                          _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);

                        });


                        StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
                        String downloadUrl =  await snapshot.ref.getDownloadURL();





                        UserManagement.updateProfilePicture(downloadUrl).then((val){


                          Future.delayed(Duration(seconds: 4)).then((val) {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SelectprofilepicPage(email, password)));
                          });

                        });


                      },
                    )
                  ],
                ),
              ],
            )
      );
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://buildabrain-a8cce.appspot.com/');

  StorageUploadTask _uploadTask;

  String filePath;
  String filePaths;

  void _startUpload() async {
    filePath = 'parentImages/${DateTime.now()}.png';




    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
    String downloadUrl =  await snapshot.ref.getDownloadURL();
    await UserManagement.updateProfilePicture(downloadUrl);
  }

  Future<Null> _handleRefresh() async{
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {


    });

  }


  @override
  Widget build(BuildContext context) {
    if(_uploadTask != null) {


      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder:  (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =  event != null
          ? event.bytesTransferred / event.totalByteCount
              : 0;

          return Column(
            children: <Widget>[
              if(_uploadTask.isComplete)
                Stack(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.add, color: Colors.white,),
                      onPressed: (
                      ) {
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
      return  FlatButton.icon(
        label: Text('Upload to firebase', style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.cloud_upload, color: Colors.white,),
        onPressed: _startUpload,
      );
    }

  }
}


class Wait extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double _sigmaX = 0.0; // from 0-10
    double _sigmaY = 0.0; // from 0-10
    double _opacity = 0.1; // from 0-1.0

    Container(
      width: 350,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
        child: Container(
          color: Colors.black.withOpacity(_opacity),
        ),
      ),
    );
  }
}
