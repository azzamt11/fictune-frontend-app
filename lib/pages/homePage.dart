import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/mainPageView.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  getBody() {
    var size= MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15, bottom: 8, top: 8),
              child: Container(
                height: 50,
                width: 42,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), color: Colors.red,)
              )
            )
          ],
          expandedHeight: size.height*0.45,
          flexibleSpace: FlexibleSpaceBar(
            background: mainPageView(),
          )
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              child: Container(
                height: 1000,
                color: Colors.white,
                child: Column(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                              child: Text('New Arrivals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(50, 0, 100, 1))),
                          ),
                          Container(
                            height: 1,
                            width: size.width*0.8,
                            color: Color.fromRGBO(50, 0, 100, 1),
                            margin: EdgeInsets.only(left: 15, bottom: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: [
                                    Container(height: 150, color: Colors.redAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.greenAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.blueAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.yellowAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.grey, width: 100, margin: EdgeInsets.only(right: 10)),
                                  ]
                              ),
                            ),
                          )
                        ]
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                            child: Text('Romance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(50, 0, 100, 1))),
                          ),
                          Container(
                            height: 1,
                            width: size.width*0.8,
                            color: Color.fromRGBO(50, 0, 100, 1),
                            margin: EdgeInsets.only(left: 15, bottom: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: [
                                    Container(height: 150, color: Colors.redAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.greenAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.blueAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.yellowAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.grey, width: 100, margin: EdgeInsets.only(right: 10)),
                                  ]
                              ),
                            ),
                          )
                        ]
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                            child: Text('Horror', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(50, 0, 100, 1))),
                          ),
                          Container(
                            height: 1,
                            width: size.width*0.8,
                            color: Color.fromRGBO(50, 0, 100, 1),
                            margin: EdgeInsets.only(left: 15, bottom: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: [
                                    Container(height: 150, color: Colors.redAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.greenAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.blueAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.yellowAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.grey, width: 100, margin: EdgeInsets.only(right: 10)),
                                  ]
                              ),
                            ),
                          )
                        ]
                    ),
                  ]
                )
              )
            )
          )
        ),
      ]
    );
  }
}
