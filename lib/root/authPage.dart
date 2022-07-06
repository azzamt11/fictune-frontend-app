import 'dart:convert';

import 'package:fictune_frontend/root/rootPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../network/networkHandler.dart';

class authPage extends StatefulWidget {
  const authPage({Key? key}) : super(key: key);

  @override
  State<authPage> createState() => _authPageState();
}

class _authPageState extends State<authPage> {
  var message= 'initial message';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/images/fictuneBackground2.PNG"),
                  fit: BoxFit.cover
                )
            ),
          ),
          Container(
            height: size.height,
            width: size.width,
            color: Colors.black54,
            child: Center(
              child: Container(
                  height: 300,
                  width: 280,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                      children: [
                        tittle(),
                        inputTextField('email', emailController),
                        purpleLine(),
                        inputTextField('password', passwordController),
                        purpleLine(),
                        button()
                      ]
                  )
              ),
            ),
          ),
        ]
      ),
    );
  }

  Widget tittle() {
    return(
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text('Login to Fictune', style: TextStyle(fontSize: 20, color: Color.fromRGBO(50, 0, 100,1), fontWeight: FontWeight.bold))
        )
    );
  }

  Widget inputTextField(String string, controller) {
    return(
        Container(
          margin: EdgeInsets.only(left: 30, top: 20),
          height: 25,
          child: TextField(
              controller: controller,
              decoration: new InputDecoration(border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, errorBorder: InputBorder.none, disabledBorder: InputBorder.none, hintText: string)
          ),
        )
    );
  }

  Widget purpleLine() {
    return(
        Container(
            height: 1,
            width: 220,
            color: Color.fromRGBO(50, 0, 100, 1)
        )
    );
  }

  Widget button() {
    return(
        GestureDetector(
          onTap: () async {
            String typedEmail= emailController.text;
            String typedPassword= passwordController.text;
            var response= await NetworkHandler().login('login', {'email': typedEmail, 'password': typedPassword});
            if (response!=null) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> rootPage()));
            }
          },
          child: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Container(
                      height: 34,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromRGBO(50, 0, 100, 1)),
                      width: 70,
                      padding: EdgeInsets.only(bottom: 3),
                      child: Center(
                          child: Text('Login', style: TextStyle(fontSize: 17, color: Colors.white))
                      )
                  )
              )
          ),
        )
    );
  }
}
