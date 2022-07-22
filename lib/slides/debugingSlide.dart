import 'package:flutter/material.dart';

import '../helper/AppTheme.dart';

class DebugSlide extends StatefulWidget {
  const DebugSlide({Key? key}) : super(key: key);

  @override
  State<DebugSlide> createState() => _DebugSlideState();
}

class _DebugSlideState extends State<DebugSlide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Slide'),
      ),
      body: SizedBox(
        child: Column(
            children: [
              SizedBox(child: Text('debugging in progress', style: TextStyle(fontSize: 20, color: AppTheme.themeColor))),
            ]
        )
      ),
    );
  }
}
