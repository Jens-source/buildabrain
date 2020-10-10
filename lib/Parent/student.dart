import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Student extends StatefulWidget {
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return new Scaffold(
        body: new ListView(children: <Widget>[
      Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: height / 3,
              width: width,
              child: Material(
                color: Colors.blue,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(100)),
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white70,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                    padding: EdgeInsets.only(left: 70, top: 50),
                    child: Text(
                      "Sally's Performance",
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    )),
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                    child: Container(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            "lib/Assets/cat1.jpg",
                          ),
                        )))),
          ],
        ),
      ),
      Center(
        child: Container(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            "Rankings",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
      Container(
        child: Row(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 90, right: 10, bottom: 10, top: 10),
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      border: Border.all(width: 2.0, color: Colors.blue)),
                  child: Center(
                      child: Text(
                    "All",
                    style: TextStyle(color: Colors.blue),
                  ))),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    border: Border.all(width: 2.0, color: Colors.orange)),
                child: Center(
                    child: Text(
                  "M",
                  style: TextStyle(color: Colors.orange),
                )),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      border: Border.all(width: 2.0, color: Colors.purple)),
                  child: Center(
                      child: Text(
                    "I",
                    style: TextStyle(color: Colors.purple),
                  ))),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      border: Border.all(width: 2.0, color: Colors.redAccent)),
                  child: Center(
                      child: Text(
                    "P",
                    style: TextStyle(color: Colors.redAccent),
                  ))),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        border:
                            Border.all(width: 2.0, color: Colors.purpleAccent)),
                    child: Center(
                        child: Text(
                      "S",
                      style: TextStyle(color: Colors.purpleAccent),
                    ))))
          ],
        ),
      ),
      ListTile(
          title: Text("Mindmap"),
          subtitle: Container(
            padding: EdgeInsets.only(top: 10),
            child: LinearPercentIndicator(
              width: 300,
              lineHeight: 10.0,
              percent: 0.5,
              backgroundColor: Colors.black12,
              progressColor: Colors.orange,
            ),
          )),
      ListTile(
          title: Text("Mathematics"),
          subtitle: Container(
            padding: EdgeInsets.only(top: 10),
            child: LinearPercentIndicator(
              width: 300,
              lineHeight: 10.0,
              percent: 0.8,
              backgroundColor: Colors.black12,
              progressColor: Colors.purple,
            ),
          )),
      ListTile(
          title: Text("Phonics"),
          subtitle: Container(
            padding: EdgeInsets.only(top: 10),
            child: LinearPercentIndicator(
              width: 300,
              lineHeight: 10.0,
              percent: 0.3,
              backgroundColor: Colors.black12,
              progressColor: Colors.redAccent,
            ),
          )),
      ListTile(
          title: Text("Science"),
          subtitle: Container(
            padding: EdgeInsets.only(top: 10),
            child: LinearPercentIndicator(
              width: 300,
              lineHeight: 10.0,
              percent: 0.7,
              backgroundColor: Colors.black12,
              progressColor: Colors.purpleAccent,
            ),
          )),
    ]));
  }
}

class All extends StatefulWidget {
  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: Text("All"),
    );
  }
}

class Mindmap extends StatefulWidget {
  @override
  _MindmapState createState() => _MindmapState();
}

class _MindmapState extends State<Mindmap> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: Text("Mindmap"),
    );
  }
}

class Mathematics extends StatefulWidget {
  @override
  _MathematicsState createState() => _MathematicsState();
}

class _MathematicsState extends State<Mathematics> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: Text("Mathematics"),
    );
  }
}

class Science extends StatefulWidget {
  @override
  _ScienceState createState() => _ScienceState();
}

class _ScienceState extends State<Science> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: Text("Science"),
    );
  }
}

class Phonics extends StatefulWidget {
  @override
  _PhonicsState createState() => _PhonicsState();
}

class _PhonicsState extends State<Phonics> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: Text("Science"),
    );
  }
}
