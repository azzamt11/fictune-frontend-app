import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is register page', style: TextStyle(fontSize: 20, color: AppTheme.themeColor)),
      )
    );
  }
}
