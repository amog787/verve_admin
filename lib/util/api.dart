import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'jwt_decode.dart';

String baseUrl = 'http://localhost:3900/api';

// Check login status
Future<bool> checkLogin() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  return token != null && token.isNotEmpty;
}

// Perform login
Future<Map<String, dynamic>> performLogin(String usn, String password) async {
  try {
    http.Response response = await http
        .post(baseUrl + '/auth', body: {'usn': usn, 'password': password});
    Map<String, dynamic> data = json.decode(response.body);
    if (data['success']) {
      Map<String, dynamic> decoded = parseJwt(data['data']);
      if (decoded['isAdmin']) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('token', data['data']);
      } else {
        return {'success': false, 'message': "You're not an admin."};
      }
    }
    return data;
  } catch (ex) {
    Map<String, dynamic> data = {
      'success': false,
      'message': 'Something went wrong. Try again later.'
    };
    if (ex is SocketException) {
      data['message'] = "You're not connected to the internet.";
    }
    return data;
  }
}

// Perform logout
Future<bool> performLogout() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool res = await sharedPreferences.remove('token');
  return res;
}

// GET 'accounts', 'activities', 'users/:id'
Future<Map<String, dynamic>> performGet(String endpoint) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  try {
    http.Response response = await http
        .get(baseUrl + '/' + endpoint, headers: {'X-Auth-Token': token});
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  } catch (ex) {
    Map<String, dynamic> data = {
      'success': false,
      'message': 'Something went wrong. Try again later.'
    };
    if (ex is SocketException) {
      data['message'] = "You're not connected to the internet.";
    }
    return data;
  }
}

// POST 'accounts'
Future<dynamic> performPost(String endpoint, Map<String, dynamic> body) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  try {
    http.Response response = await http.post(baseUrl + '/' + endpoint,
        body: body, headers: {'X-Auth-Token': token});
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  } catch (ex) {
    Map<String, dynamic> data = {
      'success': false,
      'message': 'Something went wrong. Try again later.'
    };
    if (ex is SocketException) {
      data['message'] = "You're not connected to the internet.";
    }
    return data;
  }
}

// PUT 'users/booklet'
Future<dynamic> performPut(String endpoint, Map<String, dynamic> body) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  try {
    http.Response response = await http.put(baseUrl + '/' + endpoint,
        body: body, headers: {'X-Auth-Token': token});
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  } catch (ex) {
    Map<String, dynamic> data = {
      'success': false,
      'message': 'Something went wrong. Try again later.'
    };
    if (ex is SocketException) {
      data['message'] = "You're not connected to the internet.";
    }
    return data;
  }
}
