import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:gquiz/models/user.dart';

import 'home.dart';

int postion = 3;
List<User> top = [];

class Scoreboard extends StatefulWidget {
  const Scoreboard({Key key}) : super(key: key);

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  @override
  void initState() {
    postion = 3;
    super.initState();
  }

  Future getUsers() async {
    var firestore = FirebaseFirestore.instance;
    int count = 0;
    QuerySnapshot users = await firestore
        .collection("User")
        .orderBy("score", descending: true)
        .get();
    print(users.docs.length.toString());
    return users.docs;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xff5DE2A2)),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text("2",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins_Bold",
                                        fontSize: 25)),
                                SizedBox(
                                  height: 5,
                                ),
                                SvgPicture.asset("assets/rank_normal.svg"),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: small ? 115 : 130,
                                  height: small ? 115 : 130,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black38
                                                .withOpacity(0.09),
                                            spreadRadius: 1,
                                            blurRadius: 10),
                                      ]),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("@user2",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Poppins_Bold",
                                        fontSize: small ? 15 : 18)),
                                Text("7501",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins_Bold",
                                        fontSize: small ? 23 : 25)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Text("3",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins_Bold",
                                        fontSize: small ? 23 : 25)),
                                SizedBox(
                                  height: 5,
                                ),
                                SvgPicture.asset("assets/rank_down.svg"),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: small ? 115 : 130,
                                  height: small ? 115 : 130,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black38
                                                .withOpacity(0.09),
                                            spreadRadius: 1,
                                            blurRadius: 10),
                                      ]),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("@user3",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Poppins_Bold",
                                        fontSize: small ? 15 : 18)),
                                Text("7101",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins_Bold",
                                        fontSize: small ? 23 : 25)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("1",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins_Bold",
                                    fontSize: small ? 23 : 25)),
                            SizedBox(
                              height: 5,
                            ),
                            SvgPicture.asset("assets/crown.svg"),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: small ? 140 : 160,
                              height: small ? 140 : 160,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black38.withOpacity(0.09),
                                        spreadRadius: 1,
                                        blurRadius: 10),
                                  ]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("@user1",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins_Bold",
                                    fontSize: small ? 15 : 18)),
                            Text("8701",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins_Bold",
                                    fontSize: small ? 23 : 25)),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              child: FutureBuilder(
                  future: getUsers(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading"),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            User myNew = User();
                            myNew = User.fromJson(snapshot.data[index].data());
                            return UserItem(
                              initials: myNew.initials,
                              name: myNew.firstname,
                              score: myNew.score,
                              color: globals.colorList[myNew.color],
                              rank: myNew.level.toString(),
                            );
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class UserItem extends StatefulWidget {
  final String name, rank;
  final String initials;
  final int score;
  final Color color;

  UserItem({this.initials, this.name, this.score, this.color, this.rank});

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    postion++;
    return Container(
        margin: EdgeInsets.symmetric(vertical: small ? 8 : 10),
        child: Row(
          children: [
            Container(
              width: 30,
              child: Column(
                children: [
                  SvgPicture.asset("assets/rank_" + widget.rank + ".svg"),
                  SizedBox(
                    height: 5,
                  ),
                  Text(postion.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins_Bold",
                          fontSize: small ? 23 : 25)),
                ],
              ),
            ),
            SizedBox(
              width: small ? 10 : 20,
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: small ? 50 : 60,
                    height: small ? 50 : 60,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(widget.initials,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins_Bold",
                              fontSize: small ? 28 : 30)),
                    ),
                  ),
                  Container(
                      width: 90,
                      child: Row(
                        children: [
                          Text("@" + widget.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontSize: small ? 15 : 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                  Row(
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          child: Row(
                            children: [
                              Text(widget.score.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins_Bold",
                                      fontSize: small ? 17 : 20)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  )
                ],
              ),
            ))
          ],
        ));
  }
}
