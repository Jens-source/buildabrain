import 'package:flutter/material.dart';


class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

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
    // TODO: implement build
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left, size: 40,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, top: 20, bottom: 20),
            child: Text("My Children", style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),),
          ),


          Container(
          padding: EdgeInsets.only(left: 10, right: 10),
            child:
          Container(

            height: 200,
            width: width,

            

            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),

              color: Color.fromRGBO(249, 157, 170, 1),

            ),


            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 25, top: 25),
                  child:
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment(-.2, 0),
                        image: AssetImage(
                            'lib/Assets/cat1.jpg'),
                        fit: BoxFit.cover,

                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 20.0, // has the effect of softening the shadow
                        spreadRadius: 3.0, // has the effect of extending the shadow

                      )
                    ],
                  ),
                )
                ),
                Container(
                  padding: EdgeInsets.only(left: 180, top: 30),
                  child:
                Text("Sally's", style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),)),
                Container(
                    padding: EdgeInsets.only(left: 180, top: 60),
                    child:
                    Text("school funds", style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,

                    ),)),
                Container(
                    padding: EdgeInsets.only(left: 180, top: 90),
                    child:
                    Text("8000 baht", style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold

                    ),)),

                Container(
                    padding: EdgeInsets.only(left: 35, top: 95),
                    child:
                    Text("Age 4", style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,


                    ),)),
                Container(
                    padding: EdgeInsets.only(left: 180, top: 140),
                    child: GestureDetector(
                      child: Text("More detail", style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 15,
                        decoration: TextDecoration.underline,

                      ),),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentDetail())

                        );
                      },
                    ),
                )



              ],
            ),

          )
          ),
          Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child:
              Container(

                height: 200,
                width: width,



                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),

                  color: Colors.grey,

                ),


                child: Stack(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(left: 25, top: 25),
                        child:
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment(-.2, 0),
                              image: AssetImage(
                                  'lib/Assets/pre1.jpg'),
                              fit: BoxFit.cover,

                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(100)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 20.0, // has the effect of softening the shadow
                                spreadRadius: 3.0, // has the effect of extending the shadow

                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 180, top: 30),
                        child:
                        Text("John's", style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),)),
                    Container(
                        padding: EdgeInsets.only(left: 180, top: 60),
                        child:
                        Text("school funds", style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,

                        ),)),
                    Container(
                        padding: EdgeInsets.only(left: 180, top: 90),
                        child:
                        Text("3600 baht", style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold

                        ),)),

                    Container(
                        padding: EdgeInsets.only(left: 35, top: 95),
                        child:
                        Text("Age 4", style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,


                        ),)),
                    Container(
                      padding: EdgeInsets.only(left: 180, top: 140),
                      child: GestureDetector(
                        child: Text("More detail", style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 15,
                          decoration: TextDecoration.underline,

                        ),),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentDetail())

                          );
                        },
                      ),
                    )



                  ],
                ),

              )
          ),

          Container(
            padding: EdgeInsets.only(top: 20, left: 250),

            child:    Text("Add Another Child")
          )
        ],
      ),
    );
  }
}



class PaymentDetail extends StatefulWidget {
  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {


  TabController tabController;

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
      body: new ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left, size: 40,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                padding: EdgeInsets.only(left: 120),
                  child:

                     Text("Sally", style: TextStyle(
                        fontSize: 26,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold
                    ),
                    ),

              )
            ],
          ),
          Center(
            child:
                Container(
                    padding: EdgeInsets.only(top: 40),
    child:
          Container(
            height:100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment(-.2, 0),
                image: AssetImage(
                    'lib/Assets/cat1.jpg'),
                fit: BoxFit.cover,

              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(50)),

            ),
          )
          )
          ),
          Center(
            child:
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text("Age 4", style: TextStyle(
              fontSize: 17,
              color: Colors.deepPurple
            ),),
          )
          ),
    DefaultTabController(
    length: 3,
    child: Column(
    children: <Widget>[
Container(
  padding: EdgeInsets.only(left: 30, right: 30, top: 30),
  child:
    Container(

    
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(40)),
    border: Border(
    top: BorderSide(width: 1.0, color: Colors.grey),
    left: BorderSide(width: 1.0, color: Colors.grey),
    right: BorderSide(width: 1.0, color: Colors.grey),
    bottom: BorderSide(width: 1.0, color: Colors.grey),
    ),
    ),

      child: TabBar(
      unselectedLabelColor: Colors.black38,
      labelColor: Colors.black,
      indicatorColor: Colors.white,

      controller: tabController,
      tabs: <Widget>[


        new Tab(text: 'Funds',),
        new Tab(text: 'Gift Activity'),
        new Tab(text: 'Donation'),

      ],
    ),),
),
      Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 40, left: 70),
              child:
              Text("8000", style: TextStyle(
                  fontSize: 50,
                color: Color.fromRGBO(249, 157, 170, 1),
              ),)
          ),
          Container(
              padding: EdgeInsets.only(top: 40, left: 20),
              child:
              Text("baht", style: TextStyle(
                  fontSize: 50,
                color: Color.fromRGBO(249, 157, 170, 0.5),
              ),)
          ),
        ],
      ),
      Container(

          child:
          Text("Current balance", style: TextStyle(
            fontSize: 16,
            color: Colors.deepPurple
          ),)
      ),
      Container(

          child:
          Text("(including interest)", style: TextStyle(
              fontSize: 14,
              color: Colors.grey
          ),)
      ),
      
      Container(
        child: Image.asset('lib/Assets/chart.png', width: width,height: 200,),
      )



    ],
    ),
    )



        ],
      ),
    );
  }
}