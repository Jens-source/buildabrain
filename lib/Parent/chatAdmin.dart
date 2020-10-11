import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  List<bool> expanded = new List();
  bool onPressed = false;
  bool loading = false;

  PageController pageController;

  getData() async {
    return await Firestore.instance.collection('users').getDocuments();
  }

  Future<void> callback() async {
    if (messageController.text.trim().length > 0) {
      await _firestore.collection('parentAdmin/$parentChatID/messages').add({
        'photoUrl': user.data['photoUrl'],
        'text': messageController.text,
        'from': user.data['firstName'],
        'date': DateTime.now()
      });

      messageController.clear();
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  int limitMessageAmount = 14;

  QuerySnapshot querySnapshot;

  QuerySnapshot newQuery;
  List<Widget> messages = [];
  String parentChatID;

  @override
  void initState() {
    _firestore
        .collection('parentAdmin')
        .where('parentUid', isEqualTo: user.data['uid'])
        .getDocuments()
        .then((value) async {
      if (value.documents.isEmpty) {
        await _firestore.collection('parentAdmin').add({
          "parentUid": user.data['uid'],
          "createdDate": DateTime.now(),
          "parentName": user.data['firstName'],
          "parentPic": user.data['photoUrl']
        }).then((parentDoc) {
          print(parentDoc.documentID);
          parentChatID = parentDoc.documentID;
        }).catchError((e) {
          print(e);
        });
      } else {
        parentChatID = value.documents[0].documentID;
        print(value.documents[0].documentID);
      }
    }).then((vasd) {
      messages.length == 0
          ? Firestore.instance
              .collection('parentAdmin/$parentChatID/messages')
              .limit(limitMessageAmount)
              .orderBy('date', descending: true)
              .getDocuments()
              .then((value) async {
              querySnapshot = value;
              newQuery = value;

              for (int i = 0; i < value.documents.length; i++) {
                setState(() {
                  messages.insert(
                      0,
                      Message(
                        date: value.documents[i].data['date'],
                        photoUrl: value.documents[i].data['photoUrl'],
                        from: value.documents[i].data['from'],
                        text: value.documents[i].data['text'] == null
                            ? value.documents[i].data['imageUrl']
                            : value.documents[i].data['text'],
                        me: user.data['firstName'] ==
                                value.documents[i].data['from']
                            ? true
                            : false,
                      ));
                });
              }
            }).catchError((e) {
              print(e);
            })
          : null;
    }).then((vqwdalue) {
      Firestore.instance
          .collection('parentAdmin/$parentChatID/messages')
          .limit(limitMessageAmount)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((event) {})
          .onData((data) {
        data.documentChanges.forEach((element) {
          Timestamp j = element.document.data['date'];

          if (element.document.data['photoUrl'] != user.data['photoUrl']) {
            if (Timestamp.now().microsecondsSinceEpoch -
                    j.microsecondsSinceEpoch <=
                35000000) {
              setState(() {
                print("Hello");
                messages.add(Message(
                  date: element.document.data['date'],
                  photoUrl: element.document.data['photoUrl'],
                  from: element.document.data['from'],
                  text: element.document.data['text'] == null
                      ? element.document.data['imageUrl']
                      : element.document.data['text'],
                  me: user.data['firstName'] == element.document.data['from']
                      ? true
                      : false,
                ));
              });
            }
          } else if (Timestamp.now().microsecondsSinceEpoch -
                  j.microsecondsSinceEpoch <=
              1000000) {
            setState(() {
              messages.add(Message(
                date: element.document.data['date'],
                photoUrl: element.document.data['photoUrl'],
                from: element.document.data['from'],
                text: element.document.data['text'] == null
                    ? element.document.data['imageUrl']
                    : element.document.data['text'],
                me: user.data['firstName'] == element.document.data['from']
                    ? true
                    : false,
              ));
            });
          }
        });
      });
    });

    scrollController.addListener(() {
      if (scrollController.position.atEdge && loading == false) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent)
          setState(() {
            loading = true;
            Timestamp t = newQuery.documents.last.data["date"];
            _firestore
                .collection('parentAdmin')
                .where('parentUid', isEqualTo: user.data['uid'])
                .getDocuments()
                .then((value) async {
              _firestore
                  .collection('parentAdmin/$parentChatID/messages')
                  .where('date', isLessThan: t)
                  .limit(10)
                  .orderBy('date', descending: true)
                  .getDocuments()
                  .then((volue) {
                newQuery = volue;

                if (volue.documents.length != 0) {
                  List<Widget> messageNew = new List();

                  Future.delayed(Duration(milliseconds: 400)).then((value) {
                    limitMessageAmount =
                        limitMessageAmount * 2 + volue.documents.length;

                    if (volue.documents.length != 0) {
                      for (int i = volue.documents.length; i >= 0; i--) {
                        setState(() {
                          if (i == volue.documents.length) {
                            for (int p = 0; p < limitMessageAmount; p++) {
                              messageNew.add(Container());
                            }
                          } else {
                            messageNew.add(Message(
                              date: volue.documents[i].data['date'],
                              photoUrl: volue.documents[i].data['photoUrl'],
                              from: volue.documents[i].data['from'],
                              text: volue.documents[i].data['text'] == null
                                  ? volue.documents[i].data['imageUrl']
                                  : volue.documents[i].data['text'],
                              me: user.data['firstName'] ==
                                      volue.documents[i].data['from']
                                  ? true
                                  : false,
                            ));
                          }
                        });
                      }
                      messageNew.addAll(messages);

                      messages = messageNew;

                      loading = false;
                    }
                  });
                } else {
                  setState(() {
                    loading = false;
                  });
                }
              }).catchError((e) {
                setState(() {
                  loading = false;
                });
              });
            }).catchError((e) async {});
          });
        // you are at top position

        // you are at bottom position
      }
    });

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
              Expanded(
                  child: ListView(
                reverse: true,
                controller: scrollController,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, i) {
                        String name;
                        String nameBefore;

                        String finalDate;
                        int num;
                        Message m;
                        Message mBefore;
                        String t;
                        String tBefore;
                        if (messages[i].runtimeType == Message) {
                          if (i != 0) {
                            if (messages[i - 1].runtimeType == Message) {
                              mBefore = messages[i - 1];
                              nameBefore = mBefore.from;
                              tBefore = DateTime.fromMicrosecondsSinceEpoch(
                                      mBefore.date.microsecondsSinceEpoch)
                                  .day
                                  .toString();
                            }
                          }
                          m = messages[i];
                          name = m.from;
                          t = DateTime.fromMicrosecondsSinceEpoch(
                                  m.date.microsecondsSinceEpoch)
                              .day
                              .toString();
                          if (m != null && mBefore != null)
                            num = DateTime.fromMicrosecondsSinceEpoch(
                                        m.date.microsecondsSinceEpoch)
                                    .day -
                                DateTime.fromMicrosecondsSinceEpoch(
                                        mBefore.date.microsecondsSinceEpoch)
                                    .day;
                        }

                        if (num != null && num != 0) {
                          finalDate = DateFormat("MMMEd").format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                  m.date.microsecondsSinceEpoch));
                        }

                        return Column(
                          children: [
                            finalDate != null
                                ? Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(finalDate))
                                : Container(),
                            name != nameBefore
                                ? SizedBox(
                                    height: 8,
                                  )
                                : Container(),
                            messages[i]
                          ],
                        );
                      }),
                  loading == true
                      ? Center(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                ],
              )),
              Container(
                child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageEdit(user, parentChatID)));
                      },
                      child: Container(
                        height: 29,
                        width: 40,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("lib/Assets/camera.png"))),
                      ),
                    ),
                    title: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color.fromRGBO(220, 220, 220, 1),
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Enter a Message...",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16, fontFamily: 'Balsamiq'),
                        onChanged: (value) {
                          if (value.length != 0) {}
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
                      },
                    )),
              ),
            ],
          ),
        ),
      );
    } else
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.send,
        size: 40,
      ),
      color: Color.fromRGBO(23, 142, 137, 1),
      onPressed: callback,
    );
  }
}

