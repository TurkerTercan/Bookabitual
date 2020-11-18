import 'package:cloud_firestore/cloud_firestore.dart';

class Bookworm{
  String uid;
  String email;
  String username;
  Timestamp accountCreated;

  Bookworm({this.uid, this.email, this.username, this.accountCreated});
}