import 'dart:io';
import 'dart:ui';
import 'package:buildabrain/main.dart';
import 'package:buildabrain/services/userManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class ParentProfile extends StatefulWidget {

  ParentProfile(this.user, this.childrenSnap);

  final childrenSnap;
  final user;

  @override
  _ParentProfileState createState() => _ParentProfileState(this.user, this.childrenSnap);
}

class _ParentProfileState extends State<ParentProfile> with
    TickerProviderStateMixin {

  _ParentProfileState(this.user, this.childrenSnap);

  final QuerySnapshot childrenSnap;

  final user;
  bool addressMore = false;
  AnimationController controller;
  String about;
  String number;
  DocumentSnapshot parent;

  List<Tab> tabList = [];


  String name;
  bool changedName;
  String birthday;
  String lastName;
  String _number;

  String _street;
  String _province;
  String _district;
  var squareScaleA = 0.5;
  var squareScaleB = 0.5;
  var squareScaleC = 0.5;
  List<double> squareScaleList = new List();

  TabController tabController;

  List <AnimationController> _controllerList = new List();



  @override
  void initState() {
    setState(() {
      parent = user.documents[0];
      _number = user.documents[0].data['number'];

      name = parent['firstName'];
      birthday = parent['birthday'];
      lastName = parent['lastName'];
      _street = parent['street'];
      _province = parent['province'];
      _district = parent['district'];
    });
    // TODO: implement initState
    tabController = new TabController(length: childrenSnap.documents.length + 1, vsync: this,);

    for(int i = 0; i < tabController.length; i++){

      if(i == 0) {
        tabList.add(
            Tab(
              child: Container(

                width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                      image: parent.data['status'] == "Mother" ?
                     AssetImage("lib/Assets/mother.png",) :
                     AssetImage("lib/Assets/father.png")
                    )

                  ),

              ),
            )
        );
      }
      else{
        tabList.add(
            Tab(
              child: Container(

                height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                      image:  childrenSnap.documents[i-1].data['gender'] == "male" ?
                      AssetImage("lib/Assets/boy.png") :
                      AssetImage("lib/Assets/girl.png")
                    ),

                  ),
              ),
            )
        );
      }
    }

    super.initState();
  }


  @override
  void dispose() {
    for (int i = 0; i < _controllerList.length; i++) {
      _controllerList[i].dispose();
    }
    super.dispose();
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



    return new Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        body:
        Container(
            height: height,
            child:
            Stack(
              children: <Widget>[

                Positioned(
                  bottom: 0,
                  height: height / 1.5,
                  width: width,
                  child: Container(
                    color: Colors.white,
                  ),
                ),

                Container(
                  width: width,
                  height: height / 2.2,
                  color: Color.fromRGBO(23, 142, 137, 1),
                ),


                Positioned(
                  top: height / 3.3,
                  child:
                  Container(

                    height: 200,
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.elliptical(width, 200))
                    ),
                  ),
                ),

                Positioned(
                    left: width / 3.5,
                    top: height / 7,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageEdit(user, childrenSnap)));
                      },
                      child:
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 5, color: Colors.grey),
                            borderRadius: BorderRadius.all(
                                Radius.circular(1000))
                        ),
                        height: height / 4,
                        width: height / 4,

                        child:
                        CircleAvatar(
                          backgroundImage: NetworkImage(parent['photoUrl']),

                          child: Container(
                            padding: EdgeInsets.only(
                                left: width / 4, top: width / 4),
                            child:
                            Container(
                              width: 50,

                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2, color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(1000))
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add,),
                              ),
                            ),

                          ),
                        ),
                      ),

                    )


                ),


                Container(
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left, size: 40,
                      color: Colors.white,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),

                ),


                Positioned(
                  bottom: 0,
                  width: width,
                  height: height / 1.55,
                  child:
                  Container(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [


                        Column(

                            children: <Widget>[
                              //menu
                              Container(
                                height: 60,
                                width: width / 2,
                                child: TabBar(
                                    indicatorColor: Color.fromRGBO(0, 0, 0, 0),

                                    labelPadding: EdgeInsets.all(5),
                                    labelStyle: TextStyle(
                                        fontSize: 20
                                    ),
                                    unselectedLabelStyle: TextStyle(
                                        fontSize: 10
                                    ),
                                    controller: tabController,
                                    tabs: tabList
                                ),
                              ),
                            ]
                        ),
                        SizedBox(
                          height: height/1.8,
                          child:
                        new TabBarView(
                            controller: tabController,
                            children: <Widget>[
                              Column(
                                children: [

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
                                          width: width / 2,
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
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder
                                                      .none,
                                                  enabledBorder: InputBorder
                                                      .none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder
                                                      .none,
                                                ),

                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Balsamiq'
                                                ),
                                                initialValue: name,
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
                                          width: width / 2,
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

                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder
                                                      .none,
                                                  enabledBorder: InputBorder
                                                      .none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder
                                                      .none,
                                                ),


                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Balsamiq'
                                                ), initialValue: lastName,

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
                                            width: width / 2,
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


                                                  child: Row(
                                                    children: <Widget>[

                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text(birthday,
                                                        style: TextStyle(
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
                                          width: width / 2,
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
                                                keyboardType: TextInputType
                                                    .number,
                                                decoration: InputDecoration(

                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder
                                                      .none,
                                                  enabledBorder: InputBorder
                                                      .none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder
                                                      .none,
                                                ),


                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Balsamiq'
                                                ),
                                                initialValue: _number,
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
                                        child: Text(
                                          "Address: ", style: TextStyle(
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
                                          width: width / 2,
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

                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder
                                                      .none,
                                                  enabledBorder: InputBorder
                                                      .none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder
                                                      .none,
                                                ),


                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Balsamiq'
                                                ),
                                                initialValue: _street,
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
                                          width: width / 2,
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

                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder
                                                      .none,
                                                  enabledBorder: InputBorder
                                                      .none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder
                                                      .none,
                                                ),


                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Balsamiq'
                                                ),
                                                initialValue: _district,
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
                                          width: width / 2,
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

                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder
                                                      .none,
                                                  enabledBorder: InputBorder
                                                      .none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder
                                                      .none,
                                                ),


                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Balsamiq'
                                                ),
                                                initialValue: _province,
                                                onChanged: (value) {
                                                  _province = value;
                                                },
                                              ),
                                            ),
                                          )


                                      )


                                    ],
                                  ),


                                  SizedBox(
                                    height: 40,
                                  ),


                                ],
                              ),
                              Container(
                                height: 100,
                                width: width,
                              ),
                              Container(
                                height: 100,
                                width: width,
                              )
                            ]
                        )
                        ),


                      ],

                    ),

                  ),

                ),

              ],
            )
        )

    );
  }
}








class ImageEdit extends StatefulWidget{
  ImageEdit(this.user, this.childrenSnap);
  final user;

  final childrenSnap;

  @override
  _ImageEditState createState() => _ImageEditState(this.user, this.childrenSnap);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.user, this.childrenSnap);

  final user;
  final childrenSnap;


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

                      filePath = 'parentProfile/${user.documents[0].data['uid']}.png';
                      setState(() {
                        _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
                      });


                      StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
                      String downloadUrl =  await snapshot.ref.getDownloadURL();

                      print(user.documents[0].documentID);

                      await Firestore.instance.document('users/${user.documents[0].documentID}')
                      .updateData({
                        "photoUrl": downloadUrl
                      });


                      QuerySnapshot u;


                      await Firestore.instance.collection("users")
                      .where("uid", isEqualTo: user.documents[0].data['uid'])
                      .getDocuments()
                      .then((value) {
                        u = value;
                      });




                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ParentProfile(u, childrenSnap)));




                    },
                  )
                ],
              ),
            ],
          )
      );
}




