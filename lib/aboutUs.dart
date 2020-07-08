

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  DragStartBehavior dragStartBehavior;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dragStartBehavior = DragStartBehavior.down;
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
      body:


      Container(
      child:
      new CustomScrollView(
        dragStartBehavior: dragStartBehavior,


          slivers: <Widget>[

            SliverAppBar(
                backgroundColor: Color.fromRGBO(23, 142, 137, 1),
                actionsIconTheme: IconThemeData(
                    color: Color.fromRGBO(0, 0, 0, 0)
                ),
                iconTheme: IconThemeData(
                    color: Colors.white
                ),

                pinned: true,
                forceElevated: true,

               automaticallyImplyLeading: true,
                primary: true,

                floating: true,
                expandedHeight: height / 1.4,
                flexibleSpace: new FlexibleSpaceBar(
                    background:
                    Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black, Colors.transparent],
                              ).createShader(Rect.fromLTRB(
                                  0, 50, rect.width, rect.height));
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.asset(
                              'lib/Assets/aboutus1.jpg',
                              height: height / 2.5,
                              fit: BoxFit.cover,
                            ),
                          ),


                          Positioned(
                            top: height / 4,
                            child: Container(
                                height: height / 5,
                                child: Image.asset("lib/Assets/bdblogo.png")),
                          ),

                          Positioned(
                            top: height / 2.1,
                            child: Text("ABOUT US", style: TextStyle(
                                fontFamily: "Alphin",
                                color: Colors.white,
                                fontSize: 40
                            ),),
                          ),
                          Positioned(
                            top: height / 1.8,
                            child: Container(
                              width: width - 30,
                              child: Text(
                                "Our school is an extraordinary place of learning and discovery.\nTalented and caring members of staff provide each student with the highest academic and behavioral standards which combine to give the ideal foundation to go on and succeed in life."
                                    .toUpperCase(), style: TextStyle(
                                  color: Colors.white,
                                  height: 1.3,
                                  fontSize: 14,
                                  fontFamily: "Alphin"


                              ),),
                            ),
                          ),


                        ]
                    )
                )
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Text("OUR MISSION", style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontFamily: "Alphin",
                              ),),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "We aim to provide a supportive, child-centred"    .toUpperCase(), style: TextStyle(
                              color: Colors.black,
                              height: 1.2,
                              fontSize: 12,
                              fontFamily: "Alphin",

                            ),),
                            Text(
                              "learning environment, where children of all"    .toUpperCase(), style: TextStyle(
                              color: Colors.black,
                              height: 1.2,
                              fontSize: 12,
                              fontFamily: "Alphin",

                            ),),
                            Text(
                              "nationalities discover the joy of learning, and"    .toUpperCase(), style: TextStyle(
                              color: Colors.black,
                              height: 1.2,
                              fontSize: 12,
                              fontFamily: "Alphin",

                            ),),
                            Text(
                              "obtain a firm foundation for fulfilment and"    .toUpperCase(), style: TextStyle(
                              color: Colors.black,
                              height: 1.2,
                              fontSize: 12,
                              fontFamily: "Alphin",

                            ),),

                            Text(
                              "success in their future endeavours."    .toUpperCase(), style: TextStyle(
                                color: Colors.black,
                                height: 1.2,
                                fontSize: 12,
                                fontFamily: "Alphin",



                            ),),

                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                Container(
                                    child: Image.asset("lib/Assets/aboutus2.jpg",
                                      fit: BoxFit.cover,),
                                  width: width/2.7,
                                  height: height/8,
                                ),
                                Container(
                                  child: Image.asset("lib/Assets/aboutus3.jpg",
                                    fit: BoxFit.cover,),
                                  width: width/3.9,
                                  height: height/8,
                                ),
                                Container(
                                  child: Image.asset("lib/Assets/aboutus6.jpg",
                                    fit: BoxFit.cover,),
                                  width: width/2.7,
                                  height: height/8,
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                          ],
                        )
                      ),
                      Container(
                      color: Color.fromRGBO(23, 142, 137, 1),
                        child:
                      Stack(
                        children: [


                          


                          Positioned(
                            right: -120,
                            top: 40,
                            child:
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(Color.fromRGBO(23, 142, 137, 0.3), BlendMode.lighten),
                                image: AssetImage("lib/Assets/aboutus4.png"),

                              ),
                            ),
                            height: height/1.7,
                            width: height/1.7,
                          ),
                          ),









                          Container(
                            padding: EdgeInsets.only(left: 20),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),



                                Row(
                                  children: [
                                    Text("why iq and mindmap?", style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Alphin",
                                        fontSize: 25
                                    ),),
                                  ],
                                ),

                                SizedBox(
                                  height: 20,
                                ),


                                Container(
                                  padding: EdgeInsets.only(left: width/7),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Our personal approach resonates"    .toUpperCase(), style: TextStyle(
                                        color: Colors.white,
                                        height: 1.2,
                                        wordSpacing: 2,
                                        fontSize: 12,
                                        fontFamily: "Alphin",

                                      ),),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "in all we do. The small size of our schools "
                                          "\nensures all students and parents are"
                                          "\nknown, giving every one in our care"
                                          "\nthe personal attention they deserve."
                                          "\nEvery student is able to achieve"
                                          "\ntheir full potential enabling them"
                                          "\nto become a harmonious"
                                          "\nindividual as they participate"
                                          "\nin life both inside and outside"
                                          "\nof their school community."

                                      , style: TextStyle(
                                      color: Colors.white,
                                      height: 1.3,
                                      wordSpacing: 2,
                                      fontSize: 12,
                                      fontFamily: "Alphin",

                                    ),),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                )


                              ],
                            ),

                          ),
                        ],
                      )
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                            ),


                            Text("what do parents say", style: TextStyle(
                                fontFamily: "Alphin",
                              fontSize: 18,

                            ),),
                            SizedBox(
                              height: 4,
                            ),
                            Text("about sending their children", style: TextStyle(
                                fontFamily: "Alphin",
                              fontSize: 18,
                            ),),
                            SizedBox(
                              height: 4,
                            ),
                            Text("to buildabrain?", style: TextStyle(
                                fontFamily: "Alphin",
                              fontSize: 18,
                            ),),






                            Container(
                              height: 250,
                              width: width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(Colors.white38, BlendMode.lighten),
                                  image: AssetImage("lib/Assets/aboutus5.png"),
                                  fit: BoxFit.cover

                                ),
                              ),

                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              width: width-40,
                              padding: EdgeInsets.only(top: 30),

                              color: Color.fromRGBO(23, 142, 137, 1),

                              child: Column(
                                children: [
                                  Text("BDB is a great kindergarten. My older child joined", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    height: 1.3,
                                    fontFamily: "Alphin"
                                  ),),

                                  Text("with a tremendous amount of separation anxiety", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),
                                  Text("but the constant care and attention by the teachers", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),
                                  Text(" and staff of AISB helped him adapt quickly and ", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),

                                  Text("thrive. BDB provides a home like environment and is", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),
                                  Text("like an extension of a family. Both my children have", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),
                                  Text("had positive experiences and it is a school that", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),
                                  Text("I would strongly recommend.", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),

                                  SizedBox(
                                    height: 4,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("ekta", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.3,
                                          fontFamily: "Alphin"
                                      ),),
                                      SizedBox(
                                        width: 30,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("amie mom", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.3,
                                          fontFamily: "Alphin"
                                      ),),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              width: width-40,
                              padding: EdgeInsets.only(top: 30),

                              color: Color.fromRGBO(23, 142, 137, 1),

                              child: Column(
                                children: [
                                  Text("When my kids were at BDB, they always looked", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),

                                  Text("forward to going to school as the teachers made", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),
                                  Text("activities and learning fun. My son had sparked", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),
                                  Text("his interest in chess which led him to compete in", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),

                                  Text("multiple championships and tournaments, rooted", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),
                                  Text("from his time at BDB and learning from his teachers.", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                      fontFamily: "Alphin"
                                  ),),


                                  SizedBox(
                                    height: 4,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("francis", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.3,
                                          fontFamily: "Alphin"
                                      ),),
                                      SizedBox(
                                        width: 30,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("brad's mom", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.3,
                                          fontFamily: "Alphin"
                                      ),),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      )

                    ]
                )
            ),
          ]),
      )
    );
  }
}
