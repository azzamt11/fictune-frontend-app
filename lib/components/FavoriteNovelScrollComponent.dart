import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';
import 'NovelDirectCard.dart';

class MyNovelScrollComponent extends StatefulWidget {
  final String token;
  const MyNovelScrollComponent({Key? key, required this.token}) : super(key: key);

  @override
  State<MyNovelScrollComponent> createState() => _MyNovelScrollComponentState();
}

class _MyNovelScrollComponentState extends State<MyNovelScrollComponent> {
  bool loadingState= true;
  int loadingCount=0;
  List<String> novelData= [];
  List<String> novelsList= [];
  @override
  Widget build(BuildContext context) {
    if (loadingState==true && loadingCount<2) {
      setState(() {loadingState=false;});
      getMyNovelsData();
    } else if (loadingCount>=2) {
      setState(() {loadingState=false;});
    }
    return getMyNovelsList();
  }

  Widget getMyNovelsList() {
    var size= MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: novelWidgetList(novelsList),
      )
    );
  }

  List<Widget> novelWidgetList(List<String> novelsList) {
    List<Widget> widgetList= [];
    var size= MediaQuery.of(context).size;
    if (loadingState) {
      for (int i=0; i<4; i++) {
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
    } else {
      for (int i=0; i<max(novelData.length-1, 1); i++) {
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
    }

    return widgetList;
  }

  Future<void> getMyNovelsData() async{
    List<String> myNovelData= [];
    print('step_026 (mnsc): get my novels data in progress getting string with key myNovelData');
    String? myNovelsDataString= await NetworkHandler().getString('user', 'myNovelData');
    if (myNovelsDataString!=null&& myNovelsDataString!='zero' && myNovelsDataString!='error') {
      List<String> myNovelsDataArray= myNovelsDataString.split('<divider%71>');
      for (int i=0; i<max(myNovelsDataArray.length-1, 1); i++) {
        myNovelData.add(myNovelsDataArray[i]);
      }
    } else if (myNovelsDataString=='zero'){
      print('zero my novel data detected');
      myNovelData.add('zero');
    } else {
      List<List<String>> myNovelsDataArray= await NetworkHandler().getUserNovels(widget.token); //['success', novelId, novelTitle, novelImage])
      if (myNovelsDataArray[0][0]=='success') {
        for (int i=0; i<myNovelsDataArray.length; i++) {
          myNovelData.add(myNovelsDataArray[i][1]+ '<divider%83>'+ myNovelsDataArray[i][2] +'<divider%83>' + myNovelsDataArray[i][3]);
        }
      } else {
        myNovelData.add('error');
        loadingState= true;
        loadingCount++;
      }
    }
    setState(() {
      novelData= myNovelData;
    });
  }

  /*Widget getFavoriteNovelsList() {
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

  Future<String> getFavoriteNovelData() async {
    String token= widget.responseList[1];
    String novelData= '';
    String userLikedNovelsIndices;
    print('step_005 (on MeSlide): get favorite novel data in progress');
    String key0= 'userLikedNovelsIndices';
    String? userLikedNovelsIndicesFromStorage= await NetworkHandler().getString('user', key0);
    if (userLikedNovelsIndicesFromStorage==null) {
      List<String> userLikedNovelsIndicesArray= await NetworkHandler().getUserLikedNovelIndices(token);
      userLikedNovelsIndices= userLikedNovelsIndicesArray[1];
    } else {
      userLikedNovelsIndices= userLikedNovelsIndicesFromStorage;
    }
    if (userLikedNovelsIndices!='error' && userLikedNovelsIndices!='zero') {
      List<String> userLikedNovelIndexList= userLikedNovelsIndices.split('%');
      for (int i=0; i<max(userLikedNovelIndexList.length-1, 1); i++) {
        if (userLikedNovelIndexList[i]!='null') {
          String key= 'novelData'+userLikedNovelIndexList[i];
          print('step_006 (on MeSlide): iteration $i getting file with key: $key');
          String? novelDataForIthIteration= await NetworkHandler().getString('user', key);
          if (novelDataForIthIteration!=null) {
            print('step_007 (on MeSlide): novel data for iteration $i for key: $key is found, insert to novelData with separator <divider%71>...');
            novelData= novelData+ novelDataForIthIteration + '<divider%71>';
          } else {
            print('step_007b (on MeSlide): novel data for iteration $i for key: $key is not found. continue to the next iteration');
          }
        } else {
          print('step_006 (interrupted): userLikedNovelIndexList[i]==null');
          return 'zero';
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

  }*/
}
