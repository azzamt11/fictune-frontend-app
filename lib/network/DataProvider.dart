import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NetworkHandler.dart';

class DataProvider {
  //prerequisites:
  var log = Logger();

  String generateKey(String userId, String key) {
    return '$userId/$key';
  }

  Future<String?> getString(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(generateKey(userId, key));
  }

  //get user data
  Future<String> getUserData() async{
    String altAttribute= 'sandbag';
    String altUserName= 'user-001';
    final userUserName= await getString('user', 'user_username');
    final userAttribute= await getString('user', 'user_attribute');
    final userId= await getString('user', 'user_id');
    if (userUserName!=null) {
      if (userAttribute!=null) {
        return '$userUserName%$userAttribute%$userId';
      } else {
        return '$userUserName%$altAttribute%$userId';
      }
    } else {
      return '$altUserName%altAttribute%$userId';
    }
  }

  //get novel data
  Future<String> getNovelData(String genre, String index) async{
    NetworkHandler().getUserPref(genre);
    final userPrefGenre= await getString('user', 'user_userpref_genre_$genre');
    final novelIndexList= userPrefGenre?.split(' ');
    final novelIndex= novelIndexList![int.parse(index)];
    int novelIndexInt= int.parse(novelIndex);
    NetworkHandler().getPostById(novelIndexInt);
    final novelData= await getString('user', 'post_$novelIndex');
    if (novelData!=null) {
      if (userPrefGenre!=null) {
        return '%';
      } else {
        return '%';
      }
    } else {
      return '%';
    }
  }



}