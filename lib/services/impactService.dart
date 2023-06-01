import 'dart:convert';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class TokenManager{

Future<bool> isBackendUp() async {
    final url = Impact.baseUrl + Impact.pingEndpoint;
    print('Calling: $url');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200){
      return true;
    } else {
        return false;
    }
  }
  
Future<int> getAndStoreTokens() async{
  //creo la richiesta
  final url=Impact.baseUrl+ Impact.tokenEndpoint;
  final body= {'username': Impact.username, 'password': Impact.password};

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
}//getAndStoreTokens(

//refresh tokens + li salvo nelle shared preferences
Future<int> refreshTokens() async{
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
}//_refreshTokens

Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('access');
  }

  Future<String?> getRefreshToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('refresh');
  }
  
}// TokenManager
