import 'package:bookabitual/keys.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:bookabitual/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Item{
  const Item(this.name, this.icon);
  final String name;
  final Widget icon;
}

List<Item> postChoice = <Item> [
  Item("Quote", Container(
      child: Icon(
        Icons.collections_bookmark,
        color: const Color(0xFF167F67),
        key: Key(Keys.QuoteChoice),
      )
  )),
  Item("Review",
      Icon(
        Icons.rate_review,
        color: const Color(0xFF167F67),
        key: Key(Keys.ReviewChoice),
      )),
];


class Rating{
  const Rating(this.score);
  final String score;
}

List<Rating> postRating = <Rating> [
  const Rating("1"),
  const Rating("2"),
  const Rating("3"),
  const Rating("4"),
  const Rating("5"),
];

void onButtonPressed(
    BuildContext context, List<Widget> postList,
    StateSetter viewState, ScrollController controller,
    Function function
    ) {

  final TextEditingController isbn = TextEditingController();
  final TextEditingController text = TextEditingController();
  final bookList = [];
  var selectedBook;

  Item selectedItem = postChoice[0];
  Rating selectedRating = postRating[0];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  void _validateInputs() {
    if (_formKey.currentState.validate())
      _autovalidateMode = AutovalidateMode.disabled;
    else
      _autovalidateMode = AutovalidateMode.always;
  }

  createPostFunction() async {
    if (_autovalidateMode != AutovalidateMode.always) {
      String postID = Uuid().v4();
      if (selectedItem == postChoice[1]) {
        ReviewPost temp = ReviewPost(
          isbn: selectedBook.isbn,
          uid: Provider
              .of<CurrentUser>(context, listen: false)
              .getCurrentUser
              .uid,
          postID: postID,
          text: text.text,
          rating: selectedRating.score,
          status: "Reading",
          likes: {
            Provider
                .of<CurrentUser>(context, listen: false)
                .getCurrentUser
                .uid : false
          },
          comments: {},
          createTime: Timestamp.now(),
          trigger: function,
        );
        await temp.updateInfo();
        await BookDatabase().createReview(temp);
        viewState(() {
          postList.insert(0, temp);
        });
      } else {
        QuotePost temp = QuotePost(
          isbn: selectedBook.isbn,
          uid: Provider
              .of<CurrentUser>(context, listen: false)
              .getCurrentUser
              .uid,
          postID: postID,
          text: text.text,
          status: "Reading",
          likes: {
            Provider
                .of<CurrentUser>(context, listen: false)
                .getCurrentUser
                .uid : false
          },
          createTime: Timestamp.now(),
          comments: {},
          trigger: function,
        );
        await BookDatabase().createQuote(temp);
        await temp.updateInfo();
        viewState(() {
          postList.insert(0, temp);
        });
      }
      Navigator.pop(context);
      controller.animateTo(0.0, curve: Curves.bounceOut,
        duration: const Duration(milliseconds: 1000),);
    }
  }


  showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      )
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ProjectContainer(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Category: ", style: TextStyle(color: Colors.black, fontSize: 18),),
                            DropdownButton<Item>(
                              key: Key(Keys.CategoryDropButton),
                              hint: Text("Choose a category"),
                              value: selectedItem,
                              items: postChoice.map((Item item) {
                                return DropdownMenuItem<Item>(
                                  child: Row(
                                    children: [
                                      item.icon,
                                      SizedBox(width: 40,),
                                      Text(item.name, style: TextStyle(color: Colors.black),),
                                    ],
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (Item value) {
                                setState(() {
                                  selectedItem = value;
                                });
                              },
                            ),
                          ],
                        )),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ProjectContainer(child:
                          TypeAheadField(
                            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            hideSuggestionsOnKeyboardHide: false,
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: isbn,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.book),
                                  hintText: "Book"
                              ),
                            ),
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                isbn.text = suggestion["Book-Title"];
                              });
                              var temp = Book(
                                isbn: suggestion.id,
                                bookTitle: suggestion["Book-Title"],
                                bookAuthor: suggestion["Book-Author"],
                                ratings: suggestion["Ratings"],
                                publisher: suggestion["Publisher"],
                                yearOfPublication: suggestion["Year-Of-Publication"],
                                imageUrlS: suggestion["Image-URL-S"],
                                imageUrlM: suggestion["Image-URL-M"],
                                imageUrlL: suggestion["Image-URL-L"],
                              );
                              selectedBook = temp;
                            },
                            itemBuilder: (context, suggestion) {
                              return Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: MediaQuery.of(context).size.height * 0.1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          child: Image(image: NetworkImage(suggestion["Image-URL-S"]),
                                              fit: BoxFit.fitHeight,),
                                          width: MediaQuery.of(context).size.width * 0.2,
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(suggestion["Book-Title"]),
                                            subtitle: Text(suggestion["Book-Author"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4,),
                                ],
                              );
                            },
                            suggestionsCallback: (String pattern) async {
                              if (pattern == "" || pattern == null)
                                return null;
                              return (await bookReference
                                  .limit(5)
                                  .where("Book-Title", isGreaterThanOrEqualTo: pattern)
                                  .where("Book-Title", isLessThanOrEqualTo: pattern + "zzzzzzzz")
                                  .get().then((value) {return value.docs;})).toList();
                            },
                          ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ProjectContainer(
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _autovalidateMode,
                          child: TextFormField(
                            key: Key(Keys.ContentField),
                            maxLines: 5,
                            controller: text,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              prefixIcon: Icon(Icons.rate_review),
                              hintText: selectedItem == postChoice[0]
                                  ? "Quote"
                                  : "Review",
                            ),
                            validator: (value) {
                              var valid = new Validator();
                              if (valid.validateText(value) == TextValidationResults.EMPTY)
                                return "Can not be empty";
                              else if (valid.validateText(value) == TextValidationResults.VALID)
                                return null;
                              else
                                return "Given text can not be higher than 360 characters";
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    selectedItem == postChoice[1] ? Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ProjectContainer(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Rating: ", style: TextStyle(color: Colors.black, fontSize: 18),),
                            DropdownButton<Rating>(
                              key: Key(Keys.RatingDropButton),
                              hint: Text("Choose a rate"),
                              value: selectedRating,
                              items: postRating.map((Rating item) {
                                return DropdownMenuItem<Rating>(
                                  child: Row(
                                    key: item.score == "3" ? Key(Keys.Rating3) : Key(item.score),
                                    children: [
                                      Icon(Icons.star, color: const Color(0xFF167F67),),
                                      SizedBox(width: 10,),
                                      Text(item.score, style: TextStyle(color: Colors.black),),
                                    ],
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (Rating value) {
                                setState(() {
                                  selectedRating = value;
                                });
                              },
                            ),
                          ],
                        )),
                      ),
                    ) : Container(),
                    SizedBox(height: 10,),
                    RaisedButton(
                      key: Key(Keys.CreatePostButton2),
                      onPressed: () async {
                        _validateInputs();
                        if (_autovalidateMode != AutovalidateMode.always && selectedBook != null) {
                          createPostFunction();
                        }
                      },
                      color: Colors.purple[300],
                      child: Text(
                        "Create Post",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );


}