import 'dart:convert';
import 'package:fictune_frontend/Files/RawImageFiles.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
  var log = Logger();

  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  Future getLatestPostsByGenre(String genre, String index, String token) async{
    int genreInt= int.parse(genre);
    int indexInt= int.parse(index);
    indexInt++;
    var headers= {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String nodata= RawImageFiles().nodata();
    http.Response response;
    try {
      if (genreInt==0) {
        response = await http.get(
            Uri.parse('http://ftunebackend.herokuapp.com/api/posts/index/$indexInt'),
            headers: headers,
        );
      } else {
        response = await http.get(
            Uri.parse('http://ftunebackend.herokuapp.com/api/posts/attribute/$genreInt/index/$indexInt'),
            headers: headers,
        );
      }
      var decodedResponse= json.decode(response.body);
      var title= decodedResponse['posts']['post_body'].toString();
      var image= decodedResponse['posts']['post_attribute_3'].toString();
      return 'success%$title%$image';
    } catch(e) {
      print(e);
      return 'error%$e%$nodata';
    }

  }

  //get post by id function
  Future getPostById(String index, String token) async{
    print('get post by id $index : $token');
    try {
      var response = await http.get(Uri.parse("http://ftunebackend.herokuapp.com/api/posts/$index"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var decodedResponse= json.decode(response.body);
      print('decodedResponse: $decodedResponse at network handler');
      if (decodedResponse['post']!=null) {
        String response1= decodedResponse['post'][0]['post_body'].toString();
        String response2= decodedResponse['post'][0]['post_attribute_3'].toString();
        String response= '$response1%$response2';
        print(decodedResponse);
        saveString('user', "post_$index", response);
        return "success%$response";
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
        String response1= decodedResponse['token'].toString();
        String response2= decodedResponse['user']['name'].toString();
        String response3= decodedResponse['user']['id'].toString();
        String response4= decodedResponse['user']['user_attribute_1'].toString();
        return "success%$response1%$response2%$response3%$response4";
      } else if (decodedResponse['message']!=null) {
        return "error%email or password is incorrect";
      } else {
        print(decodedResponse);
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