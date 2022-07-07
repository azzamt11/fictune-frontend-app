import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
  var log = Logger();

  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  //get function
  Future get(String url) async {
    var token= getString('user', 'token');
    var response = await http.get(Uri.parse("http://ftunebackend.herokuapp.com/api/$url"), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);

      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
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
        print(getString('user', 'user_name'));
        String response1= decodedResponse['token'];
        String response2= decodedResponse['user']['name'];
        return "success%$response2%$response1";
      } else if (decodedResponse['message']!=null) {
        return "error%email or password is incorrect";
      } else {
        return "error%something went wrong";
      }
    } catch(e) {
      print(e);
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