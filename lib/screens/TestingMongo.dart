import 'dart:convert';
import 'dart:io';
import 'package:apipratice/screens/login.dart';
import 'package:apipratice/widget/drawer.dart';
import 'package:apipratice/widget/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/main_page_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
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
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                    depth: -5,
                                    intensity: 0.86,
                                    shadowDarkColorEmboss: Colors.black87,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(12)),
                                    lightSource: LightSource.topLeft,
                                    color: Colors.white),
                                child: Container(
                                    margin: const EdgeInsets.only(top: 20.0),
                                    height: 140.0,
                                    width: 140.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NeumorphicIcon(
                                          Icons.upload_file_rounded,
                                          size: 35.0,
                                          style: const NeumorphicStyle(
                                              shadowDarkColor: Colors.black,
                                              color: Colors.black),
                                        ),
                                        const Text("Upload PDF",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                selectimages();
                              },
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: -5,
                                    intensity: 0.86,
                                    shadowDarkColorEmboss: Colors.black87,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(12)),
                                    lightSource: LightSource.topLeft,
                                    color: Colors.white),
                                child: Container(
                                    margin: const EdgeInsets.only(top: 20.0),
                                    height: 140.0,
                                    width: 140.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NeumorphicIcon(
                                          Icons.image,
                                          size: 35.0,
                                          style: const NeumorphicStyle(
                                              shadowDarkColor: Colors.black,
                                              color: Colors.black),
                                        ),
                                        const Text("Upload Image",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: NeumorphicButton(
                            onPressed: (() {
                              uploadPDFfiles();
                              uploadImagefiles();
                              postdata();
                              yourbookfile();
                            }),
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                depth: 10,
                                intensity: 0.86,
                                surfaceIntensity: 0.86,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(12)),
                                lightSource: LightSource.topLeft,
                                color: Colors.white),
                            curve: Neumorphic.DEFAULT_CURVE,
                            child: const Text(
                              "SUBMIT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0, bottom: 20.0, top: 15.0),
                              child: Text(
                                "BOOK \nPUBLISH",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 55.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        DetailScreen(
                          hinttext: "Book Name",
                          keyboardType: TextInputType.text,
                          icon: const Icon(Icons.book),
                          onchange: (value) {
                            book = value;
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        DetailScreen(
                          hinttext: "Your Price",
                          keyboardType: TextInputType.phone,
                          icon: const Icon(CupertinoIcons.money_dollar),
                          onchange: (value) {
                            price = value;
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        DetailScreen(
                          keyboardType: TextInputType.text,
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
                          child: Neumorphic(
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                depth: -5,
                                intensity: 0.86,
                                shadowDarkColorEmboss: Colors.black,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(12)),
                                lightSource: LightSource.topLeft,
                                color: Colors.white),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                                border: InputBorder.none,
                                hintText: 'Description',
                                prefixIcon: Icon(Icons.info),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 60, horizontal: 30),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: NeumorphicButton(
                            onPressed: (() {
                              setState(() {
                                Cdisplay = true;
                              });
                            }),
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                depth: 10,
                                intensity: 0.86,
                                surfaceIntensity: 0.86,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(12)),
                                lightSource: LightSource.topLeft,
                                color: Colors.white),
                            curve: Neumorphic.DEFAULT_CURVE,
                            child: const Text(
                              "NEXT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    )),
        ));
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
          'imagelink': urlimage,
          'pdfUrl': urlpdf,
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
