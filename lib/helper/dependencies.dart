import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../network_and_data/ApiClient.dart';
import '../network_and_data/PostController.dart';
import '../network_and_data/PostRepository.dart';

Future<void> init() async {
  Get.lazyPut(()=> ApiClient(appBaseUrl: 'https://ftunebackend.herokuapp.com'));

  Get.lazyPut(()=> PostRepository(apiClient: Get.find()));

  Get.lazyPut(()=> PostController(postRepository: Get.find()));
}