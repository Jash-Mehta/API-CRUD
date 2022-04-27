import 'package:apipratice/screens/TestingMongo.dart';
import 'package:apipratice/screens/sign_up.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          iconTheme: IconThemeData(color: Colors.blue),
          primaryIconTheme: IconThemeData(color: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: const Signup(),
    );
  }
}
