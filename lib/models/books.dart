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

  Booksdetail({this.charId, this.name, this.author, this.publisher, this.img});

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
