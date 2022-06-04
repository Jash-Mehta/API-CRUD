import 'dart:convert';
import 'dart:io';
import 'package:apipratice/screens/cart.dart';
import 'package:apipratice/screens/display_data.dart';
import 'package:apipratice/screens/fav_list.dart';
import 'package:apipratice/screens/login.dart';
import 'package:apipratice/widget/drawer.dart';
import 'package:apipratice/widget/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

var book, price, author, image, uid;

class TestingMongoDB extends StatefulWidget {
  const TestingMongoDB({Key? key}) : super(key: key);

  @override
  State<TestingMongoDB> createState() => _TestingMongoDBState();
}

class _TestingMongoDBState extends State<TestingMongoDB> {
  @override
  void initState() {
    super.initState();
    uid = Uuid().v1();
  }

  List data = [];
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Dashboard",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.clear_all,
                  color: Colors.black,
                ));
          }),
          actions: const [
            Icon(
              Icons.book_online_outlined,
              color: Colors.black,
            )
          ],
          elevation: 0,
        ),
        drawer: const DashDrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Books Publish",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 110.0,
                    width: 80.0,
                    margin: const EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: const AssetImage('assets/Mobilelife.png'),
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(1.0),
                                BlendMode.dstATop),
                            fit: BoxFit.cover)),
                  ),
                ],
              ),
              DetailScreen(
                hinttext: "Book Name",
                icon: Icon(Icons.book),
                onchange: (value) {
                  book = value;
                },
              ),
              const SizedBox(
                height: 25.0,
              ),
              DetailScreen(
                hinttext: "Price",
                icon: Icon(CupertinoIcons.money_dollar),
                onchange: (value) {
                  price = value;
                },
              ),
              const SizedBox(
                height: 25.0,
              ),
              DetailScreen(
                hinttext: "Author Name",
                icon: Icon(Icons.person),
                onchange: (value) {
                  author = value;
                },
              ),
              const SizedBox(
                height: 25.0,
              ),
              DetailScreen(
                hinttext: "Image link",
                icon: Icon(Icons.photo),
                onchange: (value) {
                  image = value;
                },
              ),
              const SizedBox(
                height: 25.0,
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
              const SizedBox(
                height: 25.0,
              ),
              SizedBox(
                height: 40.0,
                width: 150.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(onPrimary: Colors.blue),
                    onPressed: () {
                      postdata();
                      yourbookfile();
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ));
  }

// !  #----------------Posting Data in API-----------------#
  Future postdata() async {
    var client = http.Client();
    var response = client
        .post(
            Uri.parse(
                'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail/$uid.json'),
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

// ! #----------------Selecting files from the devices---------------#
  Future selectfile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    var path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }

  // ! #-----------------------Sending data to the Yourbook Screen-----------#
  Future yourbookfile() async {
    var client = http.Client();

    var response = client.post(
        Uri.parse(
            'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/yourbook.json'),
        body: jsonEncode({
          'useruid': uid,
        }));
  }
}
