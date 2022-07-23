import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyNovelScrollComponent extends StatefulWidget {
  const MyNovelScrollComponent({Key? key}) : super(key: key);

  @override
  State<MyNovelScrollComponent> createState() => _MyNovelScrollComponentState();
}

class _MyNovelScrollComponentState extends State<MyNovelScrollComponent> {
  bool loadingState= true;
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget getMyNovelsList() {
    var size= MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      color: Colors.red,
      child: Column(
        children: novelWidgetList(),
      )
    );
  }

  List<Widget> novelWidgetList() {
    List<Widget> widgetList= [];

    return widgetList;
  }
}
