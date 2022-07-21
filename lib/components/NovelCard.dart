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
  final int custom;
  const NovelCard({Key? key, required this.genre, required this.index, required this.userId, required this.token, required this.custom}) : super(key: key);

  @override
  State<NovelCard> createState() => _NovelCardState();
}

class _NovelCardState extends State<NovelCard> {
  bool loadingState= true;
  Widget activeWidget= Center(child: Text('Loading...', style: TextStyle(fontSize: 15, color: AppTheme.themeColor)));
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  //scaffold
  @override
  Widget build(BuildContext context) {
    print('novel card in progress (next: set novel image)');
    if (loadingState==true) {setNovelImage(); setState(() {loadingState= false;});}
    return Container(
      height: 150,
      width: 100,
      color: const Color.fromRGBO(241, 241, 241, 1),
      child: activeWidget,
    );
  }

  Future<void> setNovelImage() async{
    String index=widget.index;
    String genre=widget.genre;
    String token=widget.token;
    if (widget.custom==0) {
      List<String> novelDataArray= await NetworkHandler().getLatestPostsByGenre(genre, index, token);
      final novelTitle= novelDataArray[1];
      final novelImage= novelDataArray[2];
      NetworkHandler().saveString('user', 'novels_titles_$index', novelTitle);
      NetworkHandler().saveString('user', 'novels_images_$index', novelImage);
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

  }

  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= const Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }
}
