import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../network_and_data/NetworkHandler.dart';
import '../pages/AuthPage.dart';
import '../pages/RootPage.dart';

class AppFunctions {
  //string-image conversion
  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= const Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }

  //root-login navigation
  Future<void> navigateToRootOrLogin(context) async{
    String? response1= await NetworkHandler().getString('user', 'token');
    if (response1!=null) {
      getData(response1);
    }
    String? response2= await NetworkHandler().getString('user', 'user_name');
    String? response3= await NetworkHandler().getString('user', 'user_id');
    String? response4= await NetworkHandler().getString('user', 'user_attribute');
    String? response5= await NetworkHandler().getString('user', 'user_userdata');
    String? response6= await NetworkHandler().getString('user', 'user_userbillingdata');
    if (response1!=null && response2!=null && response3!=null && response4!=null&& response5!=null && response6!=null) {
      List<String> responseList= ['success', response1, response2, response3, response4, response5, response6];
      Navigator.push(context, MaterialPageRoute(builder: (context)=> RootPage(responseList: responseList)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AuthPage()));
    }
  }

  Future<void> getData(String token) async{
    //favorite novel data
    List<String> userLikedNovelIndices= await NetworkHandler().getUserLikedNovelIndices(token);
    if (userLikedNovelIndices[0]!='error') {
      List<String> userLikedNovelIndexList= userLikedNovelIndices[1].split('%');
      String key0= 'userLikedNovelsIndices';
      String value0= userLikedNovelIndices[1];
      print('step_001: user liked novel indices = '+ value0+ ' ...saving with key: $key0');
      NetworkHandler().saveString('user', key0, value0);
      for (int i=0; i<userLikedNovelIndexList.length; i++) {
        String key= 'liked_novel_data_'+userLikedNovelIndexList[i];
        print('step_002: checking favorite novel data for index $i in storage for key: $key');
        String? ithLikedNovelDataString= await NetworkHandler().getString('user', key);
        if (ithLikedNovelDataString==null) {
          print('step_003: ithLikedNovelDataString for key $key not found in storage, getting favorite novel from network with index '+ userLikedNovelIndexList[i]);
          List<String> likedNovelDataForIthIteration= await NetworkHandler().getPostById(token, userLikedNovelIndexList[i]);
          if (likedNovelDataForIthIteration[0]=='success') {
            print('step_004: favorite novel data for $i th iteration success, saving in storage with key: $key');
            String ithLikedNovelDataString= '$i<divider%83>'+ likedNovelDataForIthIteration[1]+ '<divider%83>'+likedNovelDataForIthIteration[2];
            NetworkHandler().saveString('user', key, ithLikedNovelDataString);
          } else {
            print('step_004b: favorite novel data for $i th iteration error/unsuccessful, it will be loaded in another try');
          }
        } else {
          print('step_003: favorite novel data found in storage, saving success');
        }
      }

    }
    //my novel data
    //...in progress
  }


}