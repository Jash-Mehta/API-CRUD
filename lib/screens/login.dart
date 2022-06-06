import 'dart:convert';

import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/TestingMongo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

var password, email;
String? localuid;

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SIGN UP", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                hintText: "Email",
                icon: const Icon(Icons.email)),
            onChanged: (value) {
              email = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                hintText: "Password",
                icon: const Icon(Icons.lock)),
            onChanged: (value) {
              password = value;
            },
          ),
          ElevatedButton(
              onPressed: () {
                Auth().signup(email, password).whenComplete(() =>
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => TestingMongoDB())));
                print("auth class is called");
              },
              child: const Text("Login"))
        ],
      ),
    );
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