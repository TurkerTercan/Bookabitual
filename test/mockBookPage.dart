import 'package:bookabitual/screens/book/bookpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'mockFeedPage.dart';


class MockBookPage extends BookPage {
  @override
  BookPageState createState() => MockBookPageState();
}

class MockBookPageState extends BookPageState {
  @override
  getAllBookPost() async {}
}