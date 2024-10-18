import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:yoga_centre_app/presentation/util/Appconstatnts.dart';
import 'package:yoga_centre_app/presentation/util/pref.dart';
import 'package:flutter/material.dart';

class Apiservice {
  static const int timeOutDuration = 35;
  String userid = Prefs.getUserName("UserName").toString();

  static Future<http.Response> getlogin(
      String username, String password) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.Login);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {"username": username, "userpassword": password};
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> getcoursemaster(d) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.getcourcemaster);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );
    return response;
  }

  static Future<http.Response> getenrollmaster(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.enroll);
    Map<String, String> headers = {"Content-Type": "application/json"};

    //var body = {"username": username, "userpassword": password};
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    // print(response);
    return response;
  }

  static Future<http.Response> getcourcemaster() async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.getcourcemaster);
    Map<String, String> headers = {"Content-Type": "application/json"};

    //var body = {"username": username, "userpassword": password};
    var response = await http.get(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );
    //print(jsonEncode(json));
    return response;
  }

  static Future<http.Response> getscrorelist(dynamic json) async {
    var url = Uri.parse(AppConstants.LOCAL_URL + AppConstants.myscore);
    Map<String, String> headers = {"Content-Type": "application/json"};

    //var body = {"username": username, "userpassword": password};
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    // print(response);
    return response;
  }
}
