import 'package:flutter/material.dart';
import 'root/rootPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.white),
    home: rootPage(),
  ));
}


