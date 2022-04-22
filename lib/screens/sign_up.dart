import 'dart:convert';

import 'package:apipratice/screens/TestingMongo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

var password, email;

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

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
            onChanged: (value) {},
          ),
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                hintText: "ConfirmPassword",
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
              child: const Text("Signup"))
        ],
      ),
    );
  }
}

//! #--------------------------Firebase SIGNUP Authencation API----------------#
class Auth with ChangeNotifier {
  Future<void> signup(String email, String password) async {
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
    print(response.body);
  }
}
