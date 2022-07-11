import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final userUserName= await getString('user', 'user_name');
    final userAttribute= await getString('user', 'user_attribute');
    final userId= await getString('user', 'user_id');
    final userToken= await getString('user', 'token');
    print(userUserName);
    if (userUserName!=null) {
      if (userAttribute!=null) {
        return '$userUserName%$userAttribute%$userId%$userToken';
      } else {
        return '$userUserName%$altAttribute%$userId%$userToken';
      }
    } else {
      return '$altUserName%altAttribute%$userId%$userToken';
    }
  }

}