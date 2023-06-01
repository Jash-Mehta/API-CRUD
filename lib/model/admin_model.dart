class Detail {
  var id;
  String book;
  String price;
  String author;
  bool favclick;
  String imagelink;
  String pdfurl;
  Detail({
    required this.id,
    required this.book,
    required this.price,
    required this.author,
    required this.favclick,
    required this.imagelink,
    required this.pdfurl,
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
  String totalQuty;
  Cartlist({
    required this.id,
    required this.book,
    required this.price,
    required this.cartamount,
    required this.imageurl,
    required this.totalQuty,
  });
}

class YourBook {
  var id;
  String book;
  String price;
  String imageurl;
  YourBook({
    required this.id,
    required this.book,
    required this.price,
    required this.imageurl,
  });
}

class Authentication {
  String refreshtoken;
  Authentication({
    required this.refreshtoken,
  });
}

class DictWord {
  String meaning;
  String partofspeech;
  String example;
  DictWord({
    required this.meaning,
    required this.partofspeech,
    required this.example,
  });
}

class ContinueReading {
  var id;
  String book;
  String price;
  String author;
  bool favclick;
  String imagelink;
  String pdfurl;
  var pageno;
  ContinueReading({
    required this.id,
    required this.book,
    required this.price,
    required this.author,
    required this.favclick,
    required this.imagelink,
    required this.pdfurl,
    required this.pageno,
  });
}
