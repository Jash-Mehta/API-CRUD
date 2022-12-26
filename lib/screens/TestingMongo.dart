import 'dart:convert';
import 'dart:io';
import 'package:apipratice/screens/display_data.dart';
import 'package:apipratice/screens/login.dart';
import 'package:apipratice/widget/drawer.dart';
import 'package:apipratice/widget/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../model/firebaseapi.dart';

var book, price, author, image, uid;
var pdffile, imagefile;

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
    Cdisplay = false;
  }

  bool Cdisplay = false;
  File? pdffiles;
  File? imagefiles;
  UploadTask? pdftask;
  UploadTask? imagetask;
  var urlpdf, urlimage;
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
                  Cdisplay
                      ? Navigator.pop(context)
                      : Scaffold.of(context).openDrawer();
                },
                icon: Cdisplay
                    ? const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )
                    : const Icon(
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
            child: Cdisplay
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              selectfile();
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                height: 140.0,
                                width: 140.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(
                                      Icons.upload_file,
                                      size: 40.0,
                                      color: Colors.black,
                                    ),
                                    Text("Upload PDF",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500))
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectimages();
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: 20.0),
                                height: 140.0,
                                width: 140.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(
                                      Icons.image,
                                      size: 40.0,
                                      color: Colors.black,
                                    ),
                                    Text("Upload Image",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500))
                                  ],
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        height: 40.0,
                        width: 200.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.blue),
                            onPressed: () {
                              uploadPDFfiles();
                              uploadImagefiles();
                              postdata();
                              yourbookfile();
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    image: const AssetImage(
                                        'assets/Mobilelife.png'),
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(1.0),
                                        BlendMode.dstATop),
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                      DetailScreen(
                        hinttext: "Book Name",
                        icon: const Icon(Icons.book),
                        onchange: (value) {
                          book = value;
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      DetailScreen(
                        hinttext: "Price",
                        icon: const Icon(CupertinoIcons.money_dollar),
                        onchange: (value) {
                          price = value;
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      DetailScreen(
                        hinttext: "Author Name",
                        icon: const Icon(Icons.person),
                        onchange: (value) {
                          author = value;
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 13.0, right: 13.0, top: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            hintText: 'Description',
                            icon: const Icon(Icons.info),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 60, horizontal: 30),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        height: 40.0,
                        width: 200.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.blue),
                            onPressed: () {
                              setState(() {
                                Cdisplay = true;
                              });
                            },
                            child: const Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  )));
  }

// !  #----------------Posting Data in API-----------------#
  Future postdata() async {
    var client = http.Client();
    var response = await client.post(
        Uri.parse(
            'https://instagram-ee2d1-default-rtdb.firebaseio.com//detail/$uid.json'),
        body: jsonEncode({
          'Book': book,
          'Price': price,
          'Author': author,
          'favdata': false,
          'imagelink': await urlimage,
          'pdfUrl': await urlpdf,
        }));
  }

// ! #----------------Selecting pdf from the devices---------------#
  Future selectfile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['pdf'],
        type: FileType.custom);
    if (result == null) return print("null is return");
    var path = result.files.single.path!;
    setState(() {
      pdffiles = File(path);
    });
  }

// ! #----------------Selecting images from the devices---------------#
  Future selectimages() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result == null) return print("null is return");
    var path = result.files.single.path!;
    setState(() {
      imagefiles = File(path);
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

  //! #-----------------------Upload the the pdf to the FirebaseStorage-------------------#
  Future uploadPDFfiles() async {
    if (pdffiles == null) return print("nothing");
    pdffile = pdffiles;
    final destination = 'BookPDF/$pdffile';
    print(' here is your destination ${destination}');
    pdftask = FirebasePDFApi.uploadFile(destination, pdffiles!);
    if (pdftask == null) return print("Task is null");
    final snapshot = await pdftask!.whenComplete(() {});
    urlpdf = await snapshot.ref.getDownloadURL();
    return urlpdf;
  }

  //! #-----------------------Upload the the images to the FirebaseStorage-------------------#
  Future uploadImagefiles() async {
    if (imagefiles == null) return print("nothing");
    imagefile = imagefiles;
    final destination = 'BookImage/$imagefile';
    print(' here is your destination ${destination}');
    imagetask = FirebaseimageApi.uploadFile(destination, imagefiles!);
    if (imagetask == null) return print("Task is null");
    final snapshot = await imagetask!.whenComplete(() {});
    urlimage = await snapshot.ref.getDownloadURL();
    return urlimage;
  }
}
