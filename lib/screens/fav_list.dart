import 'dart:convert';

import 'package:apipratice/model/admin_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavList extends StatefulWidget {
  const FavList({Key? key}) : super(key: key);

  @override
  State<FavList> createState() => _FavListState();
}

bool isFavorite = false;
Color _iconColor = Colors.grey;

class _FavListState extends State<FavList> {
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    setState(() {});
    super.initState();
  }

  List<Favlist> _iteam = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites API Data"),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30),
          itemCount: _iteam.length,
          itemBuilder: (BuildContext ctx, index) {
            var article = _iteam[index];
            return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black)),
                child: Column(children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  const CircleAvatar(
                    radius: 35.0,
                    backgroundColor: Colors.grey,
                  ),
                  const Spacer(),
                  Text(
                    article.book,
                    style: const TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  Text(
                    "₹ ${article.price}",
                    style: const TextStyle(color: Colors.black, fontSize: 17.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }

  // ! #-----------------Fetching  Favorites Data from API RealTime database--------------#
  Future getdata() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/favorites.json'));
    if (response.statusCode == 200) {
      List<Favlist> detaildata = [];
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
      extractdata.forEach((key, value) {
        detaildata
            .add(Favlist(book: value['Book'], id: key, price: value['price'],favclick: 1));
      });
      _iteam = detaildata;
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  // !#------------- Deleting Favorites Data from API RealTime Database(Posting data)------------------#
  Future deletedata(String id) async {
    var client = http.Client();
    final existingproject = _iteam.indexWhere((element) => element.id == id);
    print(existingproject);
    Favlist? productdetail = _iteam[existingproject];
    _iteam.remove(productdetail);
    var response = client
        .delete(Uri.parse(
            'https://instagram-ee2d1-default-rtdb.firebaseio.com/favorites/$id.json'))
        .then((value) {
      if (value.statusCode >= 400) {
        throw Exception();
      }
      productdetail = null;
    }).catchError((_) {});
  }
}
