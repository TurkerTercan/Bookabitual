import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userReference = FirebaseFirestore.instance.collection("users");
final postReference = FirebaseFirestore.instance.collection("Posts");
final activityFeedReference = FirebaseFirestore.instance.collection("feed");
final bookReference = FirebaseFirestore.instance.collection("books");

class BookDatabase {
  Future createQuote(QuotePost quote) async {
    //Dont delete it
    await postReference.doc(quote.uid).set({});

    await postReference.doc(quote.uid).collection("usersQuotes").doc(quote.postID).set({
      "isbn" : quote.isbn,
      "uid" : quote.uid,
      "postID" : quote.postID,
      "createTime" : quote.createTime,
      "status" : quote.status,
      "likes" : quote.likes,
      "text" : quote.text,
      "comments" : quote.comments,
    });
  }

  Future createReview(ReviewPost review) async {
    //Dont delete
    await postReference.doc(review.uid).set({});
    await postReference.doc(review.uid).collection("usersReviews").doc(review.postID).set({
      "isbn" : review.isbn,
      "uid" : review.uid,
      "postID" : review.postID,
      "createTime" : review.createTime,
      "status" : review.status,
      "likes" : review.likes,
      "rating" : review.rating,
      "text" : review.text,
      "comments" : review.comments,
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

  Future<Book> getBookInfo(String isbn) async{
    Book retValBook = Book();

    try{
      DocumentSnapshot _docSnapshot = await bookReference.doc(isbn).get();
      retValBook.bookAuthor = _docSnapshot.get("Book-Author");
      retValBook.bookTitle = _docSnapshot.get("Book-Title");
      retValBook.imageUrlL = _docSnapshot.get("Image-URL-L");
      retValBook.imageUrlM = _docSnapshot.get("Image-URL-M");
      retValBook.imageUrlS = _docSnapshot.get("Image-URL-S");
      retValBook.publisher = _docSnapshot.get("Publisher");
      retValBook.ratings = _docSnapshot.get("Ratings");
      retValBook.yearOfPublication = _docSnapshot.get("Year-Of-Publication");
      retValBook.isbn = isbn;
    } catch(e) {
      print(e);
    }
    return retValBook;
  }

  Future<void> setUserInfo(String uid ,int index, String name) async {
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
