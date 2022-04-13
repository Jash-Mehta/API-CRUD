class Teacher_semi {
  String teacherID;
  String name;
  String classAlloted;
  String subject;

  Teacher_semi(this.teacherID, this.name, this.classAlloted, this.subject);

  factory Teacher_semi.fromJson(Map<String, dynamic> json) {
    return Teacher_semi(json["teacherID"], json["fName"], json["classAlloted"],
        json["subject"]);
  }
}

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
