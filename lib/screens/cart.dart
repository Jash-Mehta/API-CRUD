import 'dart:convert';
import 'package:apipratice/model/admin_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Carts extends StatefulWidget {
  const Carts({Key? key}) : super(key: key);
  @override
  State<Carts> createState() => _CartsState();
}

class _CartsState extends State<Carts> {
  List<Cartlist> _cartlist = [];
  int cartamount = 0;

  @override
  void initState() {
    getcartdata();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: ListView.builder(
        itemCount: _cartlist.length,
        itemBuilder: (BuildContext context, int index) {
          final article = _cartlist[index];
          return Dismissible(
            background: const Icon(
              Icons.delete,
              color: Colors.black,
              size: 30,
            ),
            key: UniqueKey(),
            onDismissed: (direction) {
              deletedata(article.id);
              setState(() {});
            },
            child: Container(
                height: 130.0,
                margin:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: Colors.black)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 120.0,
                      width: 100.0,
                      color: Colors.grey,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          article.book,
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "₹ ${article.price}",
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                          width: 105.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      cartamount++;
                                    });
                                  },
                                  child: Icon(Icons.add_circle)),
                              Text(cartamount.toString()),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      cartamount--;
                                    });
                                  },
                                  child: Icon(Icons.remove_circle)),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

// ! #-----------------Fetching Data from API RealTime database(CART)--------------#
  Future getcartdata() async {
    var client = Client();
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/Cart.json'));
    if (response.statusCode == 200) {
      List<Cartlist> cartlist = [];
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
      extractdata.forEach((key, value) {
        cartlist.add(Cartlist(
            id: key, book: value['cartbook'], price: value['cartprice']));
      });
      _cartlist = cartlist;
      setState(() {});
    }
  }

  //! #-----------------Deleting Data from API RealTime Database(CART)--------------#
  Future deletedata(String id) async {
    var client = http.Client();
    final existingproject = _cartlist.indexWhere((element) => element.id == id);
    Cartlist? productdetail = _cartlist[existingproject];
    _cartlist.remove(productdetail);
    var response = client
        .delete(Uri.parse(
            'https://instagram-ee2d1-default-rtdb.firebaseio.com/Cart/$id.json'))
        .then((value) {
      if (value.statusCode >= 400) {
        throw Exception();
      }
      productdetail = null;
    }).catchError((_) {});
  }
}
