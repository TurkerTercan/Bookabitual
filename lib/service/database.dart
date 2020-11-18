import 'package:bookabitual/models/bookworm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> createUser(Bookworm user) async {
    String retVal = "Error";
    try{
      await _firestore.collection("users").doc(user.uid).set({
        'username' : user.username,
        'email' : user.email,
        'accountCreated' : Timestamp.now(),
      });
      retVal = "Success";
    }catch(e) {
      print(e);
    }
    return retVal;
  }

  Future<Bookworm> getUserInfo(String uid) async{
    Bookworm retVal = Bookworm();

    try{
      DocumentSnapshot _docSnapshot = await _firestore.collection("users").doc(uid).get();
      retVal.uid = uid;
      retVal.username = _docSnapshot.get("username");
      retVal.email = _docSnapshot.get("email");
      retVal.accountCreated = _docSnapshot.get("accountCreated");
    } catch(e) {
      print(e);
    }

    return retVal;
  }
}