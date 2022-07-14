import 'dart:convert';
import 'package:fictune_frontend/files/RawImageFiles.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
  var log = Logger();

  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  //get latest post by genre function
  Future<List<String>> getLatestPostsByGenre(String genre, String index, String token) async{
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
      return ['success', title, image];
    } catch(e) {
      return ['error', 'something went wrong : $e', nodata];
    }

  }

  //get post by id function
  Future getSubPostByParentId(String index, String token) async{
    try {
      var response = await http.get(Uri.parse("http://ftunebackend.herokuapp.com/api/posts/$index"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var decodedResponse= json.decode(response.body);
      if (decodedResponse['post']!=null) {
        String response1= decodedResponse['post'][0]['post_body'].toString();
        String response2= decodedResponse['post'][0]['post_attribute_3'].toString();
        String response= '$response1%$response2';
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
  Future<List<String>> login(String url, Map<String, String> body) async {
    String zeroString= '000000';
    try {
      var response = await http.post(Uri.parse("http://ftunebackend.herokuapp.com/api/login"),
          headers: {
            "Content-type": "application/json",
            "Access-Control-Allow-Origin":"*"
          },
          body: json.encode(body));
      var decodedResponse= json.decode(response.body);
      if (decodedResponse['user']!=null) {
        String response1= decodedResponse['token'].toString();
        String response2= decodedResponse['user']['name'].toString();
        String response3= decodedResponse['user']['id'].toString();
        String response4= decodedResponse['user']['user_attribute_1'].toString();
        String response5= decodedResponse['user']['user_attribute_3'].toString();
        String response6= decodedResponse['user']['user_attribute_4'].toString();
        saveString('user', 'token', response1);
        saveString('user', 'user_name', response2);
        saveString('user', 'user_id', response3);
        saveString('user', 'user_attribute', response4);
        saveString('user', 'user_userdata', response5);
        saveString('user', 'user_userbillingdata', response6);
        if (response4== '') {
          response4= RawImageFiles().userImage();
        }
        if (response5== '') {
          String userNumber= zeroString.substring(1, 6- response3.length)+ response3;
          response5= 'user$userNumber';
        }
        if (response6== '') {
          response6= '2000';
        }
        return ['success', response1, response2, response3, response4, response5, response6];
      } else if (decodedResponse['message']!=null) {
        return ['error', 'email or password is incorrect', 'unknown_user', '0', RawImageFiles().userImage(), 'no_userdata', 'no_userbillingdata'];
      } else {
        return ['error', 'email or password is incorrect' ,'unknown_user', '0', RawImageFiles().userImage(), 'no_userdata', 'no_userbillingdata'];
      }
    } catch(e) {
      return ['error', 'something went wrong : $e' , 'unknown_user', '0', RawImageFiles().userImage(), 'no_userdata', 'no_userbillingdata'];
    }//updated
  }

  //register function
  Future<List<String>> register(String url, Map<String, String> body) async {
    String zeroString= '000000';
    try {
      var response = await http.post(Uri.parse("http://ftunebackend.herokuapp.com/api/$url"),
          headers: {
            "Content-type": "application/json",
            "Access-Control-Allow-Origin":"*"
          },
          body: json.encode(body));
      var decodedResponse= json.decode(response.body);
      if (decodedResponse['user']!=null) {
        String response1= decodedResponse['token'].toString();
        String response2= decodedResponse['user']['name'].toString();
        String response3= decodedResponse['user']['id'].toString();
        saveString('user', 'token', response1);
        saveString('user', 'user_name', response2);
        saveString('user', 'user_id', response3);
        saveString('user', 'user_attribute', RawImageFiles().userImage());
        String userNumber= zeroString.substring(1, 6- response3.length)+ response3;
        saveString('user', 'user_userdata', 'user$userNumber*instagram*birthdate');
        saveString('user', 'user_userbillingdata', '2000*nonpremium');
        return ['success', response1, response2, response3, RawImageFiles().userImage(), 'user$userNumber', '2000'];
      } else if (decodedResponse['message']!=null){
        return ['error', decodedResponse['message'], 'unknown_user', '0', RawImageFiles().userImage(), 'no_data', 'no_data'];
      } else {
        return ['error', 'something went wrong' ,'unknown_user', '0', RawImageFiles().userImage(), 'no_data', 'no_data'];
      }
    } catch(e) {
      return ['error', 'something went wrong : $e' , 'unknown_user', '0', RawImageFiles().userImage(), 'no_data', 'no_data'];
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