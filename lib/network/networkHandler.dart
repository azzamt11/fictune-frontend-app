import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
  String baseurl = "http://172.0.0.1:8000/api";
  var log = Logger();

  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  //get function
  Future get(String url) async {
    var token= getString('user', 'token');
    url = formater(url);
    var response = await http.get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
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
    url = formater(url);
    log.d(body);
    var response = await http.post(Uri.parse(url), headers: {
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
    url = formater(url);
    log.d(body);
    var response = await http.put(Uri.parse(url), headers: {
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
    url = formater(url);
    var response = await http.delete(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token",
      "Access-Control-Allow-Origin": "*"
    });
    return response;
  }

  //login function
  Future<String?> login(String url, Map<String, String> body) async {
    url = formater(url);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-type": "application/json",
            "Access-Control-Allow-Origin":"*"
          },
          body: json.encode(body));
      var decodedResponse= json.decode(response.body);
      saveString('user', 'token', decodedResponse['token']);
      print(decodedResponse);
      return decodedResponse['message'];
    } catch(e) {
      print(e);
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

  String formater(String url) {
    return baseurl + url;
  }
}