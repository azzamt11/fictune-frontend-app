import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';

class MeSlide extends StatefulWidget {
  final List<String> responseList;
  const MeSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<MeSlide> createState() => _MeSlideState();
}

class _MeSlideState extends State<MeSlide> {
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    String userImage= widget.responseList[4];
    String userUserData= widget.responseList[5];
    String userBillingData= widget.responseList[6];
    String coin= userBillingData.split('*')[0];
    String userUserName= userUserData.split('*')[0];
    var themeColor= AppTheme.themeColor;
    return Scaffold(
      body: Column(
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
            height: 1000,
            width: size.width,
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: size.width,
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Liked novels', style: TextStyle(fontSize: 20, color: AppTheme.themeColor)),
                      Container(
                        height: 1,
                        width: size.width*0.8,
                        color: const Color.fromRGBO(50, 0, 100, 1),
                        margin: const EdgeInsets.only(left: 15, bottom: 15),
                      ),
                      SizedBox(
                        height: favoriteHeight(),
                        width: size.width,
                        child: novelField('liked'),
                      ),
                    ]
                  )
                ),

              ]
            )
          ),
        ],
      )
    );
  }

  Widget novelField(String category) {
    return Container(height: 100);
  }

  double favoriteHeight() {
    return 300;
  }
}
