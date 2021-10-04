import 'dart:async';

import 'package:relateddigital_flutter/request_models.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/response_models.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final RelateddigitalFlutter relatedDigitalPlugin = RelateddigitalFlutter();
  String token = '-';
  String email = 'egemen@visilabs.com';
  final bool emailPermission = true;
  @override
  void initState() {
    super.initState();
    initLib();
  }
  Future<void> initLib() async {
    var initRequest = RDInitRequestModel(
      appAlias: Constants.APP_ALIAS,
      huaweiAppAlias: Constants.HUAWEI_APP_ALIAS, // Android only
      androidPushIntent: Constants.ANDROID_PUSH_INTENT, // Android only
      organizationId: Constants.ORGANIZATION_ID,
      siteId: Constants.SITE_ID,
      dataSource: Constants.DATA_SOURCE,
      maxGeofenceCount: Constants.MAX_GEOFENCE_COUNT,  // IOS only
      geofenceEnabled: Constants.GEOFENCE_ENABLED,
      inAppNotificationsEnabled: Constants.IN_APP_NOTIFICATIONS_ENABLED, // IOS only
      logEnabled: Constants.LOG_ENABLED,
    );
    await relatedDigitalPlugin.init(initRequest, _readNotificationCallback);
  }

  void _getTokenCallback(RDTokenResponseModel result) {
    if(result != null && result.deviceToken != null && result.deviceToken.isNotEmpty) {
      print('Token ' + result.deviceToken);
      setState(() {
        token = result.deviceToken;
      });
    }
    else {
      setState(() {
        token = 'Token not retrieved';
      });
    }
  }

  void _readNotificationCallback(dynamic result) {
    print('_readNotificationCallback');
    print(result);
  }
  Future<void> requestPermission() async {
    await relatedDigitalPlugin.requestPermission(_getTokenCallback);
  }
  Future<void> setEmail() async {
    await relatedDigitalPlugin.setEmail(email, emailPermission);
  }
  Future<void> registerEmail() async {
    bool permission = true;
    bool isCommercial = false;
    await relatedDigitalPlugin.registerEmail(email, permission: permission, isCommercial: isCommercial);
    await relatedDigitalPlugin.setEmail('egemen@visilabs.com', true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Token: $token\n'),
                ElevatedButton(
                    onPressed: () {
                      requestPermission();
                    },
                    child: Text('Get Token')
                ),
                Container(
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setEmail();
                          },
                          child: Text('Set Email')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            registerEmail();
                          },
                          child: Text('Register Email')
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}