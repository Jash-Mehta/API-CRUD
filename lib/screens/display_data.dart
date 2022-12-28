import 'dart:convert';
import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/TestingMongo.dart';
import 'package:apipratice/screens/login.dart';
import 'package:apipratice/screens/readbook.dart';
import 'package:apipratice/screens/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData>
    with TickerProviderStateMixin {
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

  bool? isFavorite;
  List<Detail> _iteam = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
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
                  "Top Author's:",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    height: 125.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _iteam.length,
                      itemBuilder: (BuildContext context, int index) {
                        var article = _iteam[index];
                        return Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 6.0),
                              child: CircleAvatar(
                                radius: 40.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 6.0),
                              child: Text(
                                article.author,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        );
                      },
                    )),
                const Text(
                  "Trending Books:",
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
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3),
                      itemCount: _iteam.length,
                      itemBuilder: (BuildContext ctx, index) {
                        var article = _iteam[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Readbook(
                                          author: article.author,
                                          bookname: article.book,
                                          price: article.price,
                                          imageurl: article.imagelink,
                                          pdfurl: article.pdfurl,
                                        )));
                          },
                          child: Container(
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
                                  border: Border.all(color: Colors.blue)),
                              child: Column(children: [
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  height: 75.0,
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(article.imagelink),
                                          fit: BoxFit.cover)),
                                ),
                                const Spacer(),
                                Text(
                                  article.book,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "₹ ${article.price}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                      ),
                                      Text('4.0')
                                    ]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _iteam[index].favclick =
                                                !_iteam[index].favclick;
                                            isFavorite = _iteam[index].favclick;
                                            updatedata(article.id);
                                          });
                                          favdata(article.id, article.book,
                                              article.price, article.imagelink);
                                        },
                                        icon: _iteam[index].favclick
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                Icons.favorite_outline)),
                                    IconButton(
                                        onPressed: () {
                                          
                                          cartdata(article.id, article.book,
                                              article.price, article.imagelink);
                                            
                                          setState(() {});
                                        },
                                        icon: const Icon(CupertinoIcons.cart)),
                                  ],
                                )
                              ])),
                        );
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
                            image: AssetImage('assets/bookshelves.png'),
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

// ! #-----------------Fetching Data from API RealTime database--------------#
  Future getdata() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(
        'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail.json'));
    if (response.statusCode == 200) {
      List<Detail> detaildata = [];
      var extractdata = jsonDecode(response.body) as Map<String, dynamic>;
      extractdata.forEach((keys, value) {
        var spefics = value as Map<String, dynamic>;
        spefics.forEach((key, value) {
          detaildata.add(Detail(
              id: keys,
              book: value['Book'],
              price: value['Price'],
              author: value['Author'],
              favclick: value['favdata'],
              imagelink: value['imagelink'],
              pdfurl: value['pdfUrl']));
        });
      });
      _iteam = detaildata;
      return extractdata;
    } else {
      throw Exception('Failed to load data');
    }
  }

// !#------------- Favorites Data from API RealTime Database(Posting data) Fav.------------------#
  Future favdata(
      String id, String favname, String price, String imageurl) async {
    var client = http.Client();
    final favdetail = _iteam.indexWhere((element) => element.id == id);
    var response = client
        .post(
            Uri.parse(
                'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/favorites.json'),
            body: jsonEncode({"useruid": id}))
        .whenComplete(() => print("favorites data was added successfully"));
  }

//! #-----------------------Sending Data to Cart Database(API)---------------------#
  Future cartdata(
      String id, String cartbook, String cartprice, String imageurl) async {
    var client = http.Client();
    final favdetail = _iteam.indexWhere((element) => element.id == id);
    var response = await client
        .post(
            Uri.parse(
                'https://instagram-ee2d1-default-rtdb.firebaseio.com/$localuid/Cart.json'),
            body: jsonEncode({
              'cartid': id,
              'cartbook': cartbook,
              'cartprice': cartprice,
              'imageUrl': imageurl,
              'NetQuty': 1,
              'TotalQuty': cartprice
            }))
        .whenComplete(() => print("Cart data was added successfully"));
  }

  //! #-----------------------Updating data to Detail(favdata)[PATCH]-------------#
  Future updatedata(String id) async {
    var client = http.Client();
    var response = await client.get(
      Uri.parse(
          'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail/$id.json'),
    );
    if (response.statusCode == 200) {
      var extract_data = jsonDecode(response.body) as Map<String, dynamic>;
      extract_data.forEach((key, value) async {
        var fav_response = await client.patch(
            Uri.parse(
                'https://instagram-ee2d1-default-rtdb.firebaseio.com/detail/$id/$key.json'),
            body: jsonEncode({
              'favdata': true,
            }));
      });
    }
  }
}
