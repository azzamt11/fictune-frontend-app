import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';

class DebugSlide extends StatefulWidget {
  const DebugSlide({Key? key}) : super(key: key);

  @override
  State<DebugSlide> createState() => _DebugSlideState();
}

class _DebugSlideState extends State<DebugSlide> {
  List<Widget> dataList= [];
  bool loaded= false;

  @override
  Widget build(BuildContext context) {
    if (loaded==false) {getData(); setState(() {loaded=true;});}
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Slide: $loaded'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
              children: dataList,
          )
        ),
      ),
    );
  }

  Future<void> getData() async{
    print('get data in progress');
    var size= MediaQuery.of(context).size;
    String? myNovelData= await NetworkHandler().getString('user', 'myNovelData');
    dataList.add(
        Container(
          width: size.width,
          padding: const EdgeInsets.all(10),
          child: Container(
            constraints: BoxConstraints(maxWidth: size.width-20),
            child: Align(alignment: Alignment.topLeft, child: Text('myNovelData= $myNovelData', style: TextStyle(fontSize: 15, color: AppTheme.themeColor))),
          ),
        )
    );
    for (int i=0; i<31; i++) {
      print('get data on iteration $i');
      String? novelData= await NetworkHandler().getString('user', 'novelData$i');
      if (novelData!=null) {
        setState(() {
          dataList.add(
              Container(
                width: size.width,
                padding: const EdgeInsets.all(10),
                child: Container(
                  constraints: BoxConstraints(maxWidth: size.width-20),
                  child: Align(alignment: Alignment.topLeft, child: Text(novelData, style: TextStyle(fontSize: 15, color: AppTheme.themeColor))),
                ),
              )
          );
        });
      } else {
        Container(
          height: 220,
          width: size.width,
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 200,
            width: size.width-20,
            child: Text('null', style: TextStyle(fontSize: 15, color: AppTheme.themeColor), overflow: TextOverflow.ellipsis),
          ),
        );
      }
    }
  }
}
