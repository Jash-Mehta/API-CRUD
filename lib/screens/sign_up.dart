import 'dart:convert';
import 'package:apipratice/screens/login.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart';

var password, email;

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

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
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
                      style: NeumorphicStyle(color: Colors.grey),
                    ),
                  ),
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                  hintText: "Email",
                  border: InputBorder.none),
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
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                  hintText: "Password",
                  border: InputBorder.none),
              onChanged: (value) {},
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
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NeumorphicIcon(
                    Icons.lock,
                    size: 30.0,
                    style: const NeumorphicStyle(color: Colors.grey),
                  ),
                ),
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
                hintText: "ConfirmPassword",
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Login())));
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
                "SIGNUP",
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

//! #--------------------------Firebase SIGNUP Authencation API----------------#
class Auth with ChangeNotifier {
  Future signup(String email, String password) async {
    var client = Client();
    var response = await client.post(
        /**
       * ! Same Method is apply to acheive Signin/Login......
       * ! Only Difference is that you have to change post link..........  
        */
        Uri.parse(
            // ! below link will change in Login Part..........
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDzQ0-lfmteC3wmd-nzDYL6lcfxCZa_4K0'),
        body: jsonEncode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ));
  }
}
