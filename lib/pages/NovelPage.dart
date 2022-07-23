import 'package:fictune_frontend/files/RawImageFiles.dart';
import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';

class NovelPage extends StatefulWidget {
  final String token;
  final String novelId;
  const NovelPage({Key? key, required this.novelId, required this.token}) : super(key: key);

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  String author= 'Loading...';
  String rate= 'Loading...';
  bool fixedLoading=true;
  bool loading=true;
  bool authorLoading=true;
  bool novelDataHasBeenLoadedFromNetwork= false;
  List<String> novelData= ['0', 'Loading...<divider%69>Loading...', RawImageFiles().noData(), 'Loading...', 'Loading...'];

  @override
  Widget build(BuildContext context) {
    if (loading) {getNovelData(); loading=false;}
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(230, 230, 230, 1),
          centerTitle: true,
          title: Text(novelData[1].split('<divider%69>')[0], style: const TextStyle(fontSize: 18, color: Colors.white)),
          elevation: 0,

        ),
      ),
      body: getBody(loading),
    );
  }

  Widget getBody(loading) {
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
                    child: getNovelMainContainer(loading),
                  ),
                ),
                Container(
                  height: 200,
                  width: 0.67*size.width,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getNovelTitleContainer(loading, 0, 20, 'Title', 45, 150, true),
                        const SizedBox(height: 18),
                        getNovelAuthorContainer(fixedLoading, 18, 'Author', 28, 0.67*size.width-40),
                        const SizedBox(height: 2),
                        getNovelRatingContainer(loading, 27, 0.67*size.width-40),
                        const SizedBox(height: 12),
                        Container(
                          height: 40,
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
            height: size.height-348,
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

  Future<void> getNovelData() async{
    String novelId= widget.novelId;
    if (novelId!='0') {
      print('step_019: get novel data in progress on novelId: $novelId');
      String? novelDataString= await NetworkHandler().getString('user', 'novelData$novelId');
      print('step_020: get novel data has loaded the data from network, getting $novelDataString');
      print(novelDataString);
      if (novelDataString!=null) {
        List<String> novelDataArray= novelDataString.split('<divider%83>');
        String userId= novelDataArray[5];
        print('step_021: submitting userId : $userId into get author data. executing get author data');
        getAuthorData(userId);
        setState(() {
          novelData= novelDataArray;
          loading=false;
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
        decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: MemoryImage(AppFunctions().convertBase64Image(novelData[2])))),
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
      return SizedBox(
        height: height,
        width: width,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text('$text: '+ novelData[1].split('<divider%69>')[index], style: TextStyle(fontSize: fontSize, color: AppTheme.themeColor, fontWeight: bold? FontWeight.bold : FontWeight.normal)),
        ),
      );
    }
  }

  Widget getNovelRatingContainer(bool titleLoading, double height, double width) {
    if (loading) {
      return Container(
        height: height,
        width: width,
        color: const Color.fromRGBO(245, 245, 245, 1),
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [Text('Rating: '+ novelData[3], style: TextStyle(fontSize: 18, color: AppTheme.themeColor))],
          ),
        ),
      );
    }
  }

  Widget getNovelAuthorContainer(bool loading, double fontSize, String text, double height, double width) {
    if (authorLoading) {
      return SizedBox(
        height: height,
        width: width,
          child: Align(
          alignment: Alignment.topLeft,
          child:Text('Author: Loading...', style: TextStyle(fontSize: fontSize, color: AppTheme.themeColor, fontWeight: FontWeight.normal)),
          )
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: Align(
          alignment: Alignment.topLeft,
          child:Text('Author: '+ author, style: TextStyle(fontSize: fontSize, color: AppTheme.themeColor, fontWeight: FontWeight.normal)),
        ),
      );
    }
  }

  List<Widget> getStar(int rate) {
    List<Widget> stars= [];
    for (int i=0; i<rate; i++) {
      stars.add(const Icon(Icons.star, size: 20, color: Colors.amber));
    }
    return stars;
  }

  Future<void> getAuthorData(String userId) async{
    print('step_022a: getting author name from network in progress');
    String? authorName= await NetworkHandler().getString('user', 'authorName$userId');
    if (authorName==null || authorName=='error') {
      print('step_022: get author data from network in progress on userId: $userId');
      if (userId!='error') {
        List<String> authorData= await NetworkHandler().getUser(widget.token, userId);
        String authorData1= authorData[1];
        print('step_025: authorName has been loaded, authorData [1] (name): $authorData1, saving to local storage');
        NetworkHandler().saveString('user', 'authorName$userId',authorData[1]);
        setState(() {
          author= authorData[1];
          print('author data has been updated, author: $author');
          authorLoading=false;
        });
      } else {
        print('step_025 (interrupted): authorData has failed to load, returning error');
        author= 'error';
      }
    } else {
      setState(() {
        author= authorName;
        print('step_023 : authorData has successfully been loaded from local storage, author has been updated');
      });
    }
  }
}
