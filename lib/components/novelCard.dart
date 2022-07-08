import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/DataProvider.dart';

class NovelCard extends StatefulWidget {
  final String genre= '0';
  final String index= '0';
  final String userId= '1';
  const NovelCard(String userId, int genre, int index, {Key? key}) : super(key: key);

  @override
  State<NovelCard> createState() => _NovelCardState();
}

class _NovelCardState extends State<NovelCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataProvider().getNovelData(widget.genre, widget.index), builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (!snapshot.hasData) {
        return Container();
      } else {
        final String? novelData= snapshot.data;
        return getBody(novelData);
      }
    });
  }

  Widget getBody(String? userData) {
    return Container();
  }
}