class Message extends StatefulWidget {
  final String photoUrl;
  final String from;
  final String text;
  final dateBefore;

  final date;
  final bool me;
  const Message(
      {Key key,
      this.from,
      this.text,
      this.me,
      this.photoUrl,
      this.date,
      this.dateBefore})
      : super(key: key);

  @override
  _MessageState createState() => _MessageState(
      this.from, this.text, this.me, this.photoUrl, this.date, this.dateBefore);
}

class _MessageState extends State<Message> with SingleTickerProviderStateMixin {
  final String from;
  final String text;
  final bool me;
  final String photoUrl;
  final Timestamp date;
  final dateBefore;
  _MessageState(
      this.from, this.text, this.me, this.photoUrl, this.date, this.dateBefore);

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
          SizedBox(
            height: 8,
          ),
          Container(
            child: Row(
              mainAxisAlignment:
                  me ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                ),
                !me
                    ? Container(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 15,
                ),
                text.contains("https://firebasestorage.googleapis.com/v0/b/")
                    ? Container(
                        constraints: BoxConstraints(
                            minWidth: 100,
                            maxWidth: 170,
                            minHeight: 100,
                            maxHeight: 200),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(text),
                        )),
                      )
                    : Container(
                        child: Material(
                          color: Colors.black12,
                          borderRadius: me
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15.0),
                              child: Row(
                                children: [
                                  !me
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch).hour}:${DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch).minute}",
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  !me
                                      ? SizedBox(
                                          width: 5,
                                        )
                                      : Container(),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 200),
                                    child: Text(
                                      text,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  me
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch).hour}:${DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch).minute}",
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              )),
                        ),
                      ),
                SizedBox(
                  width: 15,
                ),
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

class ImageEdit extends StatefulWidget {
  ImageEdit(this.user, this.parentChatID);
  final user;
  final parentChatID;

  @override
  _ImageEditState createState() =>
      _ImageEditState(this.user, this.parentChatID);
}

class _ImageEditState extends State<ImageEdit> {
  _ImageEditState(this.user, this.parentChatID);
  final user;
  final parentChatID;

  File _imageFile;

  Future<void> callback(downloadUrl) async {
    await Firestore.instance
        .collection('parentAdmin/$parentChatID/messages')
        .where('parentUid', isEqualTo: user.data['uid'])
        .getDocuments()
        .then((value) {
      Firestore.instance
          .collection('parentAdmin')
          .document(value.documents[0].documentID)
          .collection("messages")
          .add({
        'imageUrl': downloadUrl,
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    selected = await ImageCropper.cropImage(
        sourcePath: selected.path, maxWidth: 700, maxHeight: 700);

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
        aspectRatio: CropAspectRatio(
          ratioY: 300,
          ratioX: 300,
        ),
        maxWidth: 700,
        maxHeight: 700);
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
  Widget build(BuildContext context) => new Scaffold(
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
                            wait = true;
                            FirebaseUser user =
                                await FirebaseAuth.instance.currentUser();

                            filePath =
                                'parentAdmin/${user.uid}/${DateTime.now()}.png';
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

                            callback(downloadUrl);

                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ],
                ));
}
