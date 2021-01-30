import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/screens/anotherProfile/anotherProfile.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListOfUsers extends StatefulWidget {
  final List<String> uids;
  final String title;

  const ListOfUsers({Key key, this.uids, this.title}) : super(key: key);

  @override
  _ListOfUsersState createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers> {
  List<Bookworm> users = [];
  Future listFuture;

  getAllUserInfo() async {
    await Future.forEach(widget.uids, (element) async {
      var temp = await BookDatabase().getUserInfo(element);
      users.add(temp);
    });
  }

  @override
  void initState() {
    super.initState();
    listFuture = getAllUserInfo();
  }

  @override
  Widget build(BuildContext context)  {
    return FutureBuilder(
      future: listFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Center(child: CircularProgressIndicator(),);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).accentColor,
            title: Text("bookabitual",
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).bottomAppBarColor,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.openSans(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 3,
                color: Colors.grey[800],
              ),
              SizedBox(height: 5,),
              Expanded(
                child: users.length == 0 ? Center(
                  child: Column(
                    children: [
                      SizedBox(height: 15,),
                      ProjectContainer(
                        child: Text(
                            "There is nothing to show here.",
                            style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherProfilePage(user: users[index]),),);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        child: ProjectContainer(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(backgroundImage: AssetImage(avatars[users[index].photoIndex]), radius: 40,),
                                SizedBox(width: 20,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person_outline, color: Colors.grey[300],),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child: AutoSizeText(
                                            users[index].username,
                                            minFontSize: 10,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.mail_outline, color: Colors.grey[300],),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child: AutoSizeText(
                                            users[index].currentBookName,
                                            minFontSize: 10,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.adb, color: Colors.grey[300],),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child: AutoSizeText(
                                            users[index].name,
                                            minFontSize: 10,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
