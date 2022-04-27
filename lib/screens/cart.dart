import 'dart:convert';
import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Carts extends StatefulWidget {
  const Carts({Key? key}) : super(key: key);
  @override
  State<Carts> createState() => _CartsState();
}

class _CartsState extends State<Carts> with TickerProviderStateMixin {
  List<Cartlist> _cartlist = [];
  int? qutyamount;
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
            "BuyNow",
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
          future: getcartdata(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      final article = _cartlist[index];
                      var a = int.parse(article.price);

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
                            margin: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    width: 1.0, color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 120.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(article.imageurl),
                                          fit: BoxFit.fitWidth)),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          fontSize: 18.0, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                      width: 105.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _cartlist[index].cartamount++;
                                                  qutyamount = _cartlist[index]
                                                      .cartamount;
                                                  cartamount(
                                                      article.id, qutyamount!);
                                                });
                                              },
                                              child: const Icon(Icons.add)),
                                          Text(
                                            _cartlist[index]
                                                .cartamount
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _cartlist[index].cartamount !=
                                                          0
                                                      ? _cartlist[index]
                                                          .cartamount--
                                                      : _cartlist[index]
                                                          .cartamount;
                                                  qutyamount = _cartlist[index]
                                                      .cartamount;
                                                  cartamount(
                                                      article.id, qutyamount!);
                                                });
                                              },
                                              child: const Icon(Icons.remove)),
                                        ],
                                      ),
                                    ),
                                    //!#--------------------BuyNow Icon(Orderscreen)-------------------#
                                    Text(
                                      "SubTotal: ₹${a * article.cartamount}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      );
                    },
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 58.0,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: ListTile(
                          title: const Text(
                            "ORDER NOW",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_right_alt_rounded,
                                color: Colors.white,
                                size: 28.0,
                              )),
                        )))
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
                            image: AssetImage('assets/cart.png'),
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
          },
        ));
  }

// ! #-----------------Fetching Data from API RealTime database(CART)--------------#
  Future getcartdata() async {
    var client = Client();
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/Cart.json'));
    if (response.statusCode == 200) {
      List<Cartlist> cartlist = [];
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
      extractdata.forEach((key, value) {
        cartlist.add(Cartlist(
            id: key,
            book: value['cartbook'],
            price: value['cartprice'],
            cartamount: value['NetQuty'],
            imageurl: value['imageUrl']));
      });
      _cartlist = cartlist;
      return extractdata;
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
            'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/Cart/$id.json'))
        .then((value) {
      if (value.statusCode >= 400) {
        throw Exception();
      }
      productdetail = null;
    }).catchError((_) {});
  }

//! #---------------------------Update the data to the API[PATCH] in cart Data--------------#
  Future cartamount(String id, int quty) async {
    var client = http.Client();
    var response = await client.patch(
        Uri.parse(
          'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/Cart/$id.json',
        ),
        body: jsonEncode({'NetQuty': quty}));
  }
}
