import 'package:apipratice/screens/login.dart';
import 'package:apipratice/screens/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDzQ0-lfmteC3wmd-nzDYL6lcfxCZa_4K0',
          appId: '1:678956148693:ios:36d2ab4b7b6e35f78cff5c',
          messagingSenderId: '678956148693',
          projectId: 'instagram-ee2d1'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.blue),
          primaryIconTheme: const IconThemeData(color: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}
