import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
  var log = Logger();

  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  //get user preference by attribute function
  Future getUserPref(String attributeIndex) async {
    var token= getString('user', 'token');
    try {
      var response = await http.post(Uri.parse("http://ftunebackend.herokuapp.com/api/user"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var decodedResponse= json.decode(response.body);
      if (decodedResponse['user']!=null) {
        String userPref= decodedResponse['user']['user_attribute_4'].toString();
        List<String> userPrefGenre= userPref.split('%');
        saveString('user', 'user_userpref_genre_$attributeIndex', userPrefGenre[int.parse(attributeIndex)]);
        return "success%$userPref";
      }
    } catch(e) {
      return "error%something went wrong";
    }
  }

  //get post by id function
  Future getPostById(int index) async{
    var token= getString('user', 'token');
    try {
      var response = await http.post(Uri.parse("http://ftunebackend.herokuapp.com/api/posts/$index"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var decodedResponse= json.decode(response.body);
      if (decodedResponse['post']!=null) {
        saveString('user', 'post_body', decodedResponse['post']['post_body'].toString());
        saveString('user', 'post_image', decodedResponse['post']['post_attribute_3'].toString());
        String response1= decodedResponse['post']['post_body'].toString();
        String response2= decodedResponse['post']['post_attribute_3'].toString();
        return "success%$response1%$response2";
      }
    } catch(e) {
      return "error%something went wrong";
    }
  }

  //post function
  Future<http.Response> post(String url, Map<String, String> body) async {
    var token= getString('user', 'token');
    log.d(body);
    var response = await http.post(Uri.parse("http://ftunebackend.herokuapp.com/api/$url"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  //put function
  Future<http.Response> put(String url, Map<String, String> body) async {
    var token= getString('user', 'token');
    log.d(body);
    var response = await http.put(Uri.parse("http://ftunebackend.herokuapp.com/api/$url"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  //delete function
  Future<http.Response> delete(String url) async {
    var token= getString('user', 'token');
    var response = await http.delete(Uri.parse("http://ftunebackend.herokuapp.com/api/$url"), headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token",
      "Access-Control-Allow-Origin": "*"
    });
    return response;
  }

  //login function
  Future<String?> login(String url, Map<String, String> body) async {
    try {
      var response = await http.post(Uri.parse("http://ftunebackend.herokuapp.com/api/login"),
          headers: {
            "Content-type": "application/json",
            "Access-Control-Allow-Origin":"*"
          },
          body: json.encode(body));
      var decodedResponse= json.decode(response.body);
      if (decodedResponse['user']!=null) {
        saveString('user', 'token', decodedResponse['token'].toString());
        saveString('user', 'user_name', decodedResponse['user']['name'].toString());
        saveString('user', 'user_id', decodedResponse['user']['id'].toString());
        saveString('user', 'user_email', decodedResponse['user']['email'].toString());
        saveString('user', 'user_attribute', decodedResponse['user']['user_attribute_1'].toString());
        saveString('user', 'user_pref', decodedResponse['user']['user_attribute_2'].toString());
        saveString('user', 'user_username', decodedResponse['user']['user_attribute_3'].toString());
        String response1= decodedResponse['token'];
        String response2= decodedResponse['user']['name'];
        return "success%$response2%$response1";
      } else if (decodedResponse['message']!=null) {
        return "error%email or password is incorrect";
      } else {
        return "error%something went wrong";
      }
    } catch(e) {
      return "error%something went wrong";
    }//updated
  }

  //required sub-functions
  void saveString(String userId, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_generateKey(userId, key), value);
  }

  Future<String?> getString(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_generateKey(userId, key));
  }
}