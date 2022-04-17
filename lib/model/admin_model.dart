class Detail {
  var id;
  String book;
  String price;
  String author;
  Detail({
    required this.id,
    required this.book,
    required this.price,
    required this.author,
  });
}

class Favlist {
  String book;
  String price;
  var id;
  int favclick;
  Favlist({
    required this.book,
    required this.price,
    required this.id,
    required this.favclick,
  });
}

class Cartlist {
  var id;
  String book;
  String price;
  int cartamount;
  Cartlist({
    required this.id,
    required this.book,
    required this.price,
    required this.cartamount,
  });
}
