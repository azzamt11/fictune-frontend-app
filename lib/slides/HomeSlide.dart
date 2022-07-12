import 'package:flutter/material.dart';

import '../components/MainPageView.dart';
import '../components/NovelCard.dart';
import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';

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
    String userImage= widget.responseList[4];
    String userUserData= widget.responseList[5];
    String userBillingData= widget.responseList[6];
    String coin= userBillingData.split('*')[0];
    String userUserName= userUserData.split('*')[0];
    var themeColor= AppTheme.themeColor;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.white,
          actions: [
            Container(
                height: 70,
                width: size.width*0.42,
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        userUserName,
                        style: TextStyle(
                            color: AppTheme.themeColor,
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis)
                    )
                )
            ),
            Container(
                padding: const EdgeInsets.only(right: 16),
                height: 70,
                child: Center(
                    child: CircleAvatar(
                        backgroundImage: MemoryImage(AppFunctions().convertBase64Image(userImage)),
                        radius: 25)
                )
            ),
          ],
          leadingWidth: size.width*0.46,
          leading: SizedBox(
            height: 70,
            child: Row(
              children: [
                SizedBox(
                  height: 70,
                  width: 51,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/coin.jpg'))),
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(coin, style: TextStyle(fontSize: 20, color: themeColor)))
                ),
              ]
            )
          ),
          expandedHeight: size.height*0.46,
          flexibleSpace: const FlexibleSpaceBar(
            background: MainPageView(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                height: 1320,
                color: Colors.white,
                child: Column(
                  children: [
                    novelCard('New Arrivals', 0),
                    novelCard('Romance', 1),
                    novelCard('Family', 2),
                    novelCard('Fantasy', 3),
                    novelCard('Science-Fiction', 4),
                    novelCard('Psychological', 5),
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
  Widget buildCard(List<String> responseList, int genre, int index) {
    String token= responseList[1];
    String userId= responseList[3];
    return GestureDetector(
        onTap: () {
          //just do nothing for a while
        },
        child: NovelCard(userId: userId, genre: '$genre', index: '$index', token: token),
    );
  }

  //novel card widget
  Widget novelCard(String genreName, int genre) {
    var size= MediaQuery.of(context).size;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: genreText(genreName),
          ),
          Container(
            height: 1,
            width: size.width*0.8,
            color: const Color.fromRGBO(50, 0, 100, 1),
            margin: const EdgeInsets.only(left: 15, bottom: 15),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              height: 150,
              width: size.width,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                separatorBuilder: (context, _)=> const SizedBox(width: 10),
                itemBuilder: (context, index)=> buildCard(widget.responseList, genre, index),
              ),
            ),
          )
        ]
    );
  }

  //genre text
  Text genreText(String string) {
    return Text(
        string,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.themeColor,),
    );
  }
}

