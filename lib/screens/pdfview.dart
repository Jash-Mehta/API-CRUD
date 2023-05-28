import 'dart:convert';

import 'package:apipratice/model/admin_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

String? keyword;
List<DictWord> dictword = [];

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
  bool isselectready = false;

  late PDFViewController _pdfViewerController;
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
          actions: const [
            Icon(
              Icons.search,
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.bookmark,
                color: Colors.black,
              ),
            )
          ],
          elevation: 0,
        ),
        body: Stack(
          children: [
            SfPdfViewer.network(widget.pdfurl,
                interactionMode: PdfInteractionMode.selection,
                scrollDirection: PdfScrollDirection.horizontal,
                pageLayoutMode: PdfPageLayoutMode.single,
                enableTextSelection: true, onPageChanged: (details) {
              print(details.newPageNumber);
            }, onTextSelectionChanged: (details) {
              keyword = details.selectedText;

              isselectready = false;
              setState(() {
                isready = true;
                isselectready = true;
              });
            }),
          ],
        ),
        floatingActionButton: isready
            ? FloatingActionButton(
                child: const Icon(CupertinoIcons.doc_richtext),
                onPressed: () {
                  getdata();
                  isselectready
                      ? showDialog(
                          context: context,
                          builder: ((context) => AlertDialog(
                                title: Text("Meaning of ${keyword}"),
                                content: setupAlertDialoadContainer(),
                              ))).whenComplete(() => dictword.clear())
                      : SizedBox();
                })
            : Container());
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
    return jsonbody;
  } else {
    print("Data is not perfect");
  }
}
