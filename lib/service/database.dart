import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _firestorePost = FirebaseFirestore.instance.collection("Posts");

  Future createQuote(QuotePost quote) async {
    await _firestorePost.doc(quote.ownerId).collection("usersQuotes").doc(quote.quoteId).set({
      "quoteId" : quote.quoteId,
      "ownerId" : quote.ownerId,
      "userAvatarIndex" : quote.userAvatarIndex,
      "username" : quote.username,
      "createTime" : quote.createTime,
      "status" : quote.status,
      "imageUrl" : quote.imageUrl,
      "likeCount" : quote.likeCount,
      "quote" : quote.quote,
      "author" : quote.author,
      "bookName" : quote.bookName,
      "date" : quote.date,
    });
  }

  Future createReview(ReviewPost review) async {
    await _firestorePost.doc(review.ownerId).collection("usersReviews").doc(review.reviewId).set({
      "quoteId" : review.reviewId,
      "ownerId" : review.ownerId,
      "userAvatarIndex" : review.userAvatarIndex,
      "username" : review.username,
      "createTime" : review.createTime,
      "status" : review.status,
      "imageUrl" : review.imageUrl,
      "likeCount" : review.likeCount,
      "quote" : review.review,
      "author" : review.author,
      "bookName" : review.bookName,
      "rating" : review.rating,
      "date" : review.date,
    });
  }

  Future<String> createUser(Bookworm user) async {
    String retVal = "Error";
    try{
      await _firestore.collection("users").doc(user.uid).set({
        'username' : user.username,
        'email' : user.email,
        'accountCreated' : Timestamp.now(),
        'photoIndex': user.photoIndex,
        'name': user.name,
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
      retVal.name = _docSnapshot.get("name");
      retVal.photoIndex = _docSnapshot.get("photoIndex");
    } catch(e) {
      print(e);
    }

    return retVal;
  }

  Future<void> setUserInfo(String uid ,int index, String name) async {
    print(index);
    print(name);
    try{
      await _firestore.collection("users").doc(uid).update({
        'photoIndex': index,
        'name': name,
      });
    }catch(e){
      print(e);
    }
  }
}
