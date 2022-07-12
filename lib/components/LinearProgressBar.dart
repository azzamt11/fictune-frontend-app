import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';

class LinearProgressBar extends StatefulWidget {
  const LinearProgressBar({Key? key}) : super(key: key);

  @override
  State<LinearProgressBar> createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller= AnimationController(duration: const Duration(microseconds: 1000), vsync: this);
    animation= Tween(begin: 0.0, end: 1.0).animate(controller)
    ..addListener(() {
      //just do nothing for a while
    });
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color.fromRGBO(100, 0, 150, 1)),
        Positioned(
          right: 200*max(0, animation.value-0.5),
          child: Container(
            height: 10,
            width: (0.5-(animation.value-0.5).abs())*200,
            color: AppTheme.themeColor,
          ),
        )
      ]
    );
  }
}
