import 'package:cloud_firestore/cloud_firestore.dart';

class Bookworm{
  String uid;
  String username;
  String name;
  String email;
  int photoIndex;
  Timestamp accountCreated;

  Bookworm({this.uid, this.username, this.name, this.email, this.photoIndex, this.accountCreated});

  factory Bookworm.fromDocument(DocumentSnapshot doc){
    return Bookworm(
      uid: doc['uid'],
      username: doc['username'],
      name: doc['name'],
      email: doc['email'],
      photoIndex: doc['photoIndex'],
      accountCreated: doc['accountCreated'],
    );
  }
}