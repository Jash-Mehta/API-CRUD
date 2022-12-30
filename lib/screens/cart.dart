import 'dart:convert';
import 'dart:io';
import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/login.dart';
import 'package:apipratice/screens/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class Carts extends StatefulWidget {
  const Carts({Key? key}) : super(key: key);
  @override
  State<Carts> createState() => _CartsState();
}

class _CartsState extends State<Carts> with TickerProviderStateMixin {
  final _razorpay = Razorpay();
  List<Cartlist> _cartlist = [];
  List<dynamic> data = [];
  int? qutyamount;
  int? subtotal;
  late AnimationController animationController;
  @override
  void dispose() {
    animationController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    super.initState();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

// ! #----------------------Handling every success and error response-------------------#
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeed
    verifySignature(
      signature: response.signature,
      paymentId: response.paymentId,
      orderId: response.orderId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handleExternalWallet(ExternalWalletResponse response) {}

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
                                      "₹ ${article.totalQuty}",
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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
                                                      article.id,
                                                      qutyamount!,
                                                      article.price);
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
                                          //! #----------------neg.& posti. button is here----------------#
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
                                                      article.id,
                                                      qutyamount!,
                                                      article.price);
                                                });
                                              },
                                              child: _cartlist[index]
                                                          .cartamount ==
                                                      0
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        deletedata(article.id);
                                                        setState(() {});
                                                      },
                                                      child: Icon(Icons.delete))
                                                  : Icon(Icons.remove)),
                                        ],
                                      ),
                                    ),
                                    //!#--------------------BuyNow Icon(Orderscreen)-------------------#
                                    ElevatedButton(
                                        onPressed: () {
                                          createOrder(
                                              article.book,
                                              int.parse(article.totalQuty),
                                              article.imageurl);
                                        },
                                        child: Text("BuyNow"))
                                  ],
                                ),
                              ],
                            )),
                      );
                    },
                  ),
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
          imageurl: value['imageUrl'],
          totalQuty: value['TotalQuty'],
        ));
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
  Future cartamount(String id, int quty, String cartprice) async {
    var client = http.Client();
    var response = await client.patch(
        Uri.parse(
          'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/Cart/$id.json',
        ),
        body: jsonEncode(
            {'NetQuty': quty, 'TotalQuty': '${quty * int.parse(cartprice)}'}));
  }

//! #------------------------CreateOrder and main function------------------------#
  void createOrder(String book, int amount, String image) async {
    String username = 'rzp_test_Fwj1OKArcSD8o4';
    String password = '0kzHRaMm3JhXU8A4BHtEIliM';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> body = {
      "amount": amount * 100,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    var res = await http.post(Uri.https('api.razorpay.com', 'v1/orders'),
        headers: <String, String>{
          "Content-Type": 'application/json',
          "authorization": basicAuth
        },
        body: jsonEncode(body));
    if (res.statusCode == 200) {
      openGateway(jsonDecode(res.body)['id'], amount, book, image);
    }
  }

// ! #------------------Opening the gateway interface------------------------#
  openGateway(String orderId, int amount, String book, String image) {
    var options = {
      'key': 'rzp_test_Fwj1OKArcSD8o4',
      'amount': amount * 100, //in the smallest currency sub-unit.
      'name': "E-BookStore",
      'order_id': orderId, // Generate order_id using Orders API
      'description': book,
      'image': image,
      'timeout': 60, // in seconds
      'prefill': {'contact': '7096747394', 'email': 'jashmehta94@gmail.com'}
    };
    _razorpay.open(options);
  }

// ! #---------------------------Verifying the payment Data---------------------#
  verifySignature({
    String? signature,
    String? paymentId,
    String? orderId,
  }) async {
    Map<String, dynamic> body = {
      'razorpay_signature': signature,
      'razorpay_payment_id': paymentId,
      'razorpay_order_id': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https(
        "10.0.2.2", // my ip address , localhost
        "razorpay_signature_verify.php",
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    print(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
