import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userReference = FirebaseFirestore.instance.collection("users");
final postReference = FirebaseFirestore.instance.collection("Posts");
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
    var temp = await bookReference.doc(quote.isbn).get();
    var retVal = temp.data();

    if(retVal["posts"] == null) {
      await bookReference.doc(quote.isbn).update({"posts": {
        quote.uid : {
          quote.postID: "userQuotes"
        }
      }});
    } else {
      var postMap = retVal["posts"];
      if(postMap[quote.uid] == null) {
        postMap[quote.uid] = new Map<String, String>();
        postMap[quote.uid][quote.postID] = "userQuotes";
      } else {
        postMap[quote.uid][quote.postID] = "userQuotes";
      }
      await bookReference.doc(quote.isbn).update({"posts": postMap});
    }
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

    var temp = await bookReference.doc(review.isbn).get();
    var retVal = temp.data();

    if(retVal["posts"] == null) {
      await bookReference.doc(review.isbn).update({"posts": {
        review.uid : {
          review.postID: "userReviews"
        }
      }});
    } else {
      var postMap = retVal["posts"];
      if(postMap[review.uid] == null) {
        postMap[review.uid] = new Map<String, String>();
        postMap[review.uid][review.postID] = "userReviews";
      } else {
        postMap[review.uid][review.postID] = "userReviews";
      }
      await bookReference.doc(review.isbn).update({"posts": postMap});
    }
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
        'following': user.following,
        'followers': user.followers,
        'library': user.library,
        'currentBookName': user.currentBookName,
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
      retVal.currentBookName = _docSnapshot.get("currentBookName");
      retVal.library = _docSnapshot.get("library");
      retVal.followers = _docSnapshot.get("followers");
      retVal.following = _docSnapshot.get("following");
      if (retVal.currentBookName != "" && retVal.currentBookName != null)
        retVal.currentBook = await getBookInfo(retVal.currentBookName);

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

  Future<void> addBookToMyLibrary(String isbn, int index) async {
    Bookworm tempBookworm = currentBookworm;
    try{
      switch (index) {
        case 1: //Finished
          tempBookworm.library[isbn] = "Finished";
          await userReference.doc(tempBookworm.uid).update({
            'library': tempBookworm.library
          });
          break;
        case 2: //Reading
          tempBookworm.library[isbn] = "Reading";
          tempBookworm.currentBookName = isbn;
          await userReference.doc(tempBookworm.uid).update({
            'library': tempBookworm.library,
            'currentBookName': isbn,
          });
          break;
        case 3: //Unfinished
          tempBookworm.library[isbn] = "Unfinished";
          await userReference.doc(tempBookworm.uid).update({
            'library': tempBookworm.library
          });
          break;
        case 4: //Will Read
          tempBookworm.library[isbn] = "Will Read";
          await userReference.doc(tempBookworm.uid).update({
            'library': tempBookworm.library
          });
          break;
      }
      currentBookworm = tempBookworm;
    }
    catch(e) {
      print(e);
    }
  }
  Future<void> followFunction(String otherUid, bool index) async {
    Bookworm temp = currentBookworm;
    Bookworm otherUser = await getUserInfo(otherUid);

    try {
      if (!index) {
        temp.following[otherUid] = true;
        otherUser.followers[temp.uid] = true;
      } else {
        temp.following.remove(otherUid);
        otherUser.followers.remove(temp.uid);
      }
      await userReference.doc(temp.uid).update({
        'following': temp.following
      });
      await userReference.doc(otherUser.uid).update({
        'followers': otherUser.followers
      });
      currentBookworm = temp;
    } catch(e) {
      print(e);
    }
  }
}
