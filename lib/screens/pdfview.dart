import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/TestingMongo.dart';
import 'package:apipratice/screens/login.dart';
import 'package:translator/translator.dart';

String? keyword;
List<DictWord> dictword = [];
PdfViewerController _controller = PdfViewerController();
List<Detail> _iteam = [];
var imgurl, pdfurl, booktitle, price, currentpageno;

enum SampleItem { itemOne, itemTwo, itemThree }

class PDFreader extends StatefulWidget {
  String pdfurl;
  String booktitle;
  String imagurl;
  String price;

  PDFreader({
    Key? key,
    required this.pdfurl,
    required this.booktitle,
    required this.imagurl,
    required this.price,
  }) : super(key: key);

  @override
  State<PDFreader> createState() => _PDFreaderState();
}

class _PDFreaderState extends State<PDFreader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.pdfurl;
    imgurl = widget.imagurl;
    pdfurl = widget.pdfurl;
    price = widget.price;
    booktitle = widget.booktitle;

    readingmode ? _pdfViewerController.jumpToPage(currentpageno) : null;
    setState(() {});
  }

  int totalpages = 0;
  int currentpages = 0;
  int roundoffpages = 0;
  late SharedPreferences sharedPreferences;
  bool isready = false;
  var startpage, endpage;
  var translatingtext, parapharasedata;
  bool isselectready = false;
  bool readingmode = false;
  bool pharaprase = false;
  PdfViewerController _pdfViewerController = PdfViewerController();
  GoogleTranslator translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.booktitle,
            style: const TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ));
          }),
          actions: [
            Icon(
              Icons.search,
              color: Colors.black,
            ),
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                // popupmenu item 1
                PopupMenuItem(
                  value: 1,
                  onTap: () {
                    _pdfViewerController.zoomLevel = 1.5;
                    readingmode = true;

                    continuepostdata();
                    if (readingmode == true) {
                      currentpageno = sharedPreferences.getInt('olderpage');
                    }
                    setState(() {});
                  },
                  // row has two child icon and text.
                  child: Row(
                    children: [
                      Icon(Icons.book_outlined),
                      SizedBox(
                        // sized box with width 10
                        width: 10,
                      ),
                      Text("Reading Mode")
                    ],
                  ),
                ),
                // popupmenu item 2
                PopupMenuItem(
                  value: 2,
                  // row has two child icon and text
                  child: Row(
                    children: [
                      Icon(Icons.bookmark_add),
                      SizedBox(
                        // sized box with width 10
                        width: 10,
                      ),
                      Text("Book Mark")
                    ],
                  ),
                ),
              ],
              offset: Offset(0, 50),
              color: Colors.grey,
              elevation: 2,
            ),
          ],
          elevation: 0,
        ),
        body: SfPdfViewer.network(widget.pdfurl,
            interactionMode: PdfInteractionMode.pan,
            scrollDirection: PdfScrollDirection.horizontal,
            pageLayoutMode: PdfPageLayoutMode.single,
            enableDoubleTapZooming: true,
            enableTextSelection: true,
            controller: _pdfViewerController, onPageChanged: (details) async {
          readingmode ? _pdfViewerController.zoomLevel = 1.5 : 0;
          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setInt('olderpage', details.oldPageNumber ?? 2);
          setState(() {});
        }, onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          keyword = details.selectedText;
          final selectionreact = details.globalSelectedRegion;

          isselectready = false;
          setState(() {
            isready = true;
            isselectready = true;
          });
        }),
        floatingActionButton: isready
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: FloatingActionButton(
                        onPressed: () {
                          //translateText(keyword.toString(), 'hi');
                          translator
                              .translate(keyword.toString(),
                                  from: 'en', to: 'hi')
                              .then((s) {
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Translating Text",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              height: 30.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                // color: Color.fromARGB(255, 37, 37, 37),
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 37, 37, 37),
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Center(
                                                child: Text("English"),
                                              ),
                                            ),
                                            Text("to"),
                                            Container(
                                              height: 30.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                // color: Color.fromARGB(255, 37, 37, 37),
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 37, 37, 37),
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Center(
                                                child: Text("Hindi"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Container(
                                          // height: 200.0,
                                          width: double.infinity,
                                          margin: EdgeInsets.only(top: 15.0),
                                          decoration: BoxDecoration(
                                              // color: Color.fromARGB(255, 37, 37, 37),
                                              border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 37, 37, 37),
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                s.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      Center(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 37, 37, 37),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              "Close",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      )
                                    ],
                                  );
                                },
                              ).whenComplete(() => translatingtext = "");
                            });
                          });
                        },
                        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                        child: Icon(Icons.translate)),
                  ),
                  Spacer(),
                  FloatingActionButton(
                      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                      child: Image.asset(
                        'assets/dict.png',
                        height: 30.0,
                        width: 30.0,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        //! Fetching keyword of our book---------------------------------------
                        var client = http.Client();
                        var response = await client.get(Uri.parse(
                            'https://api.dictionaryapi.dev/api/v2/entries/en/$keyword'));
                        if (response.statusCode == 200) {
                          var jsonbody =
                              jsonDecode(response.body) as List<dynamic>;
                          List<DictWord> words = [];
                          for (var element in jsonbody) {
                            words.add(DictWord(
                                meaning: element['meanings'][0]['definitions']
                                    [0]['definition'],
                                partofspeech: element['meanings'][0]
                                    ['partOfSpeech'],
                                example: "here is your example"));
                            // print(element['meanings'][0]['definitions']);
                          }

                          dictword = words;
                          setState(() {});

                          setState(() {
                            isselectready
                                ? showDialog(
                                    context: context,
                                    builder: ((context) => AlertDialog(
                                          title: Text("Meaning of ${keyword}"),
                                          content: setupAlertDialoadContainer(),
                                        ))).whenComplete(() => dictword.clear())
                                : SizedBox();
                          });
                        }
                      }),
                  SizedBox(
                    width: 10.0,
                  ),
                  FloatingActionButton(
                      //! Pharaprase API code and FlatButton is here------------------>
                      onPressed: () async {
                        var apiKey = "p5twx8IKEkstVdKt7b7Lv3vl7sgB9TmG";
                        final url = 'https://api.ai21.com/studio/v1/paraphrase';
                        String cleanedText =
                            keyword!.replaceAll(RegExp(r'\s+'), ' ');
                        print("${keyword}");
                        final response = await http.post(
                          Uri.parse(url),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $apiKey',
                          },
                          body: '{"text": "${cleanedText}"}',
                        );

                        if (response.statusCode == 200) {
                          var paraphrasedText =
                              jsonDecode(response.body) as Map<String, dynamic>;
                          paraphrasedText.forEach((key, value) {
                            parapharasedata = value[2].toString();
                            setState(() {
                              pharaprase = true;
                            });
                          });
                        } else {
                          throw Exception(
                              'Failed to paraphrase text. Status code: ${response.statusCode}');
                        }
                        // pharaprase
                        //     ? showDialog(
                        //         context: context,
                        //         builder: (BuildContext context) {},
                        //       )
                        //     : SizedBox();
                      },
                      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                      child: Image.asset(
                        'assets/chatgpt.png',
                        height: 30.0,
                        width: 30.0,
                        color: Colors.white,
                      )),
                ],
              )
            : Container()

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _pdfViewerController.zoomLevel = 1.5;
        //   },
        //   child: Icon(Icons.read_more),
        // ),
        //     : Container(),
        );
  }
}

