import 'dart:convert';
import 'package:fictune_frontend/root/RootPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../network/NetworkHandler.dart';

//auth page constructor
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

//auth page state
class _AuthPageState extends State<AuthPage> {
  final List<Widget> loadingWidgetArray= [
    const Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
    const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(backgroundColor: Colors.white))
  ];
  var loadingState= 0;
  var message= 'something went wrong';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //dispose
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //scaffold
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/fictuneBackground2.PNG"),
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
                  height: 350,
                  width: 310,
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

  //components:
  //tittle widget
  Widget tittle() {
    return(
        const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 30),
            child: Text('Login to Fictune', style: TextStyle(fontSize: 24, color: Color.fromRGBO(50, 0, 100,1), fontWeight: FontWeight.bold))
        )
    );
  }

  //input text widget
  Widget inputTextField(String string, controller) {
    return(
        Container(
          margin: EdgeInsets.only(left: 30, top: 25, right: 30, bottom: 0),
          height: 28,
          child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(contentPadding: EdgeInsets.zero, isDense: true, hintStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, errorBorder: InputBorder.none, disabledBorder: InputBorder.none, hintText: string)
          ),
        )
    );
  }

  //line widget
  Widget purpleLine() {
    return(
        Container(
            height: 1,
            width: 246,
            color: const Color.fromRGBO(50, 0, 100, 1)
        )
    );
  }

  //button widget
  Widget button() {
    return(
        GestureDetector(
          onTap: () async {
            setState(() {
              loadingState= 1;
            });
            String typedEmail= emailController.text;
            String typedPassword= passwordController.text;
            var response= await NetworkHandler().login('login', {'email': typedEmail, 'password': typedPassword});
            if (response!=null) {
              List<String> responseList= response.split("%");
              print(responseList);
              if (responseList[0]!= 'success') {
                setState(() {message= responseList[1];loadingState= 0;});
                ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message));
              } else {
                setState(() {loadingState= 0;});
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RootPage()));
              }
            } else {
              setState(() {loadingState= 0;});
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(message));
            }
          },
          child: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromRGBO(50, 0, 100, 1)),
                      width: 90,
                      padding: EdgeInsets.only(bottom: 3),
                      child: Center(
                          child: loadingWidgetArray[loadingState],
                      )
                  )
              )
          ),
        )
    );
  }

  //snack-bar widget
  SnackBar snackBarWidget(String message) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          setState(() {loadingState=0;});
        },
      ),
    );
    return snackBar;
  }
}
