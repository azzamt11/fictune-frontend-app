import 'package:flutter/material.dart';
import 'root/AuthPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.white),
    home: AuthPage(),
  ));
}

