import 'package:flutter/material.dart';

import '../helper/AppFunctions.dart';
import '../helper/AppTheme.dart';
import '../network_and_data/NetworkHandler.dart';
import 'AuthPage.dart';
import 'RootPage.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<Color?> animation;
  double progress= 0;

  @override
  initState() {
    super.initState();

    controller= AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    animation= controller.drive(Tween<Color?>(begin: AppTheme.themeColor, end: AppTheme.themeColor));
    controller.repeat;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppFunctions().navigateToRootOrLogin(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/fictuneLogo.png')
                    )
                ),
                height: 60,
                width: 50,
              ),
              SizedBox(
                width: 100,
                height: 10,
                child: LinearProgressIndicator(
                  valueColor: animation,
                  backgroundColor: const Color.fromRGBO(150, 45, 255, 1),
                )
              ),
            ]
          ),
        ),
      )

    );
  }
}
