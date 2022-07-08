import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/HomePage.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int activeTab= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: getFooter(),
      body: getBody(),
      );
  }

  //Footer
  getFooter() {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Color.fromRGBO(250, 250, 250, 1)),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  activeTab= 0;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.home_rounded, color: Color.fromRGBO(50, 0, 100, 1), size: 30),
                  Text('Home', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Color.fromRGBO(50, 0, 100, 1), fontSize: 12)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  activeTab= 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search_rounded, color: Color.fromRGBO(50, 0, 100, 1), size: 30),
                  Text('Explore', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Color.fromRGBO(50, 0, 100, 1),fontSize: 12)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  activeTab= 2;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person_rounded, color: Color.fromRGBO(50, 0, 100, 1), size: 30),
                  Text('Me', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Color.fromRGBO(50, 0, 100, 1), fontSize: 12)),
                ],
              ),
            ),
          ]
        ),
      )
    );
  }

  getBody() {
    return IndexedStack(
      index: activeTab,
      children: [
        HomePage(),
        Center(
            child: Text('Search', style: TextStyle(fontSize: 20, color: Color.fromRGBO(50, 0, 100, 1)))
        ),
        Center(
            child: Text('Me', style: TextStyle(fontSize: 20, color: Color.fromRGBO(50, 0, 100, 1)))
        )
      ],
    );
  }
}


