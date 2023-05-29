import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/impactService.dart';

class AdvisePage extends StatelessWidget {
  const AdvisePage({Key? key}) : super(key: key);

  static const routename = 'AdvisePage';

  @override
  Widget build(BuildContext context) {
    final tokenManager = TokenManager();

    return Center(
        child: Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final sp = await SharedPreferences.getInstance();
            final result = await tokenManager.requestData();
            double somma = 0;
            double totalValidActivities = 0;
            for (var i = 0; i < result!.length; i++) {
              if (result[i].finalDistance > 0) {
                somma += result[i].finalDistance;
                totalValidActivities += 1;
              }
            }
            var meanDistance = somma / totalValidActivities;

            sp.setDouble('distance', meanDistance);

            final message =
                'Distanza media: ${meanDistance.toStringAsFixed(2)} km';

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          child: Text('get_data'),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await tokenManager.isBackendUp();
            final message =
                result ? 'IMPACT backend is up!' : 'IMPACT backend is down!';
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          child: Text('DEBUG:Ping IMPACT'),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await tokenManager.getAndStoreTokens();
            final message =
                result == 200 ? 'Request successful' : 'Request failed';
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Get tokens'),
                    content: Text(message),
                    actions: [
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the alert dialog
                        },
                      ),
                    ],
                  );
                });
          },
          child: Text('DEBUG:Get tokens'),
        ),
        ElevatedButton(
          onPressed: () async {
            final sp = await SharedPreferences.getInstance();
            final refresh = sp.getString('refresh');
            final message;
            if (refresh == null) {
              message = 'No stored tokens';
            } else {
              final result = await tokenManager.refreshTokens();
              message = result == 200 ? 'Request successful' : 'Request failed';
            } //if-else
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          child: Text('DEBUG:Refresh tokens'),
        ),
        ElevatedButton(
          onPressed: () async {
            final access = await tokenManager.getAccessToken();
            final refresh = await tokenManager.getRefreshToken();
            final message = access == null
                ? 'No stored tokens'
                : 'access: $access; refresh: $refresh';
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          child: Text('DEBUG:Print tokens'),
        )
      ],
    ));
  } //build
} //ProfilePage