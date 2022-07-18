import 'package:flutter/cupertino.dart';

class ExploreSlide extends StatefulWidget {
  final List<String> responseList;
  const ExploreSlide({Key? key, required this.responseList}) : super(key: key);

  @override
  State<ExploreSlide> createState() => _ExploreSlideState();
}

class _ExploreSlideState extends State<ExploreSlide> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Search', style: TextStyle(fontSize: 20, color: Color.fromRGBO(50, 0, 100, 1)))
    );
  }
}
