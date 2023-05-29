import 'dart:convert';

import 'package:apipratice/model/admin_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

String? keyword;
List<DictWord> dictword = [];
PdfViewerController _controller = PdfViewerController();

enum SampleItem { itemOne, itemTwo, itemThree }

class PDFreader extends StatefulWidget {
  String pdfurl;
  String booktitle;

  PDFreader({
    Key? key,
    required this.pdfurl,
    required this.booktitle,
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
    setState(() {});
  }

  int totalpages = 0;
  int currentpages = 0;
  int roundoffpages = 0;
  bool isready = false;
  var startpage, endpage;
  bool isselectready = false;
  bool readingmode = false;
  PdfViewerController _pdfViewerController = PdfViewerController();

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
            interactionMode: PdfInteractionMode.selection,
            scrollDirection: PdfScrollDirection.horizontal,
            pageLayoutMode: PdfPageLayoutMode.single,
            enableDoubleTapZooming: true,
            enableTextSelection: true,
            controller: _pdfViewerController, onPageChanged: (details) {
          readingmode ? _pdfViewerController.zoomLevel = 1.5 : 0;

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
            ? FloatingActionButton(
                child: const Icon(CupertinoIcons.doc_richtext),
                onPressed: () {
                  getdata();
                  print("here is your dict word" + dictword.toString());
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
                })
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
}

//! Fetching keyword of our book---------------------------------------
Future getdata() async {
  var client = http.Client();
  var response = await client.get(
      Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$keyword'));
  if (response.statusCode == 200) {
    var jsonbody = jsonDecode(response.body) as List<dynamic>;
    List<DictWord> words = [];
    for (var element in jsonbody) {
      words.add(DictWord(
          meaning: element['meanings'][0]['definitions'][0]['definition'],
          partofspeech: element['meanings'][0]['partOfSpeech'],
          example: "here is your example"));
      // print(element['meanings'][0]['definitions']);
    }
    dictword = words;

    return dictword;
  } else {
    print("Data is not perfect");
  }
}
