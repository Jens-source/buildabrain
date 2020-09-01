

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';





class ChatAdmin extends StatefulWidget {
  ChatAdmin(this.user);
  final user;
  @override
  _ChatAdminState createState() => _ChatAdminState(this.user);
}

class _ChatAdminState extends State<ChatAdmin> {
  
  _ChatAdminState(this.user);
  final DocumentSnapshot user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List <bool> expanded;

  bool onPressed = false;
  String message;







  Future<void> callback() async {
    if (messageController.text.trim().length > 0 ) {
      await _firestore.collection('parentAdmin')
      .where('parentUid', isEqualTo: user.data['uid'])
      .getDocuments()
      .then((value) async{
        await _firestore.collection('parentAdmin/${value.documents[0].documentID}/messages')
            .add({
          'photoUrl': user.data['photoUrl'],
          'text': message,
          'from': user.data['firstName'],
          'date': DateTime.now()
        });
        messageController.clear();

      }).catchError((e)async{
        await Firestore.instance.collection('parentAdmin')
            .add({
          "parentUid": user.data['uid'],
          "name" : user.data['firstName'],
          "photoUrl": user.data['photoUrl'],
          "created": DateTime.now()
        });
        await _firestore.collection('parentAdmin')
            .where('parentUid', isEqualTo: user.data['uid'])
            .getDocuments()
            .then((value) async {
              setState(() {
                parentAdmin = value;
              });
          await _firestore.collection('parentAdmin/${value.documents[0].documentID}/messages')
              .add({
            'photoUrl': user.data['photoUrl'],
            'text': message,
            'from': user.data['firstName'],
            'date': DateTime.now()
          });
          messageController.clear();
        });

        
      });

      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  QuerySnapshot parentAdmin;


  @override
  void initState() {
    _firestore
        .collection('parentAdmin')
        .where('parentUid', isEqualTo: user.data['uid'])
    .getDocuments().then((value) {
      setState(() {
        parentAdmin = value;

      });
    }).asStream();
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Scaffold(

        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              parentAdmin != null && parentAdmin.documents.length != 0?
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('parentAdmin/${parentAdmin.documents[0].documentID}/messages')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<DocumentSnapshot> docs = snapshot.data.documents;
                    if(expanded == null){
                      expanded = new List(docs.length);
                      for(int i = 0; i < docs.length; i++){
                        expanded[i] = false;
                      }
                    }

                    List<Widget> messages = docs
                        .map((doc) =>
                        Message(
                          date: doc.data['date'],
                          photoUrl: doc.data['photoUrl'],
                          from: doc.data['from'],
                          text: doc.data['text'] == null ? doc.data['imageUrl'] : doc.data['text'],
                          me: user.data['firstName'] == doc.data['from'],
                        )
                    ).toList();

                    return ListView(
                      reverse: true,
                      controller: scrollController,
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, i) {
                              return new Column(
                                children: [

                                  i != 0 ?
                                  DateFormat("yyyy-MM-dd").format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          docs[i].data['date']
                                              .microsecondsSinceEpoch)) ==
                                      DateFormat("yyyy-MM-dd").format(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              docs[i - 1].data['date']
                                                  .microsecondsSinceEpoch)) ?


                                  docs[i].data["date"]
                                      .toDate()
                                      .difference(
                                      docs[i - 1].data["date"].toDate())
                                      .inMinutes < 5 ?


                                  Container() : Text(DateFormat("Hm").format(
                                      docs[i].data["date"].toDate())) :

                                  DateFormat("yyyy-MM-dd").format(
                                      docs[i].data["date"].toDate()) ==
                                      DateFormat("yyyy-MM-dd").format(
                                          DateTime.now()) ?

                                  Text("Today, ${DateFormat("Hm").format(
                                      docs[i].data["date"].toDate())}") :


                                  DateTime
                                      .now()
                                      .difference(docs[0].data["date"].toDate())
                                      .inDays >= 6 ?


                                  Text("${ DateFormat("EEEE").format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          docs[i].data['date']
                                              .microsecondsSinceEpoch))}, "
                                      "${ DateFormat("Hm").format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          docs[i].data['date']
                                              .microsecondsSinceEpoch))}")

                                      :


                                  Text("${ DateFormat("EEEE").format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          docs[i].data['date']
                                              .microsecondsSinceEpoch))}, "
                                      "${ DateFormat("Hm").format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          docs[i].data['date']
                                              .microsecondsSinceEpoch))}") :

                                  Text("${ DateFormat("MMMMd").format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          docs[i].data['date']
                                              .microsecondsSinceEpoch))}, "
                                      "${ DateFormat("Hm").format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          docs[i].data['date']
                                              .microsecondsSinceEpoch))}"),

                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        expanded[i] = !expanded[i];
                                        print(expanded[i]);
                                      });
                                    },
                                    child:
                                    AnimatedContainer(

                                      duration: Duration(milliseconds: 300),
                                      height: expanded[i] == false ? 45: 60,
                                      child: SingleChildScrollView(
                                          child:
                                          Column(
                                            children: [
                                              messages[i],
                                              expanded[i] == true ? Text(docs[i].data['from']) : Container()
                                            ],
                                          )),

                                    ),
                                  ),
                                ],
                              );
                            })
                      ],
                    );
                  },
                ),
              ) : Container(),

              Container(


                child: ListTile(

                    leading:
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageEdit(user)));

                      },
                      child:
                      Container(

                        height: 29,
                        width: 40,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("lib/Assets/camera.png")

                            )
                        ),
                      ),
                    ),
                    title: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                            15)),
                        color: Color.fromRGBO(220, 220, 220, 1),
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: TextFormField(
                        controller: messageController,

                        decoration: InputDecoration(
                          hintText: "Enter a Message...",
                          hintStyle: TextStyle(
                              color: Colors.black26
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),

                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Balsamiq'
                        ),
                        onChanged: (value) {
                          if(value.length != 0){

                          }
                        },
                      ),
                    ),

                    trailing: SendButton(
                      text: "Send",
                      callback: () {
                        onPressed = true;
                        callback();
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        setState(() {
                          message = messageController.text;
                          messageController.clear();
                        });


                      },
                    )

                ),

              ),
            ],
          ),
        ),
      );
    } else
      return Center(child: CircularProgressIndicator(),);
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.send, size: 40,),
      color: Color.fromRGBO(23, 142, 137, 1),
      onPressed:  callback,
    );
  }
}

