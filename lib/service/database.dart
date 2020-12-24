import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/books.dart';

final userReference = FirebaseFirestore.instance.collection("users");
final postReference = FirebaseFirestore.instance.collection("Posts");
final activityFeedReference = FirebaseFirestore.instance.collection("feed");
final bookReference = FirebaseFirestore.instance.collection("books");

class BookDatabase {

  Future createQuote(QuotePost quote) async {
    await postReference.doc(quote.ownerId).collection("usersQuotes").doc(quote.quoteId).set({
      "quoteId" : quote.quoteId,
      "ownerId" : quote.ownerId,
      "userAvatarIndex" : quote.userAvatarIndex,
      "username" : quote.username,
      "createTime" : quote.createTime,
      "status" : quote.status,
      "imageUrl" : quote.imageUrl,
      "likes" : quote.likes,
      "quote" : quote.quote,
      "author" : quote.author,
      "bookName" : quote.bookName,
      "date" : quote.date,
    });
  }

  Future createReview(ReviewPost review) async {
    await postReference.doc(review.ownerId).collection("usersReviews").doc(review.reviewId).set({
      "reviewId" : review.reviewId,
      "ownerId" : review.ownerId,
      "userAvatarIndex" : review.userAvatarIndex,
      "username" : review.username,
      "createTime" : review.createTime,
      "status" : review.status,
      "imageUrl" : review.imageUrl,
      "likes" : review.likes,
      "review" : review.review,
      "author" : review.author,
      "bookName" : review.bookName,
      "rating" : review.rating,
      "date" : review.date,
    });
  }

  Future<String> createUser(Bookworm user) async {
    String retVal = "Error";
    try{
      await userReference.doc(user.uid).set({
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
/*
Book-Author
"Libby Purves"
(dize)
Book-Title
"How Not to Be a Perfect Mother: The Crafty Mother's Guide to a Quiet Life (How Not to)"
Image-URL-L
"http://images.amazon.com/images/P/000636988X.01.LZZZZZZZ.jpg"
Image-URL-M
"http://images.amazon.com/images/P/000636988X.01.MZZZZZZZ.jpg"
Image-URL-S
"http://images.amazon.com/images/P/000636988X.01.THUMBZZZ.jpg"
Publisher
"HarperCollins Publishers"
Ratings
"3,65"
Year-Of-Publication
1986
 */

  Future<QuerySnapshot> getUserQuotes(String uid) async{
    QuerySnapshot queryQuoteSnapshot = await postReference.doc(uid).collection("usersQuotes").orderBy("createTime", descending: true).get();
    return queryQuoteSnapshot;
  }

  Future<QuerySnapshot> getUserReviews(String uid) async{
    QuerySnapshot queryReviewSnapshot = await postReference.doc(uid).collection("usersReviews").orderBy("createTime", descending: true).get();
    return queryReviewSnapshot;
  }

  Future<Bookworm> getUserInfo(String uid) async{
    Bookworm retVal = Bookworm();

    try{
      DocumentSnapshot _docSnapshot = await userReference.doc(uid).get();
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

  Future<Booksdetail> getBookInfo(String uid) async{
    Booksdetail retValBook = Booksdetail();

    try{
      DocumentSnapshot _docSnapshot = await bookReference.doc(uid).get();
      retValBook.charId = _docSnapshot.get("charId");
      retValBook.name = _docSnapshot.get("name");
      retValBook.author = _docSnapshot.get("author");
      retValBook.publisher = _docSnapshot.get("publisher");
      retValBook.img = _docSnapshot.get("img");
      retValBook.color = _docSnapshot.get("color");
    } catch(e) {
      print(e);
    }
    return retValBook;
  }

  Future<void> setUserInfo(String uid ,int index, String name) async {
    print(uid);
    print(index);
    print(name);
    try{
      await userReference.doc(uid).update({
        'photoIndex': index,
        'name': name,
      });
    }catch(e){
      print(e);
    }
  }
}
