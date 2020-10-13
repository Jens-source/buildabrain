import 'package:buildabrain/Parent/parentHome.dart';
import 'package:buildabrain/Parent/parentProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../aboutUs.dart';
import '../helpCenter.dart';
import '../welcomePage.dart';

class ParentSettings extends StatefulWidget {
  ParentSettings(this.childrenSnapshot, this.parent);

  final childrenSnapshot;
  final parent;
  @override
  _ParentSettingsState createState() =>
      _ParentSettingsState(this.childrenSnapshot, this.parent);
}

class _ParentSettingsState extends State<ParentSettings>
    with SingleTickerProviderStateMixin {
  _ParentSettingsState(this.childrenSnapshot, this.parent);

  TabController _tabController;
  final childrenSnapshot;
  final QuerySnapshot parent;
  @override
  void initState() {
    bottomNavigationIndex = 4;
    subBottomNavigationIndex = 0;
    _tabController = TabController(vsync: this, length: 6, initialIndex: 0);
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
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "ACCOUNT",
                    style: TextStyle(fontSize: 16, color: Colors.orangeAccent),
                  ),
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
                  onTap: () {
                    _toggleTab(2);
                  },
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
                            title: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Are you sure?"),
                              ],
                            ),
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
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Remove account?"),
                              ],
                            ),
                            actions: [
                              FlatButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () async {
                                  await Firestore.instance
                                      .document(
                                          'users/${parent.documents[0].documentID}')
                                      .delete();

                                  FirebaseUser user =
                                      await FirebaseAuth.instance.currentUser();
                                  user.delete();
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
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  thickness: 1,
                  color: Colors.black54,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, top: 10),
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
                  onTap: () {
                    _toggleTab(3);
                  },
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
                  onTap: () {
                    _toggleTab(4);
                  },
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
            Notifications(),
            AboutUs(),
            HelpCenter(parent),
            Container(),
          ],
        ),
      ),
    );
  }
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    subBottomNavigationIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "NOTIFICATIONS",
                  style: TextStyle(fontSize: 16, color: Colors.orangeAccent),
                ),
              ),
            ),
            Container(
              child: ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.chat,
                  size: 30,
                ),
                title: Text(
                  "Admin Chat",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: CupertinoSwitch(
                  activeColor: Color.fromRGBO(23, 142, 137, 1),
                  value: Settings().parentAdminNotification,
                  onChanged: (bool value) {
                    setState(() {
                      Settings().parentAdminNotification =
                          !Settings().parentAdminNotification;
                      Settings().saveToLocalStorage();
                    });
                  },
                ),
              ),
            ),
            Container(
              child: ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.chat,
                  size: 30,
                ),
                title: Text(
                  "Parent Group Chat",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: CupertinoSwitch(
                  activeColor: Color.fromRGBO(23, 142, 137, 1),
                  value: Settings().parentGroupNotify,
                  onChanged: (bool value) {
                    setState(() {
                      Settings().parentGroupNotify =
                          !Settings().parentGroupNotify;
                      Settings().saveToLocalStorage();
                    });
                  },
                ),
              ),
            ),
            Container(
              child: ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.chat,
                  size: 30,
                ),
                title: Text(
                  "Upcoming Events",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: CupertinoSwitch(
                  activeColor: Color.fromRGBO(23, 142, 137, 1),
                  value: Settings().eventNotify,
                  onChanged: (bool value) {
                    setState(() {
                      Settings().eventNotify = !Settings().eventNotify;
                      Settings().saveToLocalStorage();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Settings {
  bool parentAdminNotification = true;
  bool parentGroupNotify = true;
  bool eventNotify = true;
  final LocalStorage storage = new LocalStorage('buildabrain');
  static final Settings _settings = Settings._internal();
  factory Settings() {
    return _settings;
  }
  Settings._internal();
  Future<void> loadFromLocalStorage() async {
    await storage.ready;
    this.parentAdminNotification = storage.getItem("parentAdminNotification") ??
        this.parentAdminNotification;
    this.parentGroupNotify =
        storage.getItem("parentGroupNotify") ?? this.parentGroupNotify;
    this.eventNotify =
        storage.getItem("parentAdminNotification") ?? this.eventNotify;
  }

  Future<void> resetToDefault() async {
    await storage.ready;
    await storage.clear();
    await loadFromLocalStorage();
  }

  Future<void> saveToLocalStorage() async {
    await storage.ready;
    storage.setItem('parentAdminNotification', this.parentAdminNotification);
    storage.setItem('parentGroupNotify', this.parentGroupNotify);
    storage.setItem('eventNotify', this.eventNotify);
  }
}
