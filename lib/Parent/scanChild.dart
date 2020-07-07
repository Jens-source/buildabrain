

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ScanChild extends StatefulWidget {
  ScanChild(this.childrenSnap ,this.tabController, this.tabs);
  final childrenSnap;
  final tabController;
  final tabs;

  @override
  _ScanChildState createState() => _ScanChildState(this.childrenSnap, this.tabController, this.tabs);
}

class _ScanChildState extends State<ScanChild> with SingleTickerProviderStateMixin{
  _ScanChildState(this.childrenSnap, this.tabController, this.tabs);
  TabController tabController;
  final tabs;
  QuerySnapshot childrenSnap;

  List<Widget> qrCode = [];

  List <bool> loading = [];





  Future addQrCodes() {


    for(int i = 0; i < childrenSnap.documents.length; i++){
      qrCode.add(Container(

        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text("Buildabrain Scanner", style: TextStyle(
                    fontSize: 18
                  ),),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Use the Buildabrain Scanner on\nyour phone to scan in ${childrenSnap.documents[i].data['firstName']}."),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color:Color.fromRGBO(23, 142, 137, 1), width: 10)

                  ),
                  child:  Container(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image:childrenSnap.documents[i].data['qrCodeUrl'],
                  )


                  )

                )

                
              ],
            )
          ],
        ),
      ));
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: childrenSnap.documents.length, vsync: this);
    setState(() {
      addQrCodes();
      if(loading.length == 0){
        for(int i = 0; i < childrenSnap.documents.length; i++){
          loading.add(false);
        }
      }

    });
  }


  @override
  Widget build(BuildContext context) {

    if(qrCode.length == 0){
      return new Center(
        child: CircularProgressIndicator(),
      );
    }

    return new Scaffold(
      backgroundColor: Colors.white,


      body: Container(
        padding: EdgeInsets.only(top: 80),
        child: Column(

          children: [
            TabBar(
                controller: tabController,
                labelStyle: TextStyle(fontSize: 14),
                unselectedLabelColor: Colors.black54,
                labelColor: Colors.black,
                indicatorColor: Color.fromRGBO(166, 133, 119, 1),
                isScrollable: false,
                tabs: tabs
            ),


            Expanded(
              child: new TabBarView(
                  controller: tabController,
                  children:
                  qrCode

              ),
            )
          ],




        ),
      ),

    );
  }
}
