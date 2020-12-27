import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Item{
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}

List<Item> postChoice = <Item> [
  const Item("Quote", Icon(Icons.collections_bookmark, color: const Color(0xFF167F67),)),
  const Item("Review", Icon(Icons.rate_review, color: const Color(0xFF167F67),)),
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

  final TextEditingController _isbn = TextEditingController();
  final TextEditingController _text = TextEditingController();

  Item _selectedItem = postChoice[0];
  Rating _selectedRating = postRating[0];

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
                              hint: Text("Choose a category"),
                              value: _selectedItem,
                              items: postChoice.map((Item item) {
                                return DropdownMenuItem<Item>(
                                  child: Row(
                                    children: [
                                      item.icon,
                                      SizedBox(width: 10,),
                                      Text(item.name, style: TextStyle(color: Colors.black),),
                                    ],
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (Item value) {
                                setState(() {
                                  _selectedItem = value;
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
                        TextFormField(
                          controller: _isbn,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.book),
                            hintText: "Book"
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ProjectContainer(
                        child: TextFormField(
                          maxLines: 5,
                          controller: _text,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.rate_review),
                            hintText: _selectedItem == postChoice[0] ? "Quote" : "Review",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    _selectedItem == postChoice[1] ? Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ProjectContainer(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Rating: ", style: TextStyle(color: Colors.black, fontSize: 18),),
                            DropdownButton<Rating>(
                              hint: Text("Choose a rate"),
                              value: _selectedRating,
                              items: postRating.map((Rating item) {
                                return DropdownMenuItem<Rating>(
                                  child: Row(
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
                                  _selectedRating = value;
                                });
                              },
                            ),
                          ],
                        )),
                      ),
                    ) : Container(),
                    SizedBox(height: 10,),
                    RaisedButton(
                      onPressed: () async {
                        String postID = Uuid().v4();
                        if (_selectedItem == postChoice[1]) {
                          ReviewPost temp = ReviewPost(
                            isbn: _isbn.text,
                            uid: Provider.of<CurrentUser>(context, listen: false).getCurrentUser.uid,
                            postID: postID,
                            text: _text.text,
                            rating: _selectedRating.score,
                            status: "Reading",
                            likes: {},
                            comments: {},
                            createTime: Timestamp.now(),
                          );
                          await temp.updateInfo();
                          await BookDatabase().createReview(temp);
                          viewState(() {
                            postList.insert(0, temp);
                          });
                        } else {
                          QuotePost temp = QuotePost(
                            isbn: _isbn.text,
                            uid: Provider.of<CurrentUser>(context, listen: false).getCurrentUser.uid,
                            postID: postID,
                            text: _text.text,
                            status: "Reading",
                            likes: {},
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
                        controller.animateTo(0.0, curve: Curves.bounceOut, duration: const Duration(milliseconds: 1000),);
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