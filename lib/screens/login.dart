import 'dart:convert';
import 'package:apipratice/screens/TestingMongo.dart';
import 'package:apipratice/widget/bottombar.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart';

var password, email;
String? localuid;

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Neumorphic(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                shadowDarkColorEmboss: Colors.black87,
                depth: -5,
                intensity: 0.86,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                lightSource: LightSource.topLeft,
                color: Colors.white),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NeumorphicIcon(
                    Icons.email,
                    size: 30.0,
                    style: const NeumorphicStyle(color: Colors.grey),
                  ),
                ),
                border: InputBorder.none,
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
                hintText: "Email",
              ),
              onChanged: (value) {
                email = value;
              },
            ),
          ),
          Neumorphic(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                shadowDarkColorEmboss: Colors.black87,
                depth: -5,
                intensity: 0.86,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                lightSource: LightSource.topLeft,
                color: Colors.white),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NeumorphicIcon(
                    Icons.lock,
                    size: 30.0,
                    style: const NeumorphicStyle(color: Colors.grey),
                  ),
                ),
                border: InputBorder.none,
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
                hintText: "Password",
              ),
              onChanged: (value) {
                password = value;
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .6,
            child: NeumorphicButton(
              onPressed: (() {
                Auth().signup(email, password).whenComplete(() =>
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => BottomBar())));
              }),
              style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  depth: 10,
                  intensity: 0.86,
                  surfaceIntensity: 0.86,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  lightSource: LightSource.topLeft,
                  color: Colors.white),
              curve: Neumorphic.DEFAULT_CURVE,
              child: const Text(
                "LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

//! #--------------------------Firebase LOGIN Authencation API----------------#
class Auth with ChangeNotifier {
  Future signup(String email, String password) async {
    var client = Client();
    var response = await client.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDzQ0-lfmteC3wmd-nzDYL6lcfxCZa_4K0'),
        body: jsonEncode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ));
    if (response.statusCode == 200) {
      final extractdata = jsonDecode(response.body);
      localuid = extractdata['localId'];
      print(localuid);
    }
  }
}
