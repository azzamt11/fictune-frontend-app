import 'dart:convert';
import 'dart:js';
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




}