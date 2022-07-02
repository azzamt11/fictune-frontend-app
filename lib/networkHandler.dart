import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl = "http://ftunebackend.herokuapp.com/api";
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();
  Future get(String url) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    // /user/register
    var response = await http.get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);

      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
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

  Future<http.Response> put(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
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

  Future<http.Response> delete(String url) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    var response = await http.delete(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    });
    return response;
  }

  Future<http.Response> register(String url, Map<String, String> body) async {
    url = formater(url);
    var response = await http.post(Uri.parse(url), body: json.encode(body));
    var decodedResponse= json.decode(response.body);  //updated
    return response;
  }

  String formater(String url) {
    return baseurl + url;
  }
}