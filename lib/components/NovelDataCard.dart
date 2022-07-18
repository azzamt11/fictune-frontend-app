import 'package:fictune_frontend/helper/AppTheme.dart';
import 'package:flutter/cupertino.dart';

class NovelDataCard extends StatefulWidget {
  final String token;
  final String index;
  const NovelDataCard({Key? key, required this.index, required this.token}) : super(key: key);

  @override
  State<NovelDataCard> createState() => _NovelDataCardState();
}

class _NovelDataCardState extends State<NovelDataCard> {
  @override
  Widget build(BuildContext context) {
    String index= widget.index;
    return Text('This is Title for novel $index', style: TextStyle(fontSize: 17, color: AppTheme.themeColor),
    );
  }
}
