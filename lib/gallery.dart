
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List<String> word = [
    "Pre-K",
    "Junior",
    "Advanced"
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Center(
                  child:
                  Text("All Photos", style: TextStyle(
                      fontSize: 30
                  ),)),
              SizedBox(
                height: 20,
              ),

              CarouselSlider.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int itemIndex) =>

                      Container(
                        padding: EdgeInsets.all(10),
                        child:
                        Container(

                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  alignment: Alignment(-.2, 0),
                                  image: AssetImage(
                                      'lib/Assets/cat${itemIndex + 1}.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black54, BlendMode.darken)
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))
                          ),
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(bottom: 70),
                          child: Text(
                            word[itemIndex],
                            style: Theme
                                .of(context)
                                .textTheme
                                .display1
                                .copyWith(color: Colors.white, fontSize: 60),
                          ),
                        )

                      )
              ),

                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[

                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    child:
                      Container(
                        height: 100,
                        width: 100,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                alignment: Alignment(-.2, 0),
                                image: AssetImage(
                                    'lib/Assets/jun1.jpg'),
                                fit: BoxFit.cover,

                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5))
                        ),



                  )
              ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child:
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment(-.2, 0),
                                      image: AssetImage(
                                          'lib/Assets/jun2.jpg'),
                                      fit: BoxFit.cover,

                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),



                              )
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child:
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment(-.2, 0),
                                      image: AssetImage(
                                          'lib/Assets/jun3.jpg'),
                                      fit: BoxFit.cover,

                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),



                              )
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[

                          Container(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                              child:
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment(-.2, 0),
                                      image: AssetImage(
                                          'lib/Assets/jun4.jpg'),
                                      fit: BoxFit.cover,

                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),



                              )
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child:
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment(-.2, 0),
                                      image: AssetImage(
                                          'lib/Assets/jun5.jpg'),
                                      fit: BoxFit.cover,

                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),



                              )
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child:
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment(-.2, 0),
                                      image: AssetImage(
                                          'lib/Assets/jun6.jpg'),
                                      fit: BoxFit.cover,

                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),



                              )
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[

                          Container(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                              child:
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment(-.2, 0),
                                      image: AssetImage(
                                          'lib/Assets/jun7.jpg'),
                                      fit: BoxFit.cover,

                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),



                              )
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child:
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment(-.2, 0),
                                      image: AssetImage(
                                          'lib/Assets/jun8.jpg'),
                                      fit: BoxFit.cover,

                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),



                              )
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child:
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment(-.2, 0),
                                      image: AssetImage(
                                          'lib/Assets/jun9.jpg'),
                                      fit: BoxFit.cover,

                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),



                              )
                          )
                        ],
                      )
                    ],
                  )
            ]

        )
    );
  }

}