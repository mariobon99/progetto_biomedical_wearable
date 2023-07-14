import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';
import '../utils/dates.dart';

class TokenManager {
  Future<bool> isBackendUp() async {
    final url = Impact.baseUrl + Impact.pingEndpoint;
    print('Calling: $url');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> getAndStoreTokens() async {
    //creo la richiesta
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    // Ottengo la risposta
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    // Se la risposta è corretta (codice 200) decodificare e salvare token
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if
    // return status code
    return response.statusCode;
  } //getAndStoreTokens(

//refresh tokens + li salvo nelle shared preferences
  Future<int> refreshTokens() async {
    //richiesta
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    //risposta
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //In casi di risposta affermativa (codice 200) salvare i valori nelle shared preferences
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_refreshTokens

  Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('access');
  }

  Future<String?> getRefreshToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('refresh');
  }

  Future<List?> requestData() async {
    //Initialize the result
    List<Activity> result = [];

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');
    var refresh = sp.getString('refresh');

    // If refresh token is expired, relog
    if (JwtDecoder.isExpired(access!)) {
      await getAndStoreTokens();
      access = sp.getString('access');
    }

    //If access token is expired, refresh it
    if (JwtDecoder.isExpired(access!)) {
      await refreshTokens();
      access = sp.getString('access');
    } //if

    // request of the data for multiple weeks
    for (var n = 0; n < 2; n++) {
      final startday =
          CustomDate(date: DateTime.now().subtract(Duration(days: 8 + 7 * n)))
              .toString();
      final endday =
          CustomDate(date: DateTime.now().subtract(Duration(days: 1 + 7 * n)))
              .toString();
      final url = Impact.baseUrl +
          Impact.exerciseEndpoint +
          Impact.patientUsername +
          '/daterange/start_date/$startday/end_date/$endday';
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

      //Get the response
      print('Calling: $url');
      final response = await http.get(Uri.parse(url), headers: headers);
      //if OK parse the response, otherwise return null
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        for (var i = 0; i < decodedResponse['data'].length; i++) {
          for (var j = 0; j < decodedResponse['data'][i]['data'].length; j++) {
            var activity = Activity(
              name: decodedResponse['data'][i]['data'][j]['activityName'],
              duration: decodedResponse['data'][i]['data'][j]['duration'],
              steps: decodedResponse['data'][i]['data'][j]['steps'],
              distance: decodedResponse['data'][i]['data'][j]['distance'],
            );
            result.add(activity);
          } //for
        } //for
      } // if
      //Return the result
    }
    return result; //_requestData
  }
}// TokenManager