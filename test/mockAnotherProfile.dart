import 'package:bookabitual/screens/anotherProfile/anotherProfile.dart';

class MockAnotherProfile extends AnotherProfilePage {
  @override
  AnotherProfilePageState createState() => MockAnotherProfileState();
}

class MockAnotherProfileState extends AnotherProfilePageState {
  @override
  getAllPosts(String uid) {}
}