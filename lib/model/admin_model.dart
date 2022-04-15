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
  Favlist({
    required this.book,
    required this.price,
    required this.id,
  });
}

class Cartlist {
  var id;
  String book;
  String price;
  Cartlist({
    required this.id,
    required this.book,
    required this.price,
  });
}
