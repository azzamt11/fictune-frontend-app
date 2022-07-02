import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class authPage extends StatefulWidget {
  const authPage({Key? key}) : super(key: key);

  @override
  State<authPage> createState() => _authPageState();
}

class _authPageState extends State<authPage> {
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
                  height: 280,
                  width: 300,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Text('Login to Fictune', style: TextStyle(fontSize: 20, color: Color.fromRGBO(50, 0, 100,1), fontWeight: FontWeight.bold))
                        ),
                        Padding(
                            child: TextField(decoration: new InputDecoration(border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, errorBorder: InputBorder.none, disabledBorder: InputBorder.none, hintText: "Email")),
                            padding: EdgeInsets.only(left: 30, right: 30, top: 10)
                        ),
                        Container(
                            height: 1,
                            width: 240,
                            color: Color.fromRGBO(50, 0, 100, 1)
                        ),
                        Padding(
                            child: TextField(decoration: new InputDecoration(border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, errorBorder: InputBorder.none, disabledBorder: InputBorder.none, hintText: "Password")),
                            padding: EdgeInsets.only(left: 30, right: 30, top: 10)
                        ),
                        Container(
                            height: 1,
                            width: 240,
                            color: Color.fromRGBO(50, 0, 100, 1)
                        ),
                        GestureDetector(
                          onTap: () {
                            //just do nothing for a while.},
                          },
                          child: Center(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromRGBO(50, 0, 100, 1)),
                                      width: 80,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 5, left: 14),
                                          child: Text('Login', style: TextStyle(fontSize: 20, color: Colors.white))
                                      )
                                  )
                              )
                          ),
                        ),
                      ]
                  )
              ),
            ),
          ),
        ]
      ),
    );
  }
}
