import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../components/MainPageView.dart';
import '../components/novelCard.dart';
import '../network/DataProvider.dart';

//home page constructor
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//home page state
class _HomePageState extends State<HomePage> {
  //build
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataProvider().getUserData(), builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (!snapshot.hasData) {
        return Container();
      } else {
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
            Container(
                height: 70,
                width: 150,
                padding: EdgeInsets.only(right: 10),
                child: Center(
                    child: Text(
                        userName.toLowerCase().replaceAll(RegExp(' '), '_'),
                        style: TextStyle(
                            color: themeColor(),
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis)
                    )
                )
            ),
            Container(
                padding: EdgeInsets.only(right: 15),
                height: 70,
                child: Center(
                    child: CircleAvatar(
                        backgroundImage: MemoryImage(convertBase64Image(userImage)),
                        radius: 25)
                )
            ),
          ],
          expandedHeight: size.height*0.45,
          flexibleSpace: FlexibleSpaceBar(
            background: MainPageView(),
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
                            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                            child: genreText('New Arrivals'),
                          ),
                          Container(
                            height: 1,
                            width: size.width*0.8,
                            color: themeColor(),
                            margin: const EdgeInsets.only(left: 15, bottom: 15),
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
                            child: genreText('Romance'),
                          ),
                          Container(
                            height: 1,
                            width: size.width*0.8,
                            color: themeColor(),
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
                                separatorBuilder: (context, _)=> const SizedBox(width: 10),
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
                            child: genreText('Psychological'),
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

  //widgets and functions:
  //novel card
  Widget _buildCard(String userData, int genre, int index) {
    List<String> userDataArray= userData.split('%');
    String userId= userDataArray[2];
    return GestureDetector(
        onTap: () {
          //just do nothing for a while
        },
        child: NovelCard(userId, genre, index),
    );
  }

  //user preference novel image function
  Future<String> userPrefNovelImageCode() async {
    final userPrefList= await DataProvider().getString('user', 'user_pref');
    if (userPrefList!=null) {
      return userPrefList;
    } else {
      return '0';
    }
  }

  //image conversion
  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }

  //theme color
  Color themeColor() {
    return Color.fromRGBO(50, 0, 100, 1);
  }

  //genre text
  Text genreText(String string) {
    return Text(
        string,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeColor())
    );
  }
}

