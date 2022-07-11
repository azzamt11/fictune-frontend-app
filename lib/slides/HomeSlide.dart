import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../components/MainPageView.dart';
import '../components/novelCard.dart';
import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/DataProvider.dart';

//home page constructor
class HomeSlide extends StatefulWidget {
  final List<String> responseList;
  const HomeSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<HomeSlide> createState() => _HomeSlideState();
}

//home page state
class _HomeSlideState extends State<HomeSlide> {
  //build
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    String userName= widget.responseList[2];
    String userImage= widget.responseList[4];
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
                            color: AppTheme.themeColor,
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
                        backgroundImage: MemoryImage(AppFunctions().convertBase64Image(userImage)),
                        radius: 25)
                )
            ),
          ],
          expandedHeight: size.height*0.5,
          flexibleSpace: FlexibleSpaceBar(
            background: MainPageView(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              child: Container(
                margin: EdgeInsets.only(top: 0),
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
                            color: AppTheme.themeColor,
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
                                itemBuilder: (context, index)=> _buildCard(widget.responseList, 0, index),
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
                            color: AppTheme.themeColor,
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
                                itemBuilder: (context, index)=> _buildCard(widget.responseList, 1, index),
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
                                itemBuilder: (context, index)=> _buildCard(widget.responseList, 2, index),
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
  Widget _buildCard(List<String> responseList, int genre, int index) {
    String token= responseList[1];
    String userId= responseList[3];
    print('user id: $userId, user token: $token, genre: $genre, index: $index  at build card (HomePage)');
    return GestureDetector(
        onTap: () {
          //just do nothing for a while
        },
        child: NovelCard(userId: userId, genre: '$genre', index: '$index', token: token),
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

  //genre text
  Text genreText(String string) {
    return Text(
        string,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.themeColor,),
    );
  }
}

