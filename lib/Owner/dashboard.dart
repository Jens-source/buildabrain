import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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

    return Container(
      padding: EdgeInsets.only(top: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Today, ${DateFormat("MMMMd").format(DateTime.now())}", style: TextStyle(
                    fontSize: 24
                  ),)

                ],
              ),
            ),

            AnimatedContainer(
              height: addressMore ? 190 : 62,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 1000),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Card(
                    elevation: 2,
                    child: !addressMore ? ListTile(
                      title: Text("Address", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),),
                      trailing: IconButton(
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.arrow_menu,
                            progress: controller,
                          ),
                          onPressed: () {
                            setState(() {
                              addressMore = !addressMore;

                              addressMore
                                  ? controller.reverse()
                                  : controller.forward();
                            });
                          }
                      ),

                    ) :


                    Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "Address", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),),
                          trailing: IconButton(
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.arrow_menu,
                                progress: controller,
                              ),
                              onPressed: () {
                                setState(() {
                                  addressMore = !addressMore;
                                  addressMore ? controller
                                      .reverse() : controller
                                      .forward();
                                });
                              }
                          ),

                        ),


                        SingleChildScrollView(
                            child:
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10),
                                  child:
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text('Building:',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors
                                                  .black
                                          ),),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        child: Text(
                                            user.documents[0].data['addressLine2']),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10),
                                  child:
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text('Street:',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors
                                                  .black
                                          ),),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        child: Text(
                                            user.documents[0].data['addressLine1']),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10),
                                  child:
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text('District:',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors
                                                  .black
                                          ),),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        child: Text(
                                            user.documents[0].data['district']),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10),
                                  child:
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text('Province:',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors
                                                  .black
                                          ),),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        child: Text(
                                            user.documents[0].data['province']),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  child:
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text('Zip:',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors
                                                  .black
                                          ),),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        child: Text(
                                            user.documents[0].data['zip']),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ))


                      ],
                    )
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
