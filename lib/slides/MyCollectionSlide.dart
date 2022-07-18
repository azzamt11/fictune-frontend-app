import 'dart:math';

import 'package:fictune_frontend/files/RawImageFiles.dart';
import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';

class MeSlide extends StatefulWidget {
  final List<String> responseList;
  const MeSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<MeSlide> createState() => _MeSlideState();
}

class _MeSlideState extends State<MeSlide> {
  late String token;
  late ScrollController _scrollController;
  double _scrollPosition= 0;
  late double viewHeight;
  List<List<String>> favoriteNovels= [];
  int favoriteNovelsLength=0;
  bool loadingFavoriteNovelsState= true;
  int novelCountState= 2;
  int currentScroll=0;

  @override
  void initState() {
    _scrollController= ScrollController();
    _scrollController.addListener(_scrollListener);
    setState(() {
      token= widget.responseList[1];
    });
    getFavoriteNovels('1', token);
    super.initState();
  }

  //widget main build
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    setState(() {
      viewHeight= size.height+20 + 160*currentScroll;
    });
    if (loadingFavoriteNovelsState==true && _scrollPosition > 95+ 160*currentScroll) {
      setState(() {
        currentScroll= currentScroll+ 2;
      });
    }
    int currentScrollMinusOne= max(1, currentScroll- 1);
    getFavoriteNovels('$currentScrollMinusOne', token);
    getFavoriteNovels('$currentScroll', token);
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
        controller: _scrollController,
        child: getBody(viewHeight),
      )
    );
  }

  //main widget body
  Widget getBody(double viewHeight) {
    var size= MediaQuery.of(context).size;
    String userImage= widget.responseList[4];
    String userUserData= widget.responseList[5];
    String userBillingData= widget.responseList[6];
    String coin= userBillingData.split('*')[0];
    String userUserName= userUserData.split('*')[0];
    return SizedBox(
      height: viewHeight,
      width: size.width,
      child: Column(
        children: [
          SizedBox(
              height: 500,
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
          SizedBox(
              height: viewHeight- 500,
              width: size.width,
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
                      height: 20,
                      width: size.width,
                      padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
                      child: Center(
                        child: Container(
                          color: const Color.fromRGBO(50, 0, 100, 1),
                          height: 1,
                        ),
                      )
                    ),
                    Container(
                      height: viewHeight- 570,
                      width: size.width,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: novelField('0', viewHeight- 29),
                    ),
                  ]
              ),
          ),
        ],
      ),
    );
  }

  //scroll handling
  _scrollListener() {
    setState(() {
      _scrollPosition= _scrollController.position.pixels;
    });
  }

  //liked novel widget
  Widget novelField(String category, double height) {
    var size= MediaQuery.of(context).size;
    return SizedBox(
      height: height,
      width: size.width- 30,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: favoriteNovelsLength,
        itemBuilder: ((context, index) {
          return Container(
            height: 160,
            width: size.width-30,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            child: Row(
              children: [
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(AppFunctions().convertBase64Image(favoriteNovels[index][1])))),
                ),
                SizedBox(
                  height: 150,
                  width: 300,
                  child: Center(
                    child: Text(favoriteNovels[index][0], style: TextStyle(fontSize: 15, color: AppTheme.themeColor)),
                  )
                )
              ],
            )
          );
        }),
      )
    );
  }

  Future<void> getFavoriteNovels(String index, String token) async{
    List<String> response= await NetworkHandler().getFavoritePost(token, index);
    if (response[0]!='error') {
      setState(() {
        favoriteNovels[int.parse(index)]= response;
        favoriteNovelsLength= favoriteNovels.length;
        print(favoriteNovels);
      });
    } else {
      String error= response[2];
      setState(() {
        favoriteNovels[int.parse(index)]= [error, RawImageFiles().noImage()];
        loadingFavoriteNovelsState= false;
      });
    }
  }
}