class Message extends StatefulWidget {


  final String photoUrl;
  final String from;
  final String text;

  final date;
  final bool me;
  const Message({Key key, this.from, this.text, this.me, this.photoUrl, this.date}) : super(key: key);

  @override
  _MessageState createState() => _MessageState(this.from, this.text, this.me, this.photoUrl, this.date);
}

class _MessageState extends State<Message> with SingleTickerProviderStateMixin{


  final String from;
  final String text;
  final bool me;
  final String photoUrl;
  final date;
  _MessageState(this.from, this.text, this.me, this.photoUrl, this.date);

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Container(


      child: Column(

        children: <Widget>[

          SizedBox(height: 5,),



          Container(

            child: Row(
              mainAxisAlignment:  me ? MainAxisAlignment.end : MainAxisAlignment.start,

              children: [
                SizedBox(
                  width: 15,
                ),

                !me? Container(

                  height: 30,
                  width: 30,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl),
                  ),
                ) : Container(),
                SizedBox(
                  width: 15,
                ),

                text.contains("https://firebasestorage.googleapis.com/v0/b/") ?
                Container(

                  constraints: BoxConstraints(minWidth: 100, maxWidth: 170, minHeight: 100, maxHeight: 200),
                  decoration: BoxDecoration(



                      image: DecorationImage(

                        image: NetworkImage(text),
                      )
                  ),
                ) :
                Material(
                  color: Colors.black12,
                  borderRadius: me ? BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft:  Radius.circular(10),
                  ) : BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight:  Radius.circular(10),
                  ),

                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Text(
                      text,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                me? Container(
                  height: 30,
                  width: 30,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl),
                  ),
                ) : Container(),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}




class ImageEdit extends StatefulWidget{
  ImageEdit(this.user,);
  final user;

  @override
  _ImageEditState createState() => _ImageEditState(this.user);
}

class _ImageEditState extends State<ImageEdit> {


  _ImageEditState(this.user);
  final user;


  File _imageFile;



  Future<void> callback(downloadUrl) async {



     await Firestore.instance.collection('parentAdmin')
      .where('parentUid', isEqualTo: user.data['uid'])
     .getDocuments()
     .then((value) {
        Firestore.instance.collection('parentAdmin')
           .document(value.documents[0].documentID)
           .collection("messages")
           .add({
         'imageUrl': downloadUrl,

       });
     });





  }

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    selected = await ImageCropper.cropImage(
        sourcePath: selected.path,
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

  }

  Future getImageCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = tempImage;
    });

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

                      filePath = 'parentAdmin/${user.uid}/${DateTime.now()}.png';
                      setState(() {
                        _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);

                      });


                      StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
                      String downloadUrl =  await snapshot.ref.getDownloadURL();

                      callback(downloadUrl);

                      Navigator.of(context).pop();





                    },
                  )
                ],
              ),
            ],
          )
      );
}
