import 'dart:io';
import 'dart:ui';

import 'package:buildabrain/main.dart';
import 'package:buildabrain/services/userManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  Profile(this.user);

  final user;

  @override
  _ProfileState createState() => _ProfileState(this.user);
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  _ProfileState(this.user);
  final user;
  bool addressMore = false;
  AnimationController controller;
  String about;
  String number;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    about = user.documents[0].data['about'];
    number = user.documents[0].data['number'];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        body: new ListView(
          children: <Widget>[
            Container(
              height: height / 3 + 100,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: width,
                    height: height / 3,
                    color: Colors.green,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: height / 3 - 100),
                    child: Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: height / 3 - 100),
                    child: Center(
                      heightFactor: 4.5,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                alignment: Alignment(-.2, 0),
                                image: NetworkImage(
                                    user.documents[0].data['photoUrl']),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black38, BlendMode.darken)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ImageEdit(user
                                              .documents[0].data['photoUrl'])));
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MyHomePage()),
                            (route) => false);
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 170),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 100),
                          child: Text(
                            "${user.documents[0].data['firstName']} ${user.documents[0].data['lastName']}",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            user.documents[0].data['identity'] == 'Teacher'
                ? Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text("Mobile Number"),
                        subtitle: Text(user.documents[0].data['number']),
                        trailing: new IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: StatefulBuilder(
                                          // You need this, notice the parameters below:
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                        return Container(
                                            width: 500,
                                            height: 200,
                                            child: ListView(children: <Widget>[
                                              ListTile(
                                                title: Text(
                                                    "Change mobile number"),
                                              ),
                                              Container(
                                                height: 100,
                                                child: new TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText: number,
                                                      border:
                                                          OutlineInputBorder()),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      number = val;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ]));
                                      }),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return new AlertDialog(
                                                      title: Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  });
                                                });

                                            await UserManagement.updateNumber(
                                                    number)
                                                .then((vaewl) async {
                                              FirebaseUser use =
                                                  await FirebaseAuth.instance
                                                      .currentUser();
                                              Future.delayed(Duration(
                                                      milliseconds: 2000))
                                                  .then((value) {
                                                Firestore.instance
                                                    .collection('users')
                                                    .where('uid',
                                                        isEqualTo: use.uid)
                                                    .getDocuments()
                                                    .then((docs) {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Profile(docs)));
                                                });
                                              });
                                            });
                                          },
                                          child: Text(
                                            "CHANGE",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "CANCEL",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            }),
                      ),
                    ),
                  )
                : Container(),
            user.documents[0].data['identity'] == 'Teacher'
                ? Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text("Introduction"),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: StatefulBuilder(
                                        // You need this, notice the parameters below:
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                      return Container(
                                          width: 500,
                                          height: 200,
                                          child: ListView(children: <Widget>[
                                            ListTile(
                                              title:
                                                  Text("Change introduction"),
                                            ),
                                            Container(
                                              height: 120,
                                              child: new TextField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 5,
                                                decoration: InputDecoration(
                                                    hintText: about,
                                                    border:
                                                        OutlineInputBorder()),
                                                onChanged: (val) {
                                                  about = val;
                                                },
                                              ),
                                            ),
                                          ]));
                                    }),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return new AlertDialog(
                                                    title: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                });
                                              });

                                          await UserManagement.updateAbout(
                                                  about)
                                              .then((vaewl) async {
                                            FirebaseUser use =
                                                await FirebaseAuth.instance
                                                    .currentUser();
                                            Future.delayed(Duration(
                                                    milliseconds: 2000))
                                                .then((value) {
                                              Firestore.instance
                                                  .collection('users')
                                                  .where('uid',
                                                      isEqualTo: use.uid)
                                                  .getDocuments()
                                                  .then((docs) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Profile(docs)));
                                              });
                                            });
                                          });
                                        },
                                        child: Text(
                                          "CHANGE",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "CANCEL",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                        subtitle: Text(user.documents[0].data['about']),
                      ),
                    ),
                  )
                : Container(),
            AnimatedContainer(
              height: addressMore ? 190 : 62,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 1000),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Card(
                    elevation: 2,
                    child: !addressMore
                        ? ListTile(
                            title: Text(
                              "Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            trailing: IconButton(
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.arrow_menu,
                                  progress: controller,
                                ),
                                onPressed: () {
                                  setState(() {
                                    addressMore = !addressMore;

                                    addressMore
                                        ? controller.reverse()
                                        : controller.forward();
                                  });
                                }),
                          )
                        : Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Address",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                trailing: IconButton(
                                    icon: AnimatedIcon(
                                      icon: AnimatedIcons.arrow_menu,
                                      progress: controller,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        addressMore = !addressMore;
                                        addressMore
                                            ? controller.reverse()
                                            : controller.forward();
                                      });
                                    }),
                              ),
                              SingleChildScrollView(
                                  child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Building:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          child: Text(user.documents[0]
                                              .data['addressLine2']),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Street:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          child: Text(user.documents[0]
                                              .data['addressLine1']),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'District:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          child: Text(user
                                              .documents[0].data['district']),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Province:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          child: Text(user
                                              .documents[0].data['province']),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 10, bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Zip:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          child: Text(
                                              user.documents[0].data['zip']),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          )),
              ),
            ),
          ],
        ));
  }
}

