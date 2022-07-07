import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/mainPageView.dart';

//home page constructor
class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

//home page state
class _homePageState extends State<homePage> {
  //build
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getUserData(),builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (!snapshot.hasData) {return Container();}
      else {
        final String? userData= snapshot.data;
        return getBody(userData);
      }
    });
  }

  //home main body
  getBody(userData) {
    List<String> userDataArray= userData.split('%');
    String userName= userDataArray[0];
    String userImage= userDataArray[1];
    var size= MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.white,
          actions: [
            Container(height: 70, width: 150, padding: EdgeInsets.only(right: 10), child: Center(child: Text(userName.toLowerCase().replaceAll(RegExp(' '), '_'), style: TextStyle(color: Color.fromRGBO(50, 0, 100, 1), fontSize: 20, overflow: TextOverflow.ellipsis)))),
            Container(padding: EdgeInsets.only(right: 15), height: 70, child: Center(child: CircleAvatar(backgroundImage: MemoryImage(convertBase64Image(userImage)), radius: 25))),
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
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                separatorBuilder: (context, _)=> SizedBox(width: 10),
                                itemBuilder: (context, index)=> _buildCard(userData, 0, index),
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
                                itemBuilder: (context, index)=> _buildCard(userData, 1, index),
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
                            child: Text('Psycological', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(50, 0, 100, 1))),
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
                                itemBuilder: (context, index)=> _buildCard(userData, 2, index),
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

  //additional functions:
  //key generator
  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  //novel card
  Widget _buildCard(String userData, int genre, int index) {
    List<String> userDataArray= userData.split('%');
    String userToken= userDataArray[2];
    var imageCode= userPrefNovelImageCode();
    return GestureDetector(
        onTap: () {
          //just do nothing for a while
        },
        child: Container(
          height: 150,
          width: 100,
          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('http://ftunebackend.herokuapp.com/imageposts/$imageCode/$genre/$index'))),
          child: Text('${index}th novel', style: TextStyle(fontSize: 20)),
        )
    );
  }

  //user preference novel image function
  Future<String> userPrefNovelImageCode() async {
    final userPrefList= await getString('user', 'user_pref');
    if (userPrefList!=null) {
      return userPrefList;
    } else {
      return '0';
    }
  }

  //get string from shared pref
  Future<String?> getString(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_generateKey(userId, key));
  }

  //get user_name from shared pref
  Future<String> getUserData() async{
    final userName= await getString('user', 'user_name');
    final userAttribute= await getString('user', 'user_attribute');
    final userToken= await getString('user', 'token');
    if (userName!=null) {
      return '$userName%$userAttribute%$userToken';
    } else {
      return 'user';
    }
  }

  //image conversion
  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }
}

