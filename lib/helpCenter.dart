import 'package:buildabrain/Parent/parentHome.dart';
import 'package:flutter/material.dart';

class HelpCenter extends StatefulWidget {
  HelpCenter(this.user);
  final user;

  @override
  _HelpCenterState createState() => _HelpCenterState(this.user);
}

class _HelpCenterState extends State<HelpCenter> {
  _HelpCenterState(this.user);
  final user;

  @override
  void initState() {
    subBottomNavigationIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return new Scaffold(
      body: SingleChildScrollView(
        child: new Column(
          children: [
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width / 1.2,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "Search for help",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 18, fontFamily: 'Balsamiq'),
                      onChanged: (value) {},
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
                        BoxShadow(
                            offset: Offset(5, 5),
                            blurRadius: 5,
                            color: Colors.black54)
                      ]),
                  height: height / 5,
                  width: width / 1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "LIVE CHAT WITH",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                            ),
                            Container(
                              child: Text(
                                "OUR SUPPORT",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: Colors.red,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 2,
                                        color: Colors.black87)
                                  ]),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ParentHome(user, 3, 2)));
                                },
                                child: Text(
                                  "START",
                                  style: TextStyle(color: Colors.white),
                                ),
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
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text(
                "Frequently asked questions".toUpperCase(),
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                "How to change my date?".toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
              trailing: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                  size: 35,
                ),
              ),
              subtitle: Divider(
                color: Colors.black,
                thickness: 1,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "How to book the course?".toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
              trailing: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                  size: 35,
                ),
              ),
              subtitle: Divider(
                color: Colors.black,
                thickness: 1,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "How to add my child?".toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
              trailing: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                  size: 35,
                ),
              ),
              subtitle: Divider(
                color: Colors.black,
                thickness: 1,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "How to change my course?".toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
              trailing: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                  size: 35,
                ),
              ),
              subtitle: Divider(
                color: Colors.black,
                thickness: 1,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
