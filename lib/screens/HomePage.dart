import 'package:flutter/material.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  

  static const routename = 'HomePage';

  
  @override
  Widget build(BuildContext context) {
    //return const Center(child: Text('HomePage'));
    // creo uninstanza di tokenManager
    final tokenManager = TokenManager();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await tokenManager.isBackendUp();
                  final message = result
                      ? 'IMPACT backend is up!'
                      : 'IMPACT backend is down!';
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
              },
              child: Text('DEBUG:Ping IMPACT'),
              ),
            ElevatedButton(
              onPressed: ()async{
                final result = await tokenManager.getAndStoreTokens();
                  final message =
                      result == 200 ? 'Request successful' : 'Request failed';
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
              }, 
              child: Text('DEBUG:Get tokens'),
              ),
            ElevatedButton(
              onPressed: ()async{
                final sp = await SharedPreferences.getInstance();
                  final refresh = sp.getString('refresh');
                  final message;
                  if (refresh == null) {
                    message = 'No stored tokens';
                  } else {
                    final result = await tokenManager.refreshTokens();
                    message =
                        result == 200 ? 'Request successful' : 'Request failed';
                  } //if-else
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
              }, 
              child: Text('DEBUG:Refresh tokens'),
              ),
              ElevatedButton(
                onPressed: ()async{
                  final access= await tokenManager.getAccessToken();
                  final refresh= await tokenManager.getRefreshToken();
                  final message= access==null
                      ? 'No stored tokens'
                      : 'access: $access; refresh: $refresh';
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                }, 
                child: Text('DEBUG:Print tokens'),
                )
          ],
        )
      )
    );
  }
}
