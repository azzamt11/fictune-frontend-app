import 'dart:math';

import 'package:fictune_frontend/network_and_data/NetworkHandler.dart';
import 'package:flutter/material.dart';

import '../components/NovelCard.dart';
import '../components/NovelDataCard.dart';
import '../components/NovelDirectCard.dart';
import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';

class MeSlide extends StatefulWidget {
  final List<String> responseList;
  const MeSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<MeSlide> createState() => _MeSlideState();
}

class _MeSlideState extends State<MeSlide> {
  final List<Color> colorArray= [Colors.white, AppTheme.themeColor];
  int colorState= 0;
  int activeSubWidget= 0;

  Future<String> getFavoriteNovelIndices() async {
    final String token = widget.responseList[1];
    final List<String> favoriteNovelData= await NetworkHandler().getUserLikedNovelIndices(token);
    String favoriteNovelIndices= favoriteNovelData[1];
    return favoriteNovelIndices;
  }

  Future<String> getMyNovelData() async {
    final String token = widget.responseList[1];
    final List<List<String>> myNovelData= await NetworkHandler().getUserNovels(token);
    String myNovelDataString= '';
    for(int i =0; i<myNovelData.length; i++) {
      myNovelDataString= myNovelDataString+ myNovelData[i][0]+ '<divider%83>'+ myNovelData[i][1] + '<divider%83>'+ myNovelData[i][2]+ '<divider%71>';
    }
    return myNovelDataString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              GestureDetector(
                  child: const Icon(Icons.more_vert),
                  onTap: () {
                    // a certain action will be added here
                  }
              )
            ]
        ),
        body: getSuperBody(),
    );
  }

  Widget getSuperBody() {
    var size= MediaQuery.of(context).size;
    String userImage= widget.responseList[4];
    String userUserData= widget.responseList[5];
    String userBillingData= widget.responseList[6];
    String coin= userBillingData.split('<divider%54>')[0];
    String userUserName= userUserData.split('<divider%54>')[0];
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
              height: 220,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 41,
                    backgroundColor: AppTheme.themeColor,
                    child: CircleAvatar(
                      backgroundImage: MemoryImage(AppFunctions().convertBase64Image(userImage)),
                      radius: 40,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(userUserName, style: TextStyle(fontSize: 20, color: AppTheme.themeColor))
                  ),
                  SizedBox(
                      height: 40,
                      width: size.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Text(userBillingData.split('<divider%54>')[1], style: TextStyle(fontSize: 20, color: AppTheme.themeColor, fontWeight: FontWeight.bold))
                                )
                            ),
                            Container(
                              child: const Center(child: Text('Buy Coin', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold))),
                              height: 40,
                              width: 100,
                              margin: const EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(150, 50, 50, 1),
                              )
                            ),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      margin: const EdgeInsets.only(right: 15),
                                      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/coin.jpg')))
                                  ),
                                  Text(coin, style: TextStyle(fontSize: 18, color: AppTheme.themeColor)),
                                ],
                              ),
                            ),
                          ]
                      )
                  ),
                  const SizedBox(height: 30),
                ],
              )
          ),
          SizedBox(
            height: size.height-400,
            width: size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 50,
                      width: size.width,
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activeSubWidget=0;
                              });
                            },
                            child: Text('Liked novels', style: TextStyle(fontSize: 20, color: AppTheme.themeColor)),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activeSubWidget=1;
                              });
                            },
                            child: Text('My novels', style: TextStyle(fontSize: 20, color: AppTheme.themeColor)),
                          ),

                        ],
                      )
                  ),
                  SizedBox(
                    width: size.width-36,
                    child: Row(
                      children: [
                        Container(
                          height: 5,
                          width: 0.5*(size.width-36),
                          color: colorArray[1-activeSubWidget],
                        ),
                        Container(
                          height: 5,
                          width: 0.5*(size.width-36),
                          color: colorArray[activeSubWidget],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: size.width-34,
                    color: const Color.fromRGBO(50, 0, 100, 1),
                    margin: const EdgeInsets.only(bottom: 15),
                  ),
                  SizedBox(
                    height: size.height-471,
                    width: size.width,
                    child: IndexedStack(
                      index: activeSubWidget,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: getFavoriteNovelsList(),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: getMyNovelsList(),
                        ),

                      ]
                    )
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }

  Widget getFavoriteNovelsList() {
    return FutureBuilder(
      future: getFavoriteNovelIndices(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String favoriteNovelIndices= snapshot.data.toString();
          List<String> favoriteNovelIndicesList= favoriteNovelIndices.split('%');
          return Column(
            children: widgetList(favoriteNovelIndicesList, true),
          );
        } else {
          return Column(
            children: widgetList(['0', '0', '0', '0'],false),
          );
        }
      },
    );
  }

  Widget getMyNovelsList() {
    print('get my novels list in progress (next: get my novel data)');
    return FutureBuilder(
      future: getMyNovelData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('snapshot has data on my novels list: true');
          String myNovelDataString= snapshot.data.toString();
          List<String> myNovelData= myNovelDataString.split('<divider%71>');
          print('(next: novel direct card widget) my novel data string: '+ myNovelDataString);
          return Column(
            children: novelDirectCard(myNovelData),
          );
        } else {
          return Column(
            children: widgetList(['0', '0', '0', '0'],false),
          );
        }
      },
    );
  }

  List<Widget> widgetList(List<String> novelsList, bool loaded) {
    var size= MediaQuery.of(context).size;
    List<Widget> widgetList= [];
    if (loaded==true) {
      for (int i=0; i<novelsList.length; i++) {
        widgetList.add(buildCard(widget.responseList, int.parse(novelsList[i])));
      }
    } else {
      for (int i=0; i<novelsList.length; i++) {
        widgetList.add(Container(
            height: 160,
            width: size.width,
            padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
            child: Row(
                children: [
                  Container(height: 150, width: 100, color: const Color.fromRGBO(245, 245, 245, 1)),
                  const SizedBox(width: 10),
                  SizedBox(
                      height: 150,
                      width: size.width-146,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 35, width: 150, color: const Color.fromRGBO(245, 245, 245, 1)),
                            const SizedBox(height: 10),
                            Container(height: 100, width: max(size.width-146, 150), color: const Color.fromRGBO(245, 245, 245, 1)),
                          ]
                      )
                  ),
                ]
            )
        ));
      }
    }
    return widgetList;
  }

  Widget buildCard(List<String> responseList, int index) {
    var size= MediaQuery.of(context).size;
    String token= responseList[1];
    return Container(
      height: 160,
      width: size.width,
      padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
      child: Row(
          children: [
            SizedBox(
              height: 150,
              width: 100,
              child: GestureDetector(
                onTap: () {
                  //just do nothing for a while
                },
                child: NovelCard(index: '$index', token: token, custom: 2, genre: '0', userId: '1',),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
                height: 150,
                width: size.width-146,
                child: NovelDataCard(custom: 1, index: '$index', token: token),
            ),
          ]
      ),
    );
  }

  List<Widget> novelDirectCard(List<String> novelData) {
    var size= MediaQuery.of(context).size;
    List<Widget> widgetList= [];
    for (int i=0; i<max(novelData.length-1, 1); i++) {
      String novelDatai= novelData[i];
      print('novel data i : $novelDatai');
      widgetList.add(Container(
          height: 160,
          width: size.width,
          padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
          child: Row(
              children: [
                SizedBox(
                  height: 150,
                  width: 100,
                  child: GestureDetector(
                    onTap: () {
                      //just do nothing for a while
                    },
                    child: NovelDirectCard(novelData: novelData[i]),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                    height: 150,
                    width: size.width-146,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 150,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(novelData[i].split('<divider%83>')[1].split('<divider%69>')[0], style: TextStyle(fontSize: 20, color: AppTheme.themeColor, fontWeight: FontWeight.bold)),
                            )
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                              height: 100,
                              width: max(size.width-146, 150),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(novelData[i].split('<divider%83>')[1].split('<divider%69>')[1], style: TextStyle(fontSize: 17, color: AppTheme.themeColor)),
                              )
                          ),
                        ]
                    )
                ),
              ]
          )
      ));
    }
    if (widgetList==[]) {
      return [Container(height: 160, width: size.width, child: const Center(child: Text("You haven't liked any novels")))];
    } else {
      return widgetList;
    }
  }
}