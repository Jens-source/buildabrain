import 'package:buildabrain/signupPage.dart';
import 'package:flutter/material.dart';


class TorP extends StatefulWidget {
  @override
  _TorPState createState() => _TorPState();
}

class _TorPState extends State<TorP> {

  String identity;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: Color.fromRGBO(226, 235, 255, 1),
        body: ListView(
          children: <Widget>[


            Center(

            child:
            Container(

              height: 100,
              width: 100,
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/Assets/bdblogo.jpg'),
              ),
            ),
            ),




            SizedBox(
              height: 20,
            ),
            Center(
                child:
                Text("Happier Classrooms", style: TextStyle(
                    fontSize: 30
                ),)
            ),

            SizedBox(
              height: 20
            ),

            GestureDetector(
              onTap: () {

                identity = "Teacher";



                Navigator.push(
                    context, MaterialPageRoute(builder: (
                    BuildContext context) => SignupPage(identity)));

              },
              child:
              Container(
                padding: EdgeInsets.all(10),
                child:
                Container(
                  padding: EdgeInsets.all(10),
                  height: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      border: Border.all(color: Colors.black, width: 0.2,),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 2.0
                        )
                      ]
                  ),
                  child: Center(
                    child:
                    ListTile(
                      leading: Container(
                        height: 40,
                        child:
                        CircleAvatar(
                          backgroundImage: AssetImage('lib/Assets/teacher.png'),
                        ),
                      ),
                      title: Text("I'm a teacher", style: TextStyle(
                          fontSize: 23
                      ),),
                    ),
                  ),

                ),
              ),
            ),




            GestureDetector(
              onTap: () {

                identity = "Parent";
                Navigator.push(
                    context, MaterialPageRoute(builder: (
                    BuildContext context) => SignupPage(identity)));
              },
              child:
              Container(
                padding: EdgeInsets.all(10),
                child:
                Container(
                  padding: EdgeInsets.all(10),
                  height: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      border: Border.all(color: Colors.black, width: 0.2,),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 2.0
                        )
                      ]
                  ),
                  child: Center(
                    child:
                    ListTile(
                      leading: Container(
                        height: 40,
                        child:
                        CircleAvatar(
                          backgroundImage: AssetImage('lib/Assets/house.png'),
                        ),
                      ),
                      title: Text("I'm a parent", style: TextStyle(
                          fontSize: 23
                      ),),
                    ),
                  ),

                ),
              ),
            ),



            GestureDetector(
              onTap: () {
    String password;
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Enter Password: "),
        content: new TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder()
          ),

          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
        ),

        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if(password == 'bdbbest'){
                identity = "Leader";
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (
                    BuildContext context) => SignupPage(identity)));
              }

              else{
                Navigator.of(context).pop();
              }
            },
            child: Text("CONTINUE", style: TextStyle(
                color: Colors.blue
            ),),
          ),

          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CANCEL", style: TextStyle(
                color: Colors.blue
            ),),
          ),
        ],


      );
    });







              },
              child:
              Container(
                padding: EdgeInsets.all(10),
                child:
                Container(
                  padding: EdgeInsets.all(10),
                  height: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      border: Border.all(color: Colors.black, width: 0.2,),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 2.0
                        )
                      ]
                  ),
                  child: Center(
                    child:
                    ListTile(
                      leading: Container(
                        height: 40,
                        child:
                        CircleAvatar(
                          backgroundImage: AssetImage('lib/Assets/leader.png'),
                        ),
                      ),
                      title: Text("I'm a school leader", style: TextStyle(
                          fontSize: 23
                      ),),
                    ),
                  ),

                ),
              ),
            ),
          ],
        )
    );
  }
}