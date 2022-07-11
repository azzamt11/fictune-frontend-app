import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'PostRepository.dart';

class PostController extends GetxController{
  final PostRepository postRepository;
  PostController({required this.postRepository});
  List<dynamic> _postList= [];
  List<dynamic> get postList => _postList;

  Future<void> getPostList() async {
     Response response= await postRepository.getPostList();
     if (response.statusCode== 200) {
       _postList= [];
       //_postList.addAll();
       update;
     } else {

     }
  }

}