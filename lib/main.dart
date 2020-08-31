import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/pages/wrapper.dart';
import 'package:salam/services/auth.dart';
void main() async{
  final String VERSION = '1.0.0';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  final defaults = <String, dynamic>{'force_update_app_version' : '1.0.3'};
  await remoteConfig.setDefaults(defaults);
  await remoteConfig.fetch(expiration: const Duration(minutes: 1));
  print (await remoteConfig.activateFetched());
  if(remoteConfig.getString('force_update_app_version') == VERSION) {
    print('welcome message: ' + remoteConfig.getString('force_update_app_version'));
    runApp(MyApp());
  } else {
    runApp(UpdateApp());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<auth.User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      ),
    );
  }
}

class UpdateApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: AlertDialog(content: Text('يرجى تحديث التطبيق',style: TextStyle(fontSize: 20.0),))),
    );
  }
}
