import 'package:fictune_frontend/pages/AuthPage.dart';
import 'package:fictune_frontend/pages/InitialPage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.white),
    home: const InitialPage(),
  ));
}


