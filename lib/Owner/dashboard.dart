import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
with SingleTickerProviderStateMixin{

  List<Container> todayCards = [];
  int _current = 0;
  TabController tabController;
  int initialDateIndex = 0;
  String weekDay;


  Future <String> wd(num){
    switch(num){
      case 0 : {
        weekDay = "Monday";
      }
      break;
      case 1 : {
        weekDay = "Tuesday";
      }
      break;
      case 2 : {
        weekDay = "Wednesday";
      }
      break;
      case 3 : {
        weekDay = "Thursday";
      }
      break;
      case 4 : {
        weekDay = "Friday";
      }
      break;
      case 5 : {
        weekDay = "Saturday";
      }
      break;
      case 6 : {
        weekDay = "Sunday";
      }
      break;
    }
  }

  @override
  void initState() {
    initialDateIndex = DateTime.now().weekday - 1;





    tabController = new TabController(length: 7, vsync: this, initialIndex: initialDateIndex);
    wd(tabController.index);





    super.initState();
  }


  @override
  void dispose() {
    tabController.dispose();
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




    todayCards.clear();


    for(int i = 0; i < 3; i++){
      todayCards.add(

          Container(
              padding: EdgeInsets.only(top: width/20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color.fromRGBO(153, 107, 55, 1),
              ),
              height: height/3,
              width: width - 80,
              child: Stack(
                children: [


                  Column(
                    children: [
                      Row(
                        children: [

                          SizedBox(
                            width: width/20,
                          ),
                          Container(
                            height: width/4,
                            width: width/4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                color: Colors.white30
                            ),
                            child: Center(
                              child: Image.asset("lib/Assets/iq.png",),
                            ),

                          ),

                          SizedBox(
                            width: 20,
                          ),


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("Mon 09:00-10:00 AM", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17
                                ),),

                              ),
                              Container(
                                child: Text("IQ Junior", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30
                                ),),
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Text("Teacher", style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25
                                    ),),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),

                                  Container(
                                    child: Text("Jens", style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25
                                    ),),
                                  ),
                                ],
                              ),
                              Container(
                                child: Text("Assistant Bee", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),),
                              ),


                            ],
                          )

                        ],
                      ),

                      SizedBox(
                        height: 15,
                      ),





                    ],
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child:  Container(
                      padding: EdgeInsets.only(top: 10, left: 25),
                      height: height/8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color.fromRGBO(243, 197, 145, 1),
                      ),


                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("Students in class", style: TextStyle(
                                    fontSize: 20
                                ),),
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              Container(
                                child: Text("8", style: TextStyle(
                                    fontSize: 20
                                ),),
                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("Checked in", style: TextStyle(
                                    fontSize: 20
                                ),),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    color: Colors.white
                                ),
                                child: Center(
                                  child: Text("6", style: TextStyle(
                                      fontSize: 20
                                  ),),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: Text("Absent", style: TextStyle(
                                    fontSize: 20
                                ),),
                              ),
                              SizedBox(
                                width: 20,
                              ),

                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    color: Colors.white
                                ),
                                child: Center(
                                  child: Text("2", style: TextStyle(
                                      fontSize: 20
                                  ),),
                                ),
                              ),


                            ],
                          ),
                        ],
                      ),


                    ),
                  )

                ],
              )
          )
      );
    }


    return Container(
      padding: EdgeInsets.only(top: 15),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            CarouselSlider(
                items: todayCards,
                options: CarouselOptions(
                  aspectRatio: 16/9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,

                  autoPlay: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                )
            ),

            SizedBox(
              height: 20,
            ),
            Stack(
              children: [

                Container(
                  height: 47.5,
                  width: (width * 3/7) -15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(23, 142, 137, 1),
                  ),
                ),

                Container(
                  width: width -30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.black26,
                  ),

                  child: TabBar(
                    controller: tabController,
                    labelPadding: EdgeInsets.only(left: 1, right: 1),

                    indicator: CustomTabIndicator(),
                    labelStyle: TextStyle(
                        fontSize: 18
                    ),
                    tabs: [
                      Container(
                        child: Tab(
                          text: "Mon",
                        ),
                      ),
                      Tab(
                        text: "Tue",
                      ),
                      Tab(
                        text: "Wed",
                      ),
                      Tab(
                        text: "Thu",
                      ),
                      Tab(
                        text: "Fri",
                      ),
                      Tab(
                        text: "Sat",
                      ),
                      Tab(
                        text: "Sun",
                      ),


                    ],
                  ),
                ),


              ],
            ),



            SizedBox(
              height: 15,
            ),


            Container(
              height: 200,
              width: width,
          
              child: TabBarView(
                controller: tabController,

                children: [


                 Container(child: Text(weekDay),),
                 Container(child: Text(weekDay),),
                 Container(child: Text(weekDay),),
                 Container(child: Text(weekDay),),
                 Container(child: Text(weekDay),),
                 Container(child: Text(weekDay),),
                 Container(child: Text(weekDay),),

                ],
              )
            )



          ],
        ),

    );
  }

}
class CustomTabIndicator extends Decoration {

  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) {
    return new _CustomPainter(this, onChanged);
  }

}

class _CustomPainter extends BoxPainter {

  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final Rect rect = offset & configuration.size;
    final Paint paint = Paint();
    paint.color = Colors.orangeAccent;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(15.0)), paint);
  }

}