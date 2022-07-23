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
}
