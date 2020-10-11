import 'package:buildabrain/Parent/parentProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../aboutUs.dart';
import '../helpCenter.dart';
import '../welcomePage.dart';

class ParentSettings extends StatefulWidget {
  ParentSettings(this.index, this.childrenSnapshot, this.parent);
  final index;
  final childrenSnapshot;
  final parent;
  @override
  _ParentSettingsState createState() =>
      _ParentSettingsState(this.index, this.childrenSnapshot, this.parent);
}

class _ParentSettingsState extends State<ParentSettings>
    with SingleTickerProviderStateMixin {
  _ParentSettingsState(this.index, this.childrenSnapshot, this.parent);

  TabController _tabController;
  final index;
  final childrenSnapshot;
  final parent;
  @override
  void initState() {
    _tabController =
        TabController(vsync: this, length: 11, initialIndex: index);
    super.initState();
  }

  void _toggleTab(i) {
    _tabController.animateTo(i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            ListView(children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "ACCOUNT",
                  style: TextStyle(fontSize: 16, color: Colors.orangeAccent),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {
                    _toggleTab(1);
                  },
                  leading: Icon(
                    Icons.person,
                    size: 40,
                  ),
                  title: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.notifications_active,
                    size: 40,
                  ),
                  title: Text(
                    "Notifications",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Are you sure yuo want to sign out?"),
                            actions: [
                              FlatButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              WelcomePage()),
                                      (route) => false);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "CANCEL",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  leading: Icon(
                    Icons.logout,
                    size: 40,
                  ),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.delete,
                    size: 40,
                  ),
                  title: Text(
                    "Remove Account",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "INFORMATION",
                  style: TextStyle(fontSize: 16, color: Colors.orangeAccent),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.event,
                    size: 40,
                  ),
                  title: Text(
                    "Special Events",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.info_outline,
                    size: 40,
                  ),
                  title: Text(
                    "About Buildabrain",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.help,
                    size: 40,
                  ),
                  title: Text(
                    "Help Center",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.phone,
                    size: 40,
                  ),
                  title: Text(
                    "Contact Us",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40,
                  ),
                ),
              ),
            ]),
            ParentProfile(parent, childrenSnapshot),
            AboutUs(),
            HelpCenter(parent),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
