import 'package:fictune_frontend/files/RawImageFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';

class NovelPage extends StatefulWidget {
  final List<String> novelData;
  const NovelPage({Key? key, required this.novelData}) : super(key: key);

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  bool imageLoading= true;
  bool titleLoading= true;
  bool novelDataHasBeenLoadedFromNetwork= false;
  String novelTitle= 'Loading...<divider%69>loading...';
  String novelImage= RawImageFiles().noImage();

  @override
  Widget build(BuildContext context) {
    setNovelImage();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Text(novelTitle.split('<divider%69>')[0], style: TextStyle(fontSize: 18, color: AppTheme.themeColor)),
          elevation: 0,

        ),
      ),
      body: getBody(imageLoading, titleLoading),
    );
  }

  Widget getBody(bool imageLoading, bool titleLoading) {
    var size= MediaQuery.of(context).size;
    return SizedBox(
      height: size.height- 70,
      width: size.width,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: size.width,
            child: Row(
              children:[
                SizedBox(
                  height: 200,
                  width: 0.33*size.width,
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: getNovelMainContainer(imageLoading),
                  ),
                ),
                Container(
                  height: 200,
                  width: 0.67*size.width,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getNovelTitleContainer(titleLoading, 0, 20, 'Title', 35, 150, true),
                        const SizedBox(height: 12),
                        getNovelTitleContainer(titleLoading, 1, 18, 'Synopsys', 90, 0.67*size.width-40, false),
                        const SizedBox(height: 13),
                        Container(
                          height: 30,
                          width: 110,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.themeColor),
                          child: const Center(
                            child: Text('Read Novel', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          )
                        ), //button
                      ]
                  ),
                ),
              ]
            )
          ),
          SizedBox(
            height: 15,
            child: Center(
              child: Container(
                height: 1,
                width: size.width- 40,
                color: AppTheme.themeColor,
              ),
            ),
          ),
          Container(
            height: size.height-285,
            width: size.width,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: [
                Container(),  //in progress
                Container(),
                Container(),
              ]
            )
          ),
        ]
      )
    );
  }

  Future<void> setNovelImage() async{
    String index= widget.novelData[3];
    String? novelImageFromDevice= await NetworkHandler().getString('user', 'novels_images_$index');
    if (novelImageFromDevice!=null) {
      setState(() {
        novelImage= novelImageFromDevice;
        imageLoading=false;
      });
    } else {
      List<String> novelDataFromNetwork= await NetworkHandler().getPostById(widget.novelData[0], widget.novelData[1]);
      if (novelDataFromNetwork[0]=='success') {
        setState(() {
          novelImage= novelDataFromNetwork[2];
          novelTitle= novelDataFromNetwork[1];
          imageLoading=false;
          titleLoading=false;
          novelDataHasBeenLoadedFromNetwork= true;
        });
      }
    }
    if (titleLoading) {
      String? novelTitleFromDevice= await NetworkHandler().getString('user', 'novels_titles_$index');
      if (novelTitleFromDevice!=null) {
        setState(() {
          novelTitle= novelTitleFromDevice;
          titleLoading=false;
        });
      } else {
        List<String> novelDataFromNetwork= await NetworkHandler().getPostById(widget.novelData[0], widget.novelData[1]);
        setState(() {
          novelTitle= novelDataFromNetwork[1];
          titleLoading=false;
        });
      }
    }
  }

  Widget getNovelMainContainer(bool loading) {
    if (loading) {
      return Container(
        height: 180,
        width: 120,
        child: Center(
          child: Text('Loading...', style: TextStyle(fontSize: 18, color: AppTheme.themeColor),),
        ),
        color: const Color.fromRGBO(245, 245, 245, 1),
      );
    } else {
      return Container(
        height: 180,
        width: 120,
        decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(AppFunctions().convertBase64Image(novelImage)))),
      );
    }
  }

  Widget getNovelTitleContainer(bool titleLoading, int index, double fontSize, String text, double height, double width, bool bold) {
    if (titleLoading) {
      return Container(
        height: height,
        width: width,
        color: const Color.fromRGBO(245, 245, 245, 1),
      );
    } else {
      return Container(
        height: height,
        width: width,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text('$text: '+ novelTitle.split('<divider&69>')[index], style: TextStyle(fontSize: fontSize, color: AppTheme.themeColor, fontWeight: bold? FontWeight.bold : FontWeight.normal)),
        ),
      );
    }

  }
}
