import 'dart:convert';
import 'dart:io';
import 'package:apipratice/screens/cart.dart';
import 'package:apipratice/screens/display_data.dart';
import 'package:apipratice/screens/fav_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var book, price, author, image;

class TestingMongoDB extends StatefulWidget {
  const TestingMongoDB({Key? key}) : super(key: key);

  @override
  State<TestingMongoDB> createState() => _TestingMongoDBState();
}

class _TestingMongoDBState extends State<TestingMongoDB> {
  @override
  void initState() {
    super.initState();
  }

  List data = [];
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Testing MongoDB"),
        ),
        drawer: Drawer(
            child: Column(
          children: [
            const DrawerHeader(
                child: CircleAvatar(
              radius: 60,
            )),
            const ListTile(
              leading: Icon(
                CupertinoIcons.cloud_upload,
                size: 30,
                color: Colors.blue,
              ),
              title: Text(
                "Posting Data",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DisplayData()));
              },
              leading: const Icon(
                CupertinoIcons.cloud_download,
                size: 30,
                color: Colors.blue,
              ),
              title: const Text(
                "Fetching Data",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FavList()));
              },
              child: const ListTile(
                leading: Icon(
                  CupertinoIcons.heart,
                  size: 30,
                  color: Colors.blue,
                ),
                title: Text(
                  "Favorite List",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Carts()));
              },
              child: const ListTile(
                leading: Icon(
                  CupertinoIcons.cart,
                  size: 30,
                  color: Colors.blue,
                ),
                title: Text(
                  "Cart",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  hintText: "Book Name",
                  icon: const Icon(Icons.book)),
              onChanged: (value) {
                book = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  hintText: "Price",
                  icon: const Icon(CupertinoIcons.money_dollar)),
              onChanged: (value) {
                price = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  hintText: "Author Name",
                  icon: const Icon(Icons.person)),
              onChanged: (value) {
                author = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  hintText: "Image link",
                  icon: const Icon(Icons.photo)),
              onChanged: (value) {
                image = value;
              },
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    selectfile();
                  },
                  icon: const Icon(
                    Icons.picture_as_pdf,
                    size: 35.0,
                    color: Colors.black45,
                  )),
              title: const Text(
                "SELECT PDF",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 40.0,
              width: 150.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(onPrimary: Colors.blue[900]),
                  onPressed: () {
                    postdata();
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ));
  }

// !  #----------------Posting Data in API-----------------#
  Future postdata() async {
    var client = http.Client();
    var response = client
        .post(
            Uri.parse(
                'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail.json'),
            body: jsonEncode({
              'Book': book,
              'Price': price,
              'Author': author,
              'favdata': false,
              'imagelink': image
            }))
        .whenComplete(() => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const DisplayData())));
  }

  Future selectfile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    var path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }
}
