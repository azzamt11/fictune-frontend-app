import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import 'ApiClient.dart';

class PostRepository extends GetxService {
  final ApiClient apiClient;
  PostRepository({required this.apiClient});

  Future<Response> getPostList() async{
    return await apiClient.getData('https://http://ftunebackend.herokuapp.com/api/posts');
  }
}