class ImageEdit extends StatefulWidget {
  ImageEdit(this.picUrl);
  final picUrl;

  @override
  _ImageEditState createState() => _ImageEditState(this.picUrl);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.picUrl);
  final picUrl;

  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(
      source: source,
    );

    selected = await ImageCropper.cropImage(
        sourcePath: selected.path,
        aspectRatio: CropAspectRatio(
          ratioY: 300,
          ratioX: 300,
        ),
        maxWidth: 700,
        maxHeight: 700);

    setState(() {
      _imageFile = selected;
    });
  }

  Future getImageGallery() async {
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 512, maxWidth: 512);

    setState(() {
      _imageFile = tempImage;
    });
  }

  Future getImageCamera() async {
    var tempImage = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _imageFile = tempImage;
    });
  }

  Future<void> _cropImage() async {
    _imageFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatio: CropAspectRatio(
          ratioY: 300,
          ratioX: 300,
        ),
        maxWidth: 300,
        maxHeight: 300);
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
  Widget build(BuildContext context) => new Scaffold(
      backgroundColor: Colors.black,
      body: _imageFile == null
          ? Container(
              child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
              child: Container(
                child: Column(
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
                            icon: Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            ),
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
                            icon: Icon(
                              Icons.photo_library,
                              color: Colors.white,
                            ),
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
                          child: Text(
                            "Camera",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Container(
                          child: Text(
                            "Gallery",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                color: Colors.black.withOpacity(0.4),
              ),
            ))
          : wait == true
              ? new Container(
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                )
              : new ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Center(
                        child: Container(
                            height: 200,
                            width: 200,
                            child: CircleAvatar(
                              backgroundImage: FileImage(_imageFile),
                            ))),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Icon(
                            Icons.crop,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: _cropImage,
                        ),
                        FlatButton(
                          child: Icon(
                            Icons.refresh,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: _clear,
                        ),
                        FlatButton(
                          child: Icon(
                            Icons.file_upload,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            filePath = 'teacherProfile/${DateTime.now()}.png';

                            setState(() {
                              _uploadTask = _storage
                                  .ref()
                                  .child(filePath)
                                  .putFile(_imageFile);
                            });

                            StorageTaskSnapshot snapshot =
                                await _uploadTask.onComplete;
                            String downloadUrl =
                                await snapshot.ref.getDownloadURL();

                            UserManagement.updateProfilePicture(downloadUrl)
                                .then((val) {
                              Future.delayed(Duration(seconds: 2)).then((val) {
                                Navigator.of(context).pop();
                                FirebaseAuth.instance
                                    .currentUser()
                                    .then((user) {
                                  Firestore.instance
                                      .collection('users')
                                      .where('uid', isEqualTo: user.uid)
                                      .getDocuments()
                                      .then((docs) {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Profile(docs)));
                                    });
                                  });
                                });
                              });
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ));
}
