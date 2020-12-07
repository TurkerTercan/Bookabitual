import 'package:cloud_firestore/cloud_firestore.dart';

class Bookworm{
  String name = 'User';
  String photo = 'assets/profilePhoto4.png';
  String uid;
  String email;
  String username;
  Timestamp accountCreated;

  Bookworm({this.uid, this.email, this.username, this.accountCreated});
}