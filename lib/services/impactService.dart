import '../utils/utils.dart';
import 'dart:convert';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<int> getAndStoreTokens(String username, String password) async {
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': username, 'password': password};
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    }
    return response.statusCode;
  } //getAndStoreTokens

  Future<int> refreshTokens() async {
    //richiesta
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    }

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
      //if OK parse the response
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
          }
        }
      }
    }
    return result;
  }
}
