import 'package:cloud_firestore/cloud_firestore.dart';

class Book{
  String bookAuthor;
  String bookTitle;
  String imageUrlL;
  String imageUrlM;
  String imageUrlS;
  String publisher;
  String ratings;
  String isbn;
  int yearOfPublication;
  Map posts;

  Book({this.bookAuthor, this.bookTitle, this.imageUrlL, this.imageUrlM, this.imageUrlS,
  this.publisher, this.ratings, this.yearOfPublication, this.isbn});

}