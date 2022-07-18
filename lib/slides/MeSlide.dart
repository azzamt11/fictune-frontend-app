import 'dart:math';

import 'package:fictune_frontend/network_and_data/NetworkHandler.dart';
import 'package:flutter/material.dart';

import '../components/NovelCard.dart';
import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';

class MeSlide extends StatefulWidget {
  final List<String> responseList;
  const MeSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<MeSlide> createState() => _MeSlideState();
}

class _MeSlideState extends State<MeSlide> {

  Future<String> getFavoriteNovelIndices() async {
    final String token = widget.responseList[1];
    final List<String> favoriteNovelData= await NetworkHandler().getUserLikedNovelIndices(token);
    String favoriteNovelIndices= favoriteNovelData[1];
    return favoriteNovelIndices;
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: getSuperBody(),
      )
    );
  }

  Widget getSuperBody() {
    var size= MediaQuery.of(context).size;
    String userImage= widget.responseList[4];
    String userUserData= widget.responseList[5];
    String userBillingData= widget.responseList[6];
    String coin= userBillingData.split('*')[0];
    String userUserName= userUserData.split('*')[0];
    return Container(
      constraints: BoxConstraints(
        minHeight: size.height,
        maxWidth: size.width,
      ),
      child: Column(
        children: [
          SizedBox(
              height: 300,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: MemoryImage(AppFunctions().convertBase64Image(userImage)),
                    radius: 40,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(userUserName, style: TextStyle(fontSize: 20, color: AppTheme.themeColor))
                  ),
                  SizedBox(
                      height: 50,
                      width: 120,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(userBillingData.split('*')[1]+ ' * ', style: TextStyle(fontSize: 15, color: AppTheme.themeColor)),
                            Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/coin.jpg')))
                            ),
                            Text(coin, style: TextStyle(fontSize: 15, color: AppTheme.themeColor)),
                          ]
                      )
                  ),
                  const SizedBox(height: 30),
                ],
              )
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: size.height-300,
              maxWidth: size.width,
            ),
            child: Column(
                children: [
                  Container(
                      height: 50,
                      width: size.width,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Liked novels', style: TextStyle(fontSize: 20, color: AppTheme.themeColor)),
                          Text('Your novels', style: TextStyle(fontSize: 20, color: AppTheme.themeColor)),
                        ],
                      )
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: size.height-350,
                      maxWidth: size.width,
                    ),
                    child: getFavoriteNovelsList(),
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
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Row(
            children: [
              Container(height: 150, width: 100, color: const Color.fromRGBO(245, 245, 245, 1)),
              const SizedBox(width: 10),
              SizedBox(
                height: 150,
                width: size.width-140,
                child: Column(
                  children: [
                    Container(height: 50, width: 150, color: const Color.fromRGBO(245, 245, 245, 1)),
                    const SizedBox(height: 10),
                    Container(height: 30, width: max(size.width-140, 150), color: const Color.fromRGBO(245, 245, 245, 1)),
                    const SizedBox(height: 5),
                    Container(height: 30, width: max(size.width-140, 150), color: const Color.fromRGBO(245, 245, 245, 1)),
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
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      child: Row(
          children: [
            SizedBox(
                height: 150,
                width: 100,
                child: GestureDetector(
                  onTap: () {
                    //just do nothing for a while
                  },
                  child: NovelCard(index: '$index', token: token, custom: 1, genre: '0', userId: '1',),
                ),
            ),
            const SizedBox(width: 10),
            Container(
                height: 150,
                width: size.width-140,
                child: Column(
                    children: [
                      Container(height: 50, width: 150, color: const Color.fromRGBO(245, 245, 245, 1)),
                      const SizedBox(height: 10),
                      Container(height: 30, width: max(size.width-140, 150), color: const Color.fromRGBO(245, 245, 245, 1)),
                      const SizedBox(height: 5),
                      Container(height: 30, width: max(size.width-140, 150), color: const Color.fromRGBO(245, 245, 245, 1)),
                    ]
                )
            ),
          ]
      ),
    );
  }

}