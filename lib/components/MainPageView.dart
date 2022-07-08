import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({Key? key}) : super(key: key);

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Container(
      height: 380,
      child: PageView.builder(
        itemCount: 5,
        itemBuilder: (context, position) {
          return _buildPageItem(position);
        }
      )
    );
  }
  Widget _buildPageItem(int index) {
    return GestureDetector(
      onTap: () {
        //just do nothing for a while
      },
      child: Container(
        height: 380,
        decoration: BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/fictuneBackground1.jpg"), fit: BoxFit.cover,)),
      )
    );
  }
}

