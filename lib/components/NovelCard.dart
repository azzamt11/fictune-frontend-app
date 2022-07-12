import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';

class NovelCard extends StatefulWidget {
  final String genre;
  final String index;
  final String userId;
  final String token;
  const NovelCard({Key? key, required this.genre, required this.index, required this.userId, required this.token}) : super(key: key);

  @override
  State<NovelCard> createState() => _NovelCardState();
}

class _NovelCardState extends State<NovelCard> {
  bool loadingState= true;
  Widget activeWidget= Center(child: Text('Loading...', style: TextStyle(fontSize: 15, color: AppTheme.themeColor)));
  //scaffold
  @override
  Widget build(BuildContext context) {
    print('novel card in progress');
    if (loadingState==true) {setNovelImage(); setState(() {loadingState=false;});}
    return Container(
      height: 150,
      width: 100,
      color: Colors.grey,
      child: activeWidget,
    );
  }

  Future<void> setNovelImage() async{
    String novelDataString= await NetworkHandler().getLatestPostsByGenre(widget.genre, widget.index, widget.token);
    final novelImage= novelDataString.split('%')[2];
    setState(() {
      activeWidget= Container(
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(AppFunctions().convertBase64Image(novelImage)),
          )
        )
      );
    });
  }

  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }
}