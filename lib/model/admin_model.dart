class Detail {
  var id;
  String book;
  String price;
  String author;
  bool favclick;
  String imagelink;
  Detail({
    required this.id,
    required this.book,
    required this.price,
    required this.author,
    required this.favclick,
    required this.imagelink,
  });
}

class Favlist {
  String book;
  String price;
  var id;
  bool favclick;
  String imagelink;
  Favlist({
    required this.book,
    required this.price,
    required this.id,
    required this.favclick,
    required this.imagelink,
  });
}

class Cartlist {
  var id;
  String book;
  String price;
  int cartamount;
  String imageurl;
  Cartlist({
    required this.id,
    required this.book,
    required this.price,
    required this.cartamount,
    required this.imageurl,
  });
}
