import 'package:flutter/material.dart';



class HelpCenter extends StatefulWidget {
  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
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

      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        title: Text("Support"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            )
        ),


      ),
      body: new Column(
        children: [

          SizedBox(
            height: 50
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width/1.2,

                child:
              Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(100))
                ),


                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.black,),
                    ),
                    hintText: "Search for help",

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

                  onChanged: (value) {

                  },
                ),
              ),
              ),
            ],
          ),

          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(offset: Offset(5, 5 ), blurRadius: 5, color: Colors.black54)
                  ]
                ),

                height: height/5,
                width: width/1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text("LIVE CHAT WITH", style: TextStyle(
                                fontSize: 20, color: Colors.red
                              ),),
                            ),
                            Container(
                              child: Text("OUR SUPPORT", style: TextStyle(
                                  fontSize: 20, color: Colors.red
                              ),),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                color: Colors.red,
                                  boxShadow: [
                                    BoxShadow(offset: Offset(2, 2 ), blurRadius: 2, color: Colors.black87)
                                  ]
                              ),
                              child: FlatButton(
                                child: Text("START", style: TextStyle(
                                  color: Colors.white
                                ),),
                              ),
                            )
                          ],

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 30),
                        child: Image.asset('lib/Assets/chatIcon.png'),
                      )

                    ],
                  ),

              )

            ],
          )



        ],
      ),

    );
  }
}
