
import 'package:flutter/material.dart';



class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with SingleTickerProviderStateMixin{


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
    else return ChatGroup();
  }
}

class ChatGroup extends StatefulWidget {
  @override
  _ChatGroupState createState() => _ChatGroupState();
}

class _ChatGroupState extends State<ChatGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [
          ListTile(
            title: Text("Hello"),
          )
        ],
      ),


    );
  }
}
