import 'package:flutter/cupertino.dart';

import '../helper/AppTheme.dart';

class ExploreSlide extends StatefulWidget {
  final List<String> responseList;
  const ExploreSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<ExploreSlide> createState() => _ExploreSlideState();
}

class _ExploreSlideState extends State<ExploreSlide> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('This is explore slide', style: TextStyle(fontSize: 17, color: AppTheme.themeColor)));
  }
}