Widget setupAlertDialoadContainer() {
  return StatefulBuilder(builder: (context, setState) {
    return SizedBox(
      height: 130.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: dictword.length,
        itemBuilder: (BuildContext context, int index) {
          var article = dictword[index];

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.partofspeech),
              Text(
                article.meaning,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                article.example,
                style: const TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
              )
            ],
          );
        },
      ),
    );
  });
}

//! Continue Reading Mode----------------------->
Future continuepostdata() async {
  var client = http.Client();
  var response = await client.post(
      Uri.parse(
          "https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/ContinueReading.json"),
      body: jsonEncode({
        'Book': booktitle,
        'Price': price,
        'Author': author,
        'favdata': false,
        'imagelink': imgurl,
        'pdfUrl': pdfurl,
        'resumepageno': currentpageno
      }));
  if (response.statusCode == 200) {}
}

//! -------------------->
Future continuegetdata() async {
  var client = http.Client();
  var response = await client.get(Uri.parse(
      'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail.json'));
  if (response.statusCode == 200) {
    List<Detail> detaildata = [];
    var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
    extractdata.forEach((keys, value) {
      var spefics = value as Map<String, dynamic>;
      spefics.forEach((key, value) {
        detaildata.add(Detail(
            id: keys,
            book: value['Book'],
            price: value['Price'],
            author: value['Author'],
            favclick: value['favdata'],
            imagelink: value['imagelink'],
            pdfurl: value['pdfUrl']));
      });
    });
    _iteam = detaildata;
    return extractdata;
  } else {
    throw Exception('Failed to load data');
  }
}
//! AI tool for to pharapharase the text Note:- (Only 10 request per Month)----------

