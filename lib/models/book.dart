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

  Book({this.bookAuthor, this.bookTitle, this.imageUrlL, this.imageUrlM, this.imageUrlS,
  this.publisher, this.ratings, this.yearOfPublication, this.isbn});

  factory Book.fromDocument(DocumentSnapshot doc){
    return Book(
      bookAuthor: doc['Book-Author'],
      bookTitle: doc['Book-Title'],
      imageUrlL: doc['Image-URL-L'],
      imageUrlM: doc['Image-URL-M'],
      imageUrlS: doc['Image-URL-S'],
      publisher: doc['Publisher'],
      ratings: doc['Ratings'],
      yearOfPublication: doc['Year-Of-Publication']
    );
  }
}