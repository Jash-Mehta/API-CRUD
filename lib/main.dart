import 'dart:io';

import 'package:apipratice/screens/cart.dart';
import 'package:apipratice/screens/display_data.dart';
import 'package:apipratice/screens/fav_list.dart';
import 'package:apipratice/screens/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'widget/constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDzQ0-lfmteC3wmd-nzDYL6lcfxCZa_4K0',
          appId: '1:678956148693:ios:36d2ab4b7b6e35f78cff5c',
          messagingSenderId: '678956148693',
          projectId: 'instagram-ee2d1'));
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: kBlackColor,
            ),
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Bitmap.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displayMedium,
                children: const [
                  TextSpan(
                      text: "E-",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: "BookStore",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: NeumorphicButton(
                onPressed: (() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Login())));
                }),
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    depth: 10,
                    intensity: 0.86,
                    surfaceIntensity: 0.5,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    lightSource: LightSource.topLeft,
                    color: Colors.white),
                curve: Neumorphic.DEFAULT_CURVE,
                child: const Text(
                  "Start Reading",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
