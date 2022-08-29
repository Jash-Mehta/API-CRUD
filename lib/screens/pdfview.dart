import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
  int totalpages = 0;
  int currentpages = 0;
  int roundoffpages = 0;
  bool isready = false;
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
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ));
          }),
          elevation: 0,
        ),
        body: Stack(
          children: [
            PDFView(
                fitPolicy: FitPolicy.HEIGHT,
                filePath: widget.pdfurl,
                swipeHorizontal: true,
                onPageChanged: ((page, total) {
                  setState(() {
                    currentpages = page!;
                    roundoffpages = total!;
                  });
                }),
                nightMode: true,
                onError: (error) {
                  print('Error');
                },
                onRender: (pages) {
                  setState(() {
                    totalpages = pages!;
                    isready = true;
                  });
                }),
            !isready
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Please try again")
                    ],
                  )
                : Offstage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 25.0,
                    width: 60.0,
                    decoration: BoxDecoration(color: Colors.grey[600]),
                    child: Center(
                      child: Text(
                        '${currentpages + 1}/${roundoffpages.toString()}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
