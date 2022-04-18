import 'dart:convert';
import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/fav_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  @override
  void initState() {
    getdata();
    setState(() {});
    super.initState();
  }

  bool isFavorite = false;
  Color _iconColor = Colors.grey;
  List<Detail> _iteam = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display API Data"),
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
                            setState(() {
                              _iteam[index].favclick = !_iteam[index].favclick;
                            });
                            favdata(article.id, article.book, article.price);
                          },
                          icon: _iteam[index].favclick
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_outline)),
                      IconButton(
                          onPressed: () {
                            deletedata(article.id);
                            print("object is deleted ${article.id}");
                            setState(() {});
                          },
                          icon: Icon(Icons.delete_outline)),
                      IconButton(
                          onPressed: () {
                            cartdata(article.id, article.book, article.price);
                            setState(() {});
                          },
                          icon: Icon(CupertinoIcons.cart)),
                    ],
                  )
                ]));
          }),
    );
  }

// ! #-----------------Fetching Data from API RealTime database--------------#
  Future getdata() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail.json'));
    if (response.statusCode == 200) {
      List<Detail> detaildata = [];
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
      print(extractdata);
      extractdata.forEach((key, value) {
        detaildata.add(Detail(
            id: key,
            book: value['Book'],
            price: value['Price'],
            author: value['Author'],
            favclick: value['favdata']));
      });
      _iteam = detaildata;
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

//!  #-----------------Deleting Data from API RealTime database--------------#
  Future deletedata(String id) async {
    var client = http.Client();
    final existingproject = _iteam.indexWhere((element) => element.id == id);
    Detail? productdetail = _iteam[existingproject];
    _iteam.remove(productdetail);
    var response = client
        .delete(Uri.parse(
            'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail/$id.json'))
        .then((value) {
      if (value.statusCode >= 400) {
        throw Exception();
      }
      productdetail = null;
    }).catchError((_) {});
  }

// !#------------- Favorites Data from API RealTime Database(Posting data)------------------#
  Future favdata(String id, String favname, String price) async {
    var client = http.Client();
    final favdetail = _iteam.indexWhere((element) => element.id == id);
    var response = client
        .post(
            Uri.parse(
                'https://instagram-ee2d1-default-rtdb.firebaseio.com/favorites.json'),
            body: jsonEncode({'favid': id, 'Book': favname, 'price': price}))
        .whenComplete(() => print("favorites data was added successfully"));
  }

//! #-----------------------Sending Data to Cart Database(API)---------------------#
  Future cartdata(String id, String cartbook, String cartprice) async {
    var client = http.Client();
    final favdetail = _iteam.indexWhere((element) => element.id == id);
    var response = await client
        .post(
            Uri.parse(
                'https://instagram-ee2d1-default-rtdb.firebaseio.com/Cart.json'),
            body: jsonEncode(
                {'cartid': id, 'cartbook': cartbook, 'cartprice': cartprice}))
        .whenComplete(() => print("favorites data was added successfully"));
  }
}
