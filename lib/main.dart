import 'package:flutter/material.dart';
import 'root/authPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.white),
    home: authPage(),
  ));
}

