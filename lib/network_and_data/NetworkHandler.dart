import 'dart:convert';
import 'dart:core';
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
    String noData= RawImageFiles().noData();
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
      var id= decodedResponse['posts']['id'].toString();
      var title= decodedResponse['posts']['post_body'].toString();
      var image= decodedResponse['posts']['post_attribute_3'].toString();
      var rate= decodedResponse['posts']['post_attribute_1'].toString();
      var genre= decodedResponse['posts']['post_attribute_2'].toString();
      var author= decodedResponse['posts']['post_user'].toString();
      return ['success', id, title, image, rate, genre, author];
    } catch(e) {
      return ['error', '0', 'something went wrong :<divider%69>$e', noData, 'error', 'error', 'error'];
    }
  }

  //get latest post by secondary attribute function
  Future<List<String>> getPostById(String token, String id) async{
    try {
      var response= await http.get(Uri.parse('http://ftunebackend.herokuapp.com/api/posts/$id'),
          headers: {"Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var decodedResponse= json.decode(response.body);
      if (decodedResponse['post']!=null && decodedResponse['posts']!='[]') {
        String response1= decodedResponse['post'][0]['post_body'].toString();
        String response2= decodedResponse['post'][0]['post_attribute_3'].toString();
        String response3= decodedResponse['post'][0]['post_attribute_1'].toString();
        String response4= decodedResponse['post'][0]['post_attribute_2'].toString();
        String response5= decodedResponse['post'][0]['post_user'].toString();
        return ['success', response1, response2, response3, response4, response5];
      } else if (decodedResponse['posts']!='[]') {
        return ['zero', 'error<divider%69>error', 'error', 'error', 'error', 'error'];
      } else {
        return ['error', 'error<divider%69>error', 'error', 'error', 'error', 'error'];
      }
    } catch(e) {
      return ['error', 'error<divider%69>error', 'error', 'error', 'error', 'error'];
    }
  }

  //get latest post by secondary attribute function
  Future<List<List<String>>> getMultiplePostsByIdList(String token, String idList) async{
    List<List<String>> novelResponseList= [];
    var response= await http.post(Uri.parse('http://ftunebackend.herokuapp.com/api/posts/getbyindices'),
        headers: {"Content-type": "application/json",
          "Authorization": "Bearer $token"
        });
    var decodedResponse= json.decode(response.body);
    if (decodedResponse['posts']!=null || decodedResponse['posts']!='') {
      for (int i=0; i<decodedResponse['posts'].length; i++) {
        String response1= decodedResponse['posts'][i+1][0]['post_body'];
        String response2= decodedResponse['posts'][i+1][0]['post_attribute_1'];
        novelResponseList.add(['success', response1, response2]);
      }
      return novelResponseList;
    } else {
      return [['error', 'error<divider%69>error', 'error']];
    }
  }

  //user preference function
  Future<List<String>> getUserLikedNovelIndices(String token) async {
    var response = await http.get(Uri.parse("http://ftunebackend.herokuapp.com/api/user"),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        });
    var decodedResponse= json.decode(response.body);
    if (decodedResponse!=null) {
      String responseString= decodedResponse['user_attribute_2'].toString();
      if (responseString=='') {
        return ['zero', ''];
      } else {
        String finalResponse= responseString.split('<divider%39>')[0];
        return ['success', finalResponse];
      }
    } else {
      return ['error', 'error'];
    }
  }

  //user novels data
  Future<List<List<String>>> getUserNovels(String token) async {
    List<List<String>> finalResponse= [];
    try {
      var response = await http.get(Uri.parse("http://ftunebackend.herokuapp.com/api/userposts"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var decodedResponse= json.decode(response.body);
        if (decodedResponse!=null) {
          if (decodedResponse['user_posts'].length!=0) {
            for(int i=0; i<decodedResponse.length; i++) {
              String novelId= decodedResponse['user_posts'][i]['id'].toString();
              String novelTitle= decodedResponse['user_posts'][i]['post_body'].toString();
              String novelImage= decodedResponse['user_posts'][i]['post_attribute_3'].toString();
              finalResponse.add(['success', novelId, novelTitle, novelImage]);
            }
          } else {
            finalResponse.add(['zero', '0', 'error<divider%69>error', 'error']);
          }
          return finalResponse;
        } else {
        return [['error', '0', 'error<divider%69>error', 'error']];
      }
    } catch(e) {
      print(e);
      return [['error', '0', 'error<divider%69>error', 'error']];
    }
  }

  //user liked novels data
  Future<List<List<String>>> getUserLikedNovels(String token) async {
    List<List<String>> finalResponse= [];
    try {
      var response = await http.post(Uri.parse("http://ftunebackend.herokuapp.com/api/posts/likedposts"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $token"
          });
      var decodedResponse= json.decode(response.body);
      if (decodedResponse!=null) {
        for(int i=0; i<decodedResponse.length; i++) {
          String novelId= decodedResponse['posts'][i][0]['id'].toString();
          String novelTitle= decodedResponse['posts'][i][0]['post_body'].toString();
          String novelImage= decodedResponse['posts'][i][0]['post_attribute_3'].toString();
          finalResponse.add([novelId, novelTitle, novelImage]);
        }
        return finalResponse;
      } else {
        return [['0', 'error<divider%69>error', 'error']];
      }
    } catch(e) {
      print(e);
      return [['0', 'error<divider%69>error', 'error']];
    }
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
        saveString('user', 'user_userdata', 'user$userNumber<divider%54>instagram-account<divider%54>birthdate');
        saveString('user', 'user_userbillingdata', '2000<divider%54>non-premium');
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

  Future<List<String>> getUser(String token, String userId) async{
    var response = await http.get(Uri.parse("http://ftunebackend.herokuapp.com/api/getuser/$userId"),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        });
    var decodedResponse= json.decode(response.body);
    if (decodedResponse!=null) {
      String name= decodedResponse['user']['name'].toString();
      String email= decodedResponse['posts']['email'].toString();
      String image= decodedResponse['posts']['user_attribute_1'].toString();
      String detail= decodedResponse['posts']['user_attribute_3'].toString();
      String billingDetail= decodedResponse['posts']['user_attribute_4'].toString();
      List<String> finalResponse= [userId, name, email, image, detail, billingDetail];
      return finalResponse;
    } else {
      return ['error', 'error', 'error', 'error', 'error<divider%54>error<divider%54>error<divider%54>error', 'error<divider%54>error'];
    }
  }

  //required sub-functions:
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

  void saveString(String userId, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_generateKey(userId, key), value);
  }

  Future<String?> getString(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_generateKey(userId, key));
  }


}