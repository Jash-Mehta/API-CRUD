import 'dart:convert';

import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/TestingMongo.dart';
import 'package:apipratice/screens/login.dart';
import 'package:apipratice/screens/updatescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<YourBook> _iteam = [];

class Yourbook extends StatefulWidget {
  const Yourbook({Key? key}) : super(key: key);

  @override
  State<Yourbook> createState() => _YourbookState();
}

class _YourbookState extends State<Yourbook> with TickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Book's",
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
        body: FutureBuilder(
            future: getdata(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Column(children: [
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 350,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: _iteam.length,
                        itemBuilder: (BuildContext ctx, index) {
                          var article = _iteam[index];
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => UpdateBook(
                                              imageurl: article.imageurl,
                                              name: article.book,
                                              price: article.price,
                                              id: article.id,
                                            )));
                              },
                              child: Stack(children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    margin: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 4.0,
                                          ),
                                        ],
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Column(children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        height: 100.0,
                                        width: 85.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    article.imageurl),
                                                fit: BoxFit.fitWidth)),
                                      ),
                                      const Spacer(),
                                      Text(
                                        article.book,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "₹ ${article.price}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0),
                                      ),
                                      const Spacer()
                                    ])),
                                //! #---------------------------PopUp Menu code Start from here-----------------#
                                PopupMenuButton(
                                    padding: const EdgeInsets.all(0.0),
                                    shape: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 0.6)),
                                    itemBuilder: (contexts) => [
                                          PopupMenuItem(
                                              onTap: () {
                                                deletebook(article.id);
                                                deleteyourbook(article.id);
                                              },
                                              value: 0,
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              )),
                                        ]),
                              ]));
                        }),
                  ),
                ]);
              } else if (snapshot.hasError) {
                return const Center(child: Text("Network issue"));
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: Container(
                      height: 370.0,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/favshelves.png'),
                              fit: BoxFit.cover)),
                    )),
                    Center(
                      child: CircularProgressIndicator(
                          valueColor: animationController.drive(ColorTween(
                              begin: Colors.blueAccent, end: Colors.red))),
                    )
                  ],
                );
              }
            }));
  }

// ! #-----------------Fetching Yourbook Data from API RealTime database--------------#
  Future getdata() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/yourbook.json'));
    if (response.statusCode == 200) {
      List<YourBook> detaildata = [];
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
      extractdata.forEach((key, value) {
        var useruid = value as Map<String, dynamic>;
        useruid.forEach((keys, values) async {
          var detailresponse = await client.get(Uri.parse(
              'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail/$values.json'));
          var extract_detail_data =
              jsonDecode(detailresponse.body) as Map<String, dynamic>;
          extract_detail_data.forEach((key, value) {
            detaildata.add(YourBook(
                id: values,
                book: value['Book'],
                price: value['Price'],
                imageurl: value['imagelink']));
          });
          _iteam = detaildata;
        });
      });

      return extractdata;
    } else {
      throw Exception('Failed to load data');
    }
  }

//! #----------------------Book is deleted from the Detail table-----------------#
  Future deletebook(String id) async {
    var client = http.Client();

    var response = client
        .delete(Uri.parse(
            'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail/$id.json'))
        .then((value) {
      if (value.statusCode >= 400) {
        throw Exception();
      }
    });
  }

  //! #---------------Delete book from the yourbook table----------#
  Future deleteyourbook(String id) async {
    var client = http.Client();
    final favdetail = _iteam.indexWhere((element) => element.id == id);
    YourBook? yourbook = _iteam[favdetail];
    _iteam.remove(yourbook);
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/yourbook.json'));
    if (response.statusCode == 200) {
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
      extractdata.forEach((keys, value) {
        var useruid = value as Map<String, dynamic>;
        useruid.forEach((key, value) async {
          print('Here delete book');
          if (id == value) {
            var deleteid = keys;
            var deleteresponse = await client
                .delete(Uri.parse(
                    'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/yourbook/$deleteid.json'))
                .then((value) {
              if (value.statusCode >= 400) {
                throw Exception();
              }
              yourbook = null;
            });
          }
        });
      });
    }
  }
}
