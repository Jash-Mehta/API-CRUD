import 'dart:convert';

import 'package:apipratice/screens/display_data.dart';
import 'package:apipratice/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:apipratice/widget/text_field.dart';

var updatename, updateprice, updateimagelink;

class UpdateBook extends StatefulWidget {
  String name;
  String price;
  String imageurl;
  var id;
  UpdateBook({
    Key? key,
    required this.name,
    required this.price,
    required this.imageurl,
    required this.id,
  }) : super(key: key);

  @override
  State<UpdateBook> createState() => _UpdateBookState();
}

class _UpdateBookState extends State<UpdateBook> {
  bool change_price = false;
  bool change_name = false;
  bool change_imageurl = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Book's",
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: NetworkImage(widget.imageurl))),
              ),
            ),
            Text(
              '₹ ${widget.price}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            DetailScreen(
              hinttext: 'Book Name',
              predefine: widget.name,
              icon: Icon(Icons.book),
              onchange: (value) {
                updatename = value;
                setState(() {
                  change_name = true;
                });
              },
            ),
            DetailScreen(
              hinttext: 'Price',
              predefine: widget.price,
              icon: Icon(Icons.monetization_on_outlined),
              onchange: (value) {
                updateprice = value;
                setState(() {
                  change_price = true;
                });
              },
            ),
            DetailScreen(
              hinttext: "ImageUrl",
              predefine: widget.imageurl,
              icon: Icon(Icons.image),
              onchange: (value) {
                updateimagelink = value;
                setState(() {
                  change_imageurl = true;
                });
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              height: 40.0,
              width: 150.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(onPrimary: Colors.blue),
                  onPressed: () {
                    updatebook(widget.id);
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  //! #-----------------Update on DetailScreen------------#
  Future updatebook(String id) async {
    var client = http.Client();
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/yourbook.json'));
    if (response.statusCode == 200) {
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
      extractdata.forEach((key, value) {
        var useruid = value as Map<String, dynamic>;
        useruid.forEach((keys, values) async {
          var detailresponse = await client.get(Uri.parse(
              'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail/$id.json'));
          var extract_detail_data =
              jsonDecode(detailresponse.body) as Map<String, dynamic>;
          extract_detail_data.forEach((key, value) async {
            var response = await client
                .patch(
                    Uri.parse(
                        'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail/$id/$key.json'),
                    body: jsonEncode({
                      'Book': change_name ? updatename : widget.name,
                      'Price': change_price ? updateprice : widget.price,
                      'imagelink':
                          change_imageurl ? updateimagelink : widget.imageurl,
                    }))
                .whenComplete(() => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DisplayData())));
          });
        });
      });

      return extractdata;
    }
  }
}
