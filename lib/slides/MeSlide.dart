import 'dart:math';

import 'package:fictune_frontend/network_and_data/NetworkHandler.dart';
import 'package:flutter/material.dart';

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
  bool favoriteNovelLoadingState=true;
  bool myNovelLoadingState=true;
  int colorState= 0;
  int activeSubWidget= 0;

  Future<String> getFavoriteNovelData() async {
    String novelData= '';
    print('step_005 (on MeSlide): get favorite noval data in progress');
    String key0= 'userLikedNovelsIndices';
    String? userLikedNovelsIndices= await NetworkHandler().getString('user', key0);
    if (userLikedNovelsIndices!=null && userLikedNovelsIndices!='zero') {
      List<String> userLikedNovelIndexList= userLikedNovelsIndices.split('%');
      for (int i=0; i<max(userLikedNovelIndexList.length-1, 1); i++) {
        String key= 'novelData'+userLikedNovelIndexList[i];
        print('step_006 (on MeSlide): iteration $i getting file with key: $key');
        String? novelDataForIthIteration= await NetworkHandler().getString('user', key);
        if (novelDataForIthIteration!=null) {
          print('step_007 (on MeSlide): novel data for iteration $i for key: $key is found, insert to novelData with separator <divider%71>...');
          novelData= novelData+ novelDataForIthIteration + '<divider%71>';
        } else {
          print('step_007b (on MeSlide): novel data for iteration $i for key: $key is not found. continue to the next iteration');
        }
      }
      print('step_008 (on MeSlide): novel Data has been fulfilled, returning the data');
      return novelData;
    } else if (userLikedNovelsIndices!=null && userLikedNovelsIndices=='zero') {
      return 'zero';
    } else {
      print('step_006b (on MeSlide): indices not found. Returning null string');
      return novelData;
    }

  }

  Future<String> getMyNovelData() async {
    final String? myNovelData= await NetworkHandler().getString('user', 'myNovelData');
    if (myNovelData!=null) {
      return myNovelData;
    } else {
      return 'error';
    }
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
                    // a certain action will be added here.
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

  Widget getMyNovelsList() {
    var size= MediaQuery.of(context).size;
    return FutureBuilder(
      future: getMyNovelData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String myNovelDataString= snapshot.data.toString();
          if (myNovelDataString!='zero' && myNovelDataString!='error') {
            List<String> myNovelData= myNovelDataString.split('<divider%71>');
            return Column(
              children: novelDirectCard(myNovelData, true),
            );
          } else if (myNovelDataString=='zero') {
            return Column(
              children: [SizedBox(
                height: 100,
                width: size.width,
                child: Center(child: Text("You have not made any novels yet", style: TextStyle(fontSize: 18, color: AppTheme.themeColor))),
              )],
            );
          } else {
            return Column(
              children: [SizedBox(
                height: 100,
                width: size.width,
                child: Center(child: Text("Network Error", style: TextStyle(fontSize: 18, color: AppTheme.themeColor))),
              )],
            );
          }
        } else {
          return Column(
            children: widgetList(['0', '0', '0', '0'],false),
          );
        }
      },
    );
  }

  Widget getFavoriteNovelsList() {
    var size= MediaQuery.of(context).size;
    return FutureBuilder(
      future: getFavoriteNovelData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('step_009: snapshot has data');
          String favoriteNovelDataString= snapshot.data.toString();
          if (favoriteNovelDataString=='zero') {
            print('step_010: novel data string zero, returning You-have-not-liked-any-novels-yet-single-widget widget list');
            return Column(
                children: [SizedBox(
                  height: 100,
                  width: size.width,
                  child: Center(child: Text("You have not liked any novels yet", style: TextStyle(fontSize: 18, color: AppTheme.themeColor))),
                )],
            );
          } else if (favoriteNovelDataString=='') {
            return Column(
              children: [SizedBox(
                height: 100,
                width: size.width,
                child: Center(child: Text("Network Error", style: TextStyle(fontSize: 18, color: AppTheme.themeColor))),
              )],
            );
          } else {
            print('step_010: novel data string found, separating the novel data with separator <divider%71>');
            String secondElementsOnCheck= favoriteNovelDataString[1];
            print('the second element after separating with <divider%71> is: $secondElementsOnCheck');
            List<String> favoriteNovelData= favoriteNovelDataString.split('<divider%71>');
            print('step_011: returning the novel Direct Card with the data');
            return Column(
              children: novelDirectCard(favoriteNovelData, true),
            );
          }
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
    for (int i=0; i<novelsList.length; i++) {
      widgetList.add(Container(
          height: 160,
          width: size.width,
          padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
          child: Row(
              children: [
                Container(
                  height: 150,
                  width: 100,
                  color: const Color.fromRGBO(245, 245, 245, 1),
                  child: Center(
                    child: Text('Loading...', style: TextStyle(fontSize: 18, color: AppTheme.themeColor)),
                  ),
                ),
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
    return widgetList;
  }

  List<Widget> novelDirectCard(List<String> novelData, bool isFavoriteNovel) {
    var size= MediaQuery.of(context).size;
    List<Widget> widgetList= [];
    for (int i=0; i<max(novelData.length-1, 1); i++) {
      String novelDatai= novelData[i];
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
      return [SizedBox(height: 160, width: size.width, child: const Center(child: Text("You haven't liked any novels")))];
    } else {
      return widgetList;
    }
  }
}