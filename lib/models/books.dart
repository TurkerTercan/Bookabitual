import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String url =
      "https://firebasestorage.googleapis.com/v0/b/bookabitual-55ad2.appspot.com/o/kitap.json?alt=media&token=ce8a12ac-6da7-4c47-a7b0-dd7b47be82a6";
  final response = await http.get(url);
  print(response.body);

  Booksdetail bookdetail = Booksdetail.fromJson(jsonDecode(response.body));
  print(bookdetail.name);
}

class Booksdetail {
  int charId;
  String name;
  String author;
  String publisher;
  String img;
  int color;

  Booksdetail(this.charId, this.name, this.author, this.publisher, this.img,this.color);

  Booksdetail.fromJson(Map<String, dynamic> json) {
    charId = json['char_id'];
    name = json['name'];
    author = json['author'];
    publisher = json['publisher'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['char_id'] = this.charId;
    data['name'] = this.name;
    data['author'] = this.author;
    data['publisher'] = this.publisher;
    data['img'] = this.img;
    return data;
  }
}

List<Booksdetail> book = booksdetail
    .map((item) => Booksdetail(item['charId'],item['name'],item['author'],item['publisher'], item['img'],item['color']))
    .toList();

var booksdetail = [
  {
    "name": "You’re A Miracle",
    "author": "Mike McHargue",
    "publisher": "Mike McHargue",
    "charId": 20,
    "img": "assets/profilePhoto15.png",
    "color": 0xFFFFD3B6,
  },
  {
    "name": "Pattern Maker",
    "author": "Kerry Johnston",
    "publisher": "Kerry Johnston",
    "charId": 40,
    "img": "assets/profilePhoto15.png",
    "color": 0xFF2B325C,
  },
  {
    "name": "Pa/percra/f",
    "author": "Mike Brown",
    "publisher": "Mike Brown",
    "charId": 60,
    "img": "assets/profilePhoto15.png",
    "color": 0xFF2B325C,
  }
];

