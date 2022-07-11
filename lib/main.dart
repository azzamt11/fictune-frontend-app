import 'package:fictune_frontend/network_and_data/NetworkHandler.dart';
import 'package:fictune_frontend/pages/RootPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/AuthPage.dart';
import '../helper/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  Future<String?> getString(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_generateKey(userId, key));
  }

  String? response1= await getString('user', 'user_token');
  String? response2= await getString('user', 'user_name');
  String? response3= await getString('user', 'user_id');
  String? response4= await getString('user', 'user_attribute');
  print(response1);
  if (response1!=null && response2!=null && response3!=null && response4!=null) {
    List<String> responseList= ['success', response1, response2, response3, response4];
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: RootPage(responseList: responseList),
    ));
  } else {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: AuthPage(),
    ));
  }
}


