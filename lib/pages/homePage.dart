import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/mainPageView.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getUserName(),builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (!snapshot.hasData) {return Container();}else {
        final String? userName= snapshot.data;
        return getBody(userName);
      }
    });
  }

  getBody(userName) {
    var size= MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.white,
          actions: [
            Container(height: 70, width: 150, child: Text(userName, style: TextStyle(color: Color.fromRGBO(50, 0, 100, 1), fontSize: 20))),
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
                            child: Container(
                              height: 150,
                              width: size.width,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Container(height: 150, color: Colors.redAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.greenAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.blueAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.yellowAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.purpleAccent, width: 100, margin: EdgeInsets.only(right: 10)),
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
                            child: Container(
                              height: 150,
                              width: size.width,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                separatorBuilder: (context, _)=> SizedBox(width: 10),
                                itemBuilder: (context, index)=> _buildCard(index),
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
                            child: Container(
                              height: 150,
                              width: size.width,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Container(height: 150, color: Colors.redAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.greenAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.blueAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.yellowAccent, width: 100, margin: EdgeInsets.only(right: 10)),
                                    Container(height: 150, color: Colors.purpleAccent, width: 100, margin: EdgeInsets.only(right: 10)),
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

  Widget _buildCard(int index) {
    return GestureDetector(
      onTap: () {
        //just do nothing for a while
      },
      child: Container(
        height: 150,
        width: 100,
        decoration: BoxDecoration(color: Colors.orange),
        child: Text('${index}th novel', style: TextStyle(fontSize: 20)),
      )
    );
  }

  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  Future<String?> getString(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_generateKey(userId, key));
  }

  Future<String> getUserName() async{
    final userName= await getString('user', 'user_name');
    if (userName!=null) {
      return userName;
    } else {
      return 'user';
    }
  }
}

