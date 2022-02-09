import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

int percentage = 0;

class _UserProfileState extends State<UserProfile> {
  double singlecount = 100 / (globals.currentlevelxp) * 0.01;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xffFED330),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(60),
                bottomLeft: Radius.circular(60)),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 20),
                  ],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/trophy.svg",
                              width: 40,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Column(
                                children: [
                                  Text("Score"),
                                  Countup(
                                      duration: Duration(milliseconds: 1000),
                                      begin: 0,
                                      end: globals.myUser.score.toDouble(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Poppins_Bold",
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/point.svg",
                              width: 40,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Column(
                                children: [
                                  Text("Coins"),
                                  Countup(
                                      duration: Duration(milliseconds: 1000),
                                      begin: 0,
                                      end: globals.myUser.coins.toDouble(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Poppins_Bold",
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                            color: Color(int.parse(globals.myUser.color),),
                            shape: BoxShape.circle),
                        child: Center(
                            child: Text(
                          globals.myUser.initials.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins_Bold",
                              fontSize: 50),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      globals.myUser.firstname + " " + globals.myUser.lastname,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: "Poppins_Bold",
                          fontSize: 30),
                    ),
                    Text(
                      "@username",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: "Poppins",
                          fontSize: 22),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Rank",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: "Poppins",
                                    fontSize: 22),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          LinearPercentIndicator(
                            percent: singlecount * globals.myUser.xp,
                            progressColor: const Color(0xffFED330),
                            lineHeight: 30,
                            animation: true,
                            center: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (globals.myUser.level.toString()),
                                  style: TextStyle(fontFamily: "Poppins_Bold"),
                                ),
                                Text(
                                  ((globals.myUser.level + 1).toString()),
                                  style: TextStyle(
                                      fontFamily: "Poppins_Bold",
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    ("XP " + globals.myUser.xp.toString()),
                                    style:
                                        TextStyle(fontFamily: "Poppins_Bold"),
                                  ),
                                  Text(
                                    ("/" + globals.currentlevelxp.toString()),
                                    style: TextStyle(fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    ((globals.currentlevelxp -
                                                globals.myUser.xp)
                                            .toString() +
                                        "XP"),
                                    style:
                                        TextStyle(fontFamily: "Poppins_Bold"),
                                  ),
                                  Text(
                                    ("/to level up"),
                                    style: TextStyle(fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
