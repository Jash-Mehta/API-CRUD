import 'dart:convert';
import 'package:apipratice/model/admin_model.dart';
import 'package:apipratice/screens/login.dart';
import 'package:apipratice/screens/pdfview.dart';
import 'package:apipratice/screens/readbook.dart';
import 'package:apipratice/widget/constant.dart';
import 'package:apipratice/widget/double_side_round.dart';
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
    var size = MediaQuery.of(context).size;
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/main_page_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: FutureBuilder(
            future: getdata(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText2,
                            children: const [
                              TextSpan(
                                  text: "What are you \nreading ",
                                  style: TextStyle(fontSize: 30.0)),
                              TextSpan(
                                  text: "today?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _iteam.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var article = _iteam[index];
                            return Container(
                              height: 245,
                              width: 202,
                              child: Stack(children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 30.0, left: 20.0, right: 15.0),
                                  height: 230,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(29.0),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 33,
                                        color:
                                            Color(0xFFD3D3D3).withOpacity(.84),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 5.0),
                                  child: Image.network(
                                    article.imagelink,
                                    width: 125.0,
                                    height: 170.0,
                                  ),
                                ),
                                Positioned(
                                    top: 35,
                                    right: 10,
                                    child: Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _iteam[index].favclick =
                                                    !_iteam[index].favclick;
                                                isFavorite =
                                                    _iteam[index].favclick;
                                                updatedata(article.id);
                                              });
                                              favdata(
                                                  article.id,
                                                  article.book,
                                                  article.price,
                                                  article.imagelink);
                                            },
                                            icon: _iteam[index].favclick
                                                ? const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  )
                                                : const Icon(
                                                    Icons.favorite_outline)),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(3, 7),
                                                blurRadius: 20,
                                                color: Color(0xFFD3D3D3)
                                                    .withOpacity(.5),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow[600],
                                                size: 25.0,
                                              ),
                                              const Text(
                                                "4.5",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              cartdata(
                                                  article.id,
                                                  article.book,
                                                  article.price,
                                                  article.imagelink);

                                              setState(() {});
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.cart)),
                                      ],
                                    )),
                                Positioned(
                                    top: 180.0,
                                    left: 25.0,
                                    child: SizedBox(
                                      height: 80,
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              text: TextSpan(
                                                  style: const TextStyle(
                                                      color: kBlackColor),
                                                  children: [
                                                TextSpan(
                                                    text: "${article.book}\n",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0)),
                                                TextSpan(
                                                    style: const TextStyle(
                                                        color:
                                                            kLightBlackColor),
                                                    text: article.author)
                                              ])),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                Readbook(
                                                                  author: article
                                                                      .author,
                                                                  bookname:
                                                                      article
                                                                          .book,
                                                                  price: article
                                                                      .price,
                                                                  imageurl: article
                                                                      .imagelink,
                                                                  pdfurl: article
                                                                      .pdfurl,
                                                                )));
                                                  },
                                                  child: Text("Detail")),
                                              GestureDetector(
                                                onTap: () {
                                                  PDFreader(
                                                      pdfurl: article.pdfurl,
                                                      booktitle: article.book);
                                                },
                                                child: TwoSideRoundedButton(
                                                  text: "Read",
                                                  radious: 29,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                              ]),
                            );
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    children: const [
                                      TextSpan(
                                          text: "Best of the ",
                                          style: TextStyle(fontSize: 30.0)),
                                      TextSpan(
                                        text: "day",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ])),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Stack(children: [
                            Positioned(
                              child: Container(
                                height: 185,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEAEAEA).withOpacity(.45),
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: Stack(children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                            left: 15.0),
                                        child: const Text(
                                          "New York Time Best For 11th March 2020",
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: kLightBlackColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Normal People \n & Sally People",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Gary Venchuk",
                                          style: TextStyle(
                                              color: kLightBlackColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10.0),
                                        child: Row(
                                          children: const [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 2,
                                    child: Image.network(
                                      "https://www.realsimple.com/thmb/-peF-thNTibpA5iArNXU693CTn8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/great-books-to-read-normal-people-crop-0649ede28a2144808e96aed6a1600aed.jpg",
                                      width: size.width * .335,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: SizedBox(
                                      height: 40,
                                      width: size.width * .3,
                                      child: TwoSideRoundedButton(
                                        text: "Read",
                                        radious: 24,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            )
                          ]))
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
          ),
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
