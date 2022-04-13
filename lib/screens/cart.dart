import 'dart:convert';
import 'package:apipratice/model/admin_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Carts extends StatefulWidget {
  const Carts({Key? key}) : super(key: key);
  @override
  State<Carts> createState() => _CartsState();
}

class _CartsState extends State<Carts> {
  List<Cartlist> _cartlist = [];
  @override
  void initState() {
    // TODO: implement initState
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
          var article = _cartlist[index];
          return Container(
              height: 130.0,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
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
                          children: const [
                            Icon(Icons.add_circle),
                            Text("1"),
                            Icon(Icons.remove_circle)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ));
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
}
