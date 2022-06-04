import 'dart:convert';

import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/login.dart';
import 'package:apipratice/screens/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class FavList extends StatefulWidget {
  const FavList({Key? key}) : super(key: key);

  @override
  State<FavList> createState() => _FavListState();
}

bool isFavorite = false;

class _FavListState extends State<FavList> with TickerProviderStateMixin {
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

  List<Favlist> _iteam = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Favorites Books",
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
                onPressed: () {},
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
                  const Text(
                    "Your Favorites:",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
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
                          return Container(
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
                                  border: Border.all(color: Colors.black)),
                              child: Column(children: [
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  height: 80.0,
                                  width: 85.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(article.imagelink),
                                          fit: BoxFit.fitWidth)),
                                ),
                                const Spacer(),
                                Text(
                                  article.book,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
                                Text(
                                  "₹ ${article.price}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 17.0),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          deletedata(article.id);

                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {});
                                        },
                                        icon: const Icon(CupertinoIcons.cart)),
                                  ],
                                )
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

  // ! #-----------------Fetching  Favorites Data from API RealTime database--------------#
  Future getdata() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/favorites.json'));

    if (response.statusCode == 200) {
      List<Favlist> detaildata = [];
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;

      extractdata.forEach((key, value) {
        detaildata.add(Favlist(
            book: value['Book'],
            id: key,
            imagelink: value['imageUrl'],
            price: value['price'],
            favclick: false));
      });
      _iteam = detaildata;
      return extractdata;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // !#------------- Deleting Favorites Data from API RealTime Database(Posting data)------------------#
  Future deletedata(String id) async {
    var client = http.Client();
    final existingproject = _iteam.indexWhere((element) => element.id == id);
    Favlist? productdetail = _iteam[existingproject];
    _iteam.remove(productdetail);
    var response = client
        .delete(Uri.parse(
            'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/favorites/$id.json'))
        .then((value) {
      if (value.statusCode >= 400) {
        throw Exception();
      }
      productdetail = null;
    }).catchError((_) {});
  }
}
