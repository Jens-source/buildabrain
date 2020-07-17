
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class Chat extends StatefulWidget {
  Chat(this.user);
  final user;
  @override
  _ChatState createState() => _ChatState(this.user);
}

class _ChatState extends State<Chat> with SingleTickerProviderStateMixin{

  _ChatState(this.user);
  final DocumentSnapshot user;

  bool chatGroup = false;
  bool chatHelp = false;
  @override
  Widget build(BuildContext context) {
    if(chatGroup == false) {
      return
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            children: [


              SizedBox(
                height: 20,
              ),
              Container(
                child: Card(
                  color: Colors.white70,
                  child: ListTile(
                      onTap: () {

                      },
                      title: Text("Chat with admin"),
                      leading: Container(
                        height: 50,
                        width: 50,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              "lib/Assets/chatHelp.png"),
                        ),
                      )

                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Card(
                  color: Colors.white70,
                  child: ListTile(
                      onTap: () {
                        setState(() {
                          chatGroup = true;
                        });
                      },
                      title: Text("Chat with group"),
                      leading: Container(
                        height: 50,
                        width: 50,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              "lib/Assets/chatGroup.png"),
                        ),
                      )

                  ),
                ),
              ),
            ],
          ),

        );
    }
    else return ChatGroup(user);
  }
}

class ChatGroup extends StatefulWidget {
  ChatGroup(this.user);
  final user;
  @override
  _ChatGroupState createState() => _ChatGroupState(this.user);
}

class _ChatGroupState extends State<ChatGroup> {
  _ChatGroupState(this.user);
  final DocumentSnapshot user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  getData() async {
    return await Firestore.instance.collection('users').getDocuments();
  }

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await _firestore.collection('parentGroupChat')
          .add({
        'text': messageController.text,
        'from': (user.data['firstName']),
        'date': DateTime.now()
      });
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: (){
              
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('parentGroupChat')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    List<DocumentSnapshot> docs = snapshot.data.documents;

                    List<Widget> messages = docs
                        .map((doc) =>
                        Message(
                          from: doc.data['from'],
                          text: doc.data['text'],
                          me: user.data['firstName'] == doc.data['from'],
                        ))
                        .toList();

                    return ListView(
                      controller: scrollController,
                      children: <Widget>[
                        ...messages,
                      ],
                    );
                  },
                ),
              ),

              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) => callback(),

                        decoration: InputDecoration(
                          hintText: "Enter a Message...",
                          border: const OutlineInputBorder(),

                        ),
                        controller: messageController,
                      ),
                    ),
                    SendButton(
                      text: "Send",
                      callback: (){
                        callback();
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        messageController.clear();

                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else return Center(child: CircularProgressIndicator(),);
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatefulWidget {

  final String from;
  final String text;

  final bool me;
  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  _MessageState createState() => _MessageState(this.from, this.text, this.me);
}

class _MessageState extends State<Message> with SingleTickerProviderStateMixin{

  final String from;
  final String text;

  final bool me;

  _MessageState(this.from, this.text, this.me);









  @override
  Widget build(BuildContext context) {
    bool height = false;

    return GestureDetector(
      onTap: (){
       setState(() {
         height = !height;
       });
      },
      child:

      AnimatedContainer(
      height: height == false ? 50: 70,
      duration: Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment:
        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5,),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
      ),
    );
  }


}
