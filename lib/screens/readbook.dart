import 'dart:async';
import 'dart:io';
import 'package:apipratice/screens/pdfview.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class Readbook extends StatefulWidget {
  String imageurl;
  String price;
  String bookname;
  String author;
  String pdfurl;
  Readbook({
    Key? key,
    required this.imageurl,
    required this.price,
    required this.bookname,
    required this.author,
    required this.pdfurl,
  }) : super(key: key);

  @override
  State<Readbook> createState() => _ReadbookState();
}

class _ReadbookState extends State<Readbook> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfilefromUrl(widget.pdfurl).then((value) {
      setState(() {
        pathPDF = value.path;
        print(pathPDF);
      });
    });
  }

  String pathPDF = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Read book",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ))
          ],
        ),
        body: Column(children: [
          Stack(
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: 400,
                  borderRadius: 0,
                  blur: 20,
                  alignment: Alignment.bottomCenter,
                  border: 2,
                  linearGradient: LinearGradient(colors: [
                    Color.fromARGB(255, 27, 8, 231).withOpacity(0.3),
                    Colors.white38.withOpacity(0.2)
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderGradient: LinearGradient(colors: [
                    Colors.white24.withOpacity(0.2),
                    Colors.white70.withOpacity(0.2)
                  ]),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                        child: Text(widget.bookname,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 30.0, fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('WrittenBy:-${widget.author}',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700)),
                      ),
                      RatingBar.builder(
                        initialRating: 3.5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(
                        width: 250.0,
                        height: 100.0,
                        child: Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                                "Description:- Hello everyone this is Jash Mehta, very good developer and very good at developing",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 15.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: Image.network(
                          widget.imageurl,
                          width: 135.0,
                          height: 190.0,
                        ),
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => PDFreader(
                                          pdfurl: pathPDF,
                                          booktitle: widget.bookname,
                                        ))));
                          },
                          style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.black26;
                                  return null;
                                },
                              ),
                              side: MaterialStateProperty.all(const BorderSide(
                                  color: Colors.black, width: 2.0))),
                          child: const Text(
                            "Read Book",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                          )),
                      Row(
                        children: [
                          FloatingActionButton(
                            heroTag: "b1",
                            backgroundColor: Colors.black,
                            onPressed: () {},
                            child: const Icon(CupertinoIcons.cart),
                          ),
                          const SizedBox(
                            width: 9.0,
                          ),
                          FloatingActionButton(
                            heroTag: "b2",
                            backgroundColor: Colors.black,
                            hoverColor: Color.fromARGB(255, 253, 253, 253),
                            onPressed: () {},
                            child: const Icon(CupertinoIcons.heart),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ]));
  }

//! #-----------------------PDF URl from the firebase-----------------------#
  Future<File> getfilefromUrl(String url) async {
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/.pdf');
      File urlfile = await file.writeAsBytes(bytes);
      return urlfile;
    } catch (e) {
      throw ('error is there');
    }
  }
}

//! #-----------------------Curve code in the readbook Screen-------------------------#
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 50;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(1, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}