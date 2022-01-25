import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gquiz/dialogue/hero_dialogue.dart';
import 'package:gquiz/models/question.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:gquiz/models/questions.dart';
import 'package:gquiz/models/user.dart';
import 'package:gquiz/models/userplay.dart';
import 'package:gquiz/screens/play_vs.dart';
import 'package:gquiz/services/connectService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../adhelper.dart';
import 'home.dart';

String category = "";

class Battle extends StatefulWidget {
  @override
  _BattleState createState() => _BattleState();
}

String oppenentName = "",
    firstname = "",
    lastname = "",
    number = "",
    color = "",
    opponentfirstname,
    questiondone = "";
int age = 0, rank = 100, opponentColor = 2, opponentRank;
bool playuser = false,
    loading = false,
    image = false,
    editing = false,
    bot = false,
    dissmiss = true;
Color profileColor = null;
String botname = "";
StateSetter _setState;
List<Question> getquestion = [];
User myopponent;
DocumentReference listen1;
DocumentReference listen2;

final _formKey = GlobalKey<FormState>();

class _BattleState extends State<Battle> with TickerProviderStateMixin {
  ConnectService connectService = ConnectService();

  void _update(bool value) {
    print("none is");

    // getdata(category);
    startConnection(category);
  }

  @override
  void dispose() {
    _setState = null;

    listen2.snapshots().cast();
    listen1 = null;
    listen2 = null;
    _BattleState().dispose();
    _BattleState().reassemble();

    super.dispose();
  }

  @override
  void initState() {
    checkConnection();
    uploadData();
    super.initState();
  }

  uploadData() async {}
  loggedIn() {
    Navigator.of(context).push(HeroDialogRoute(
        builder: (context) => new CategoryDialogue(update: _update)));
    print("not empty");
  }

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        offline = false;
      }
    } on SocketException catch (_) {
      offlineDialog(context);
      offline = true;
    }
  }

  bool connected = false, offline = false, useronline = false;

  int _groupValue = -1;

  var genderList = [
    "male",
    "mal",
    "male",
    "male",
    "female",
    "female",
    "female",
    "female",
    "female",
    "female",
    "male",
    "male",
    "male",
    "male",
    "male",
    "male",
    "male",
    "female",
    "female",
    "male",
    "female",
    "male",
    "male",
    "male",
    "male",
    "male",
    "male",
    "male",
    "female",
    "female",
    "male",
    "male",
    "female",
    "male",
    "male",
    "male",
    "male",
    "male",
    "male",
    "female",
    "female",
    "female",
    "male",
    "female",
    "male",
    "male",
    "male",
    "male",
    "male",
    "male",
  ];
  var nameList = [
    "evans_amo",
    "kelvin_carl",
    "kwasi_mensah",
    "pual_daniels,",
    "ama_esther",
    "richard_baah",
    "emanuella_chad",
    "pamilla_ackins"
        "akosua_nano",
    "emelia_aba",
    "clement_jhan"
        "john_adade",
    "Peter_akins",
    "Fiifi_awule",
    "Emmanuel_frimpomg",
    "James_carter",
    "Kwame_asiedu",
    "Cecelia_donkor",
    "Erica_mills",
    "Yaw_bhad",
    "Judit_frimpong",
    "Henry_addo",
    "Robert_turkson",
    "Emannuel_mensah",
    "Kwesi_sika",
    "Desmond_bentil",
    "Caleb_achempong",
    "Gideon_mensah",
    "Mame_ama",
    "Tracy_bediako",
    "Ibrihim_musa",
    "Mohammed_hamzah",
    "Hajia_pretty",
    "Nii_humbe",
    "Kwame_sisil",
    "Derickson_aboagye",
    "Mallam_musa",
    "Ishmel_addo",
    "Kofi_anani",
    "Haijia_real",
    "Fafatuu_musa",
    "Yaa_baby",
    "Emanuel_niiamo",
    "tracy_bediako",
    "petter_erickson",
    "gedion_beko",
    "hamilton_stacy",
    "mike_dan",
    "prince_authur",
    "yaw_jedi"
  ];
  var ranklist = [
    100,
    100,
    98,
    95,
    101,
    154,
    100,
    100,
    66,
    100,
    87,
    130,
    79,
    56,
    200,
    45,
    167,
    99,
    230,
    169,
    170,
    60,
    162,
    164,
    154,
    180,
    145,
    90,
    230,
    300,
    113,
    140,
    230,
    70,
    200,
    290,
    230,
    230,
    240,
    230,
    55,
    79,
    600,
    243,
    230,
    200,
    205,
    184,
    320,
    200,
  ];
  var levelList = [
    2,
    5,
    7,
    10,
    13,
    15,
    18,
    22,
    25,
    27,
    29,
    31,
    35,
    37,
    40,
    43,
    45,
    48,
    52,
    55,
    58,
    60,
    62,
    64,
    67,
    69,
    72,
    74,
    76,
    79,
    83,
    85,
    89,
    93,
    95,
    98,
    100,
    104,
    115,
    120,
    129,
    124,
    130,
    132,
    148,
    150,
    155,
    164,
    180,
    200,
  ];

  List<DocumentSnapshot> documents = [];
  int mindex = 0;
  savbot() {
    nameList.forEach((element) async {
      globals.colorListnum.shuffle();
      var mybot = element.split("_");
      String first = mybot[0].toLowerCase();
      String last = mybot[1].toLowerCase();
      User myNew = User(
          firstname: first,
          lastname: last,
          initials: first[0] + last[0],
          gender: genderList[nameList.indexOf(element)],
          number: "0323231232",
          created: "3",
          birthday: "3",
          image: "",
          color: globals.colorListnum[0],
          level: levelList[nameList.indexOf(element)],
          xp: 30,
          score: 10,
          coins: 10,
          rank: ranklist[nameList.indexOf(element)]);
      await FirebaseFirestore.instance
          .collection("Bot")
          .doc(mybot.first.toLowerCase())
          .set(myNew.toJson());
      print(myNew.firstname);
      mindex += 1;
      print(mindex.toString());
    });
  }

  getBot() {
    print("getting");
    connected = true;

    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlayVs(
              bot: true,
            )));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xffC4D5FE),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(60),
                bottomLeft: Radius.circular(60)),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyCard('Play 1on1', 'assets/one_one.svg', context),
                    SizedBox(
                      height: small ? 5 : 12,
                    ),
                    MyCard(
                        "Play with friends", 'assets/play_friend.svg', context),
                    SizedBox(
                      height: 250,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  connectDialog(context) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.all(0),
              elevation: 0,
              content: new StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  _setState = setState;

                  return preview();
                },
              ));
        }).then((value) {
      FirebaseFirestore.instance
          .collection("Tables")
          .doc(category)
          .collection("Players")
          .doc(globals.myUser.firstname)
          .delete();
    });
  }

  editDialog(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: edit());
            },
          );
        });
  }

  edit() {
    return Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Text(
              "SELECT COLOR",
              style: TextStyle(fontFamily: "Poppins_Bold"),
              textAlign: TextAlign.start,
            ),
          ],
        ));
  }

  offlineDialog(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: offlineContainer());
            },
          );
        });
  }

  loadbot(String mycategory, String opponent) async {
    if (playuser) {
      return;
    }
    bot = true;
    List<User> bots = [];

    await FirebaseFirestore.instance.collection("Bot").get().then((value) {
      value.docs.forEach((element) {
        int botlovel = element["level"];
        int mylevel = globals.myUser.level;
        if (botlovel > mylevel && botlovel < (mylevel + 15)) {
          User myNew = User();
          myNew = new User.fromJson(element.data());
          bots.add(myNew);
          print(myNew.firstname);
          print(myNew.level.toString());
        }
      });
    });
    bots.shuffle();
    User currentbot = bots[0];
    botname = currentbot.firstname;
    myopponent = currentbot;
    arrangematch(mycategory, globals.myUser.firstname);
  }

  awaituser(String mycategory) async {
    Future.delayed(Duration(milliseconds: 5000), () {
      loadbot(mycategory, globals.myUser.firstname);
    });
    listen2 = FirebaseFirestore.instance
        .collection("Tables")
        .doc(mycategory)
        .collection("Players")
        .doc(globals.myUser.firstname);
    await listen2.snapshots().listen((event) async {
      if (event == null) {
        return;
      }
      String player2 = event["player2"];
      bool loaded = event["loaded"];
      if (player2 == "none") {
        print("none");
      } else {
        print(player2);
        if (!bot) {
          await FirebaseFirestore.instance
              .collection("User")
              .doc(player2)
              .get()
              .then((value) {
            User myNew = User();

            myNew = new User.fromJson(value.data());
            myopponent = myNew;
            playuser = true;
            _setState(() {
              connected = true;
            });
            print(myNew.firstname);
          });
        } else {
          print("loadingbot");
        }
      }
      if (loaded) {
        if (bot) {
          await FirebaseFirestore.instance
              .collection("Tables")
              .doc(mycategory)
              .collection("Players")
              .doc(globals.myUser.firstname)
              .delete()
              .then((value) {
            Future.delayed(Duration(milliseconds: 2000), () {
              globals.bot = true;

              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlayVs(
                        bot: true,
                      )));
              return;
            });
          });

          return;
        }
        await FirebaseFirestore.instance
            .collection("PlayTable")
            .doc(globals.myUser.firstname + "_VS_" + player2)
            .get()
            .then((value) async {
          UserPlay player1 = UserPlay(
              firstname: globals.myUser.firstname, question: 1, correct: 0);
          UserPlay mplayer2 =
              UserPlay(firstname: player2, question: 1, correct: 0);
          List<Question> _questionList = [];
          List<dynamic> map = value["questions"];

          map.forEach((element) {
            Map<String, dynamic> nes = Map<String, dynamic>.from(element);
            Question qq = Question.fromMap(nes);
            _questionList.add(qq);
            String question = element["question"];
            print(question);
            print("easy");
          });

          String table = globals.myUser.firstname + "_VS_" + player2;
          globals.globalQuestions = _questionList;
          globals.opponentProfile = myopponent;
          globals.opponentPlay = player1;
          globals.myPlay = mplayer2;
          globals.table = table;
          FirebaseFirestore.instance
              .collection("Tables")
              .doc(mycategory)
              .collection("Players")
              .doc(globals.myUser.firstname)
              .delete()
              .then((value) {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PlayVs()));
            return;
          });
        });
      }
    });
  }

  reset() {
    _setState(() {
      playuser = false;
      loading = false;
      image = false;
      editing = false;
      bot = false;
      dissmiss = true;
      profileColor = null;
      botname = "";
      connected = false;
      getquestion = [];
      myopponent = null;
      listen1 = null;
      listen2 = null;
      connected = false;
    });
  }

  startConnection(String mcategory) async {
    connectDialog(context);
    String player = await ConnectService().getTable(mcategory);
    String loaded = "";
    String loadtable = "";
    String gopponent = "";
    if (player == null) {
      print("no table avaibale");
      String mytable = await ConnectService().createTable(mcategory);

      if (mytable == null) {
        bool donecreate =
            await ConnectService().getCreatedTable(loadtable, gopponent);
        if (donecreate) {
          connected = false;
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (conext) => PlayVs(
                    bot: false,
                  )));
        }
      } else if (mytable != null) {
        _update() async {
          print("bot");
          User mbot = await ConnectService().loadbot();
          print(mbot.firstname);
          _setState(() {
            connected = true;
            myopponent = mbot;
          });
          String table = globals.myUser.firstname + "_VS_" + mbot.firstname;
          String opponent = mbot.firstname;
          List<Question> getQuest =
              await ConnectService().getQuestions(category, table, opponent);
          print("questions are :" + getQuest.length.toString());
          connected = false;
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (conext) => PlayVs(
                    bot: true,
                  )));
        }

        waitForUser(mcategory, _update).then((value) async {
          await value;
          if (value == null) {
            print("isnotnull");
          }
          if (value == "bot") {
          } else {
            if (value == "skip") {
            } else {
              print(value.toString());
            }
          }
        });
      }
    } else {
      String tableName = await ConnectService().joinTable(mcategory, player);
      User mopponent = await ConnectService().getPlayerData(player);
      _setState(() {
        connected = true;
        myopponent = mopponent;
      });
      List<Question> getQuest =
          await ConnectService().getQuestions(mcategory, tableName, player);
      print(("questions" + getQuest.length.toString()));
      print(tableName);
    }
  }

  updatedialog(String username) async {
    String gopponent = username.toString();
    String loadtable = globals.firstname + "_VS_" + gopponent;
    User mopponent = await ConnectService().getPlayerData(gopponent);
    _setState(() {
      connected = true;
      myopponent = mopponent;
    });
  }

  waitForUser(String category, Function update) async {
    Future.delayed(Duration(milliseconds: 5000), () {
      update();
    });
    print("waiting");
    bool nouser = true;
    String player2 = null;
    DocumentReference mytable = FirebaseFirestore.instance
        .collection("Tables")
        .doc(category)
        .collection("Players")
        .doc(globals.myUser.firstname);

    mytable.snapshots().listen((event) async {
      if (event == null) {
        return null;
      }
      if (event.data == null) {
        return "skip";
      }

      String mplayer2 = event["player2"];
      bool loaded = event["loaded"];
      if (loaded) {
        print("questions complete");
      }
      if (mplayer2 == "none") {
        print("none");
      } else {
        player2 = mplayer2;
        updatedialog(player2);
        return player2;
      }
    });
  }

  getdata(String mycategory) async {
    await FirebaseFirestore.instance
        .collection("Tables")
        .doc(mycategory)
        .collection("Players")
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        print("null");
        await FirebaseFirestore.instance
            .collection("Tables")
            .doc(mycategory)
            .collection("Players")
            .doc(globals.myUser.firstname)
            .set({
          "player1": globals.myUser.firstname,
          "player2": "none",
          "loaded": false
        }).then((value) {
          print("created");
          awaituser(mycategory);
          return;
        });
        return;
      } else {
        print("not null");
        value.docs.forEach((element) {
          if (element["player2"] == "none") {
            arrangematch(mycategory, element["player1"]);
            return;
          }
        });
      }
    });
  }

  void getQuestions(String category, String opponent) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Question")
        .doc(category)
        .collection("Difficulty")
        .get();

    snapshot.docs.forEach((document) {
      documents.add(document);
    });

    loadCategory(category, opponent);
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  loadCategory(String mycategory, String opponent) async {
    List<Question> _questionList = [];
    easy(int limit) {
      List<dynamic> map = documents[0]["allQuestions"];
      map.shuffle();
      int stop = limit;

      map.forEach((element) {
        if (stop != 0) {
          Map<String, dynamic> nes = Map<String, dynamic>.from(element);
          Question qq = Question.fromMap(nes);
          _questionList.add(qq);
          String question = element["question"];
          stop--;
          print("easy");
        }
      });
    }

    normal(int limit) {
      List<dynamic> map = documents[2]["allQuestions"];
      int stop = limit;
      map.shuffle();

      map.forEach((element) {
        if (stop != 0) {
          Map<String, dynamic> nes = Map<String, dynamic>.from(element);
          Question qq = Question.fromMap(nes);
          _questionList.add(qq);
          String question = element["question"];
          stop--;
          print("normal");
        }
      });
    }

    hard(int limit) {
      List<dynamic> map = documents[1]["allQuestions"];
      map.shuffle();
      int stop = limit;

      map.forEach((element) {
        if (stop != 0) {
          Map<String, dynamic> nes = Map<String, dynamic>.from(element);
          Question qq = Question.fromMap(nes);
          _questionList.add(qq);
          String question = element["question"];
          stop--;
          print("hard");
        }
      });
    }

    easy(4);
    normal(3);
    hard(3);

    nameList.shuffle();

    globals.globalQuestions = _questionList;
    globals.globalQuestions.shuffle();
    UserPlay player1 = UserPlay(firstname: opponent, question: 1, correct: 0);
    UserPlay player2 = UserPlay(
        firstname: bot ? botname : globals.myUser.firstname,
        question: 1,
        correct: 0);
    Questions myquestions = Questions(questions: _questionList);
    String table = opponent + "_VS_" + botname;
    globals.opponentPlay = player1;
    globals.myPlay = player2;
    globals.table = table;
    globals.opponentProfile = myopponent;
    await FirebaseFirestore.instance.collection("PlayTable").doc(table).set({
      opponent: player1.toJson(),
      bot ? botname : globals.myUser.firstname: player2.toJson(),
      "questions": myquestions.toMap()["questions"]
    }).then((value) async {
      print("completed");
      await FirebaseFirestore.instance
          .collection("Tables")
          .doc(mycategory)
          .collection("Players")
          .doc(opponent)
          .update({"loaded": true}).then((value) {
        Future.delayed(Duration(milliseconds: 2000), () {
          if (!bot) {
            reset();

            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PlayVs()));
            return;
          }
        });
      });
    });
    print(globals.globalQuestions.length.toString());
  }

  arrangematch(String mycategory, String opponent) async {
    await FirebaseFirestore.instance
        .collection("Tables")
        .doc(mycategory)
        .collection("Players")
        .doc(opponent)
        .update({"player2": bot ? botname : globals.myUser.firstname}).then(
            (value) async {
      listen1 = FirebaseFirestore.instance
          .collection("Tables")
          .doc(mycategory)
          .collection("Players")
          .doc(opponent);
      await listen1.snapshots().listen((event) async {
        if (event.data == null) {
          return;
        }
        bool loaded = event["loaded"];
        if (!loaded) {
          print("not loaded");
          if (!bot) {
            await FirebaseFirestore.instance
                .collection("User")
                .doc(opponent)
                .get()
                .then((value) {
              User myNew = User();

              myNew = new User.fromJson(value.data());
              myopponent = myNew;
              _setState(() {
                connected = true;
              });
              getQuestions(category, opponent);
              print(myNew.firstname);
              return;
            });
          } else {
            _setState(() {
              connected = true;
            });
            getQuestions(category, opponent);
            return;
          }
        } else {
          print("loaded");
        }
      });
    });
  }

  preview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width - 30,
          height: 250,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: globals
                                            .colorList[globals.myUser.color],
                                        shape: BoxShape.circle),
                                    child: (Center(
                                        child: Text(
                                      globals.myUser.initials.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins_Bold",
                                          fontSize: 40),
                                    ))),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              shape: BoxShape.circle),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Lvl",
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: "Poppins_Bold"),
                                              ),
                                              Text(
                                                globals.myUser.level.toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: globals
                                                            .colorListfixed[
                                                        globals.myUser.color],
                                                    fontFamily: "Poppins_Bold"),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "@" + globals.myUser.firstname,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/up-arrow.svg',
                                    color: Colors.green[600],
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    globals.myUser.rank.toString(),
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontFamily: "Poppins",
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          child: !connected
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: globals
                                                  .colorList[myopponent.color],
                                              shape: BoxShape.circle),
                                          child: (Center(
                                              child: Text(
                                            myopponent.initials.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins_Bold",
                                                fontSize: 40),
                                          ))),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    shape: BoxShape.circle),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Lvl",
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          fontFamily:
                                                              "Poppins_Bold"),
                                                    ),
                                                    Text(
                                                      myopponent.level
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: globals
                                                                  .colorListfixed[
                                                              myopponent.color],
                                                          fontFamily:
                                                              "Poppins_Bold"),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "@" + myopponent.firstname,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/up-arrow.svg',
                                          color: Colors.green[600],
                                          width: 15,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          myopponent.rank.toString(),
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontFamily: "Poppins",
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Center(
                  child: Text(
                    "VS",
                    style: TextStyle(
                        fontFamily: "Poppins_Bold",
                        fontSize: 30,
                        color: Colors.orange),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(questiondone),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AdmobBanner(
            adUnitId: AdHelper.bannerAdUnitId,
            adSize: AdmobBannerSize.BANNER,
          ),
        ),
      ],
    );
  }

  offlineContainer() {
    return Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off,
              color: const Color(0xff333333),
              size: 50,
            ),
            Text("You Are Offline",
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Poppins_Bold",
                    fontSize: 20)),
            Text(
              "connect to internet to use online features",
              style: TextStyle(
                  fontFamily: "Poppins", color: const Color(0xff999999)),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  final List<String> subjects = [
    'Maths',
    'English',
    'Social Studies',
    'Science'
  ];
  final List<String> subjectIcons = [
    'assets/maths.svg',
    'assets/english.svg',
    'assets/social.svg',
    'assets/science.svg',
  ];

  Widget MyCard(String cardName, String icon, context) {
    return Center(
      child: InkWell(
        onTap: () {
          soundService.Click1();
          soundService.playLocalAsset();
          checkConnection();
          if (offline) {
            return;
          }
          if (!useronline) {
            loggedIn();
          }
        },
        child: Card(
          elevation: 10,
          margin: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            height: small ? 230 : 260,
            width: small ? 230 : 260,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xff4D7DF9)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: small ? 90 : 120,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  cardName,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Poppins_Bold',
                      color: Colors.white),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryDialogue extends StatefulWidget {
  final ValueChanged<bool> update;

  CategoryDialogue({this.update});

  @override
  _CategoryDialogueState createState() => _CategoryDialogueState();
}

final List<String> subjects = ['Maths', 'English', 'Social Studies', 'Science'];
final List<String> subjectIcons = [
  'assets/maths.svg',
  'assets/english.svg',
  'assets/social.svg',
  'assets/science.svg',
];

class _CategoryDialogueState extends State<CategoryDialogue> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 380,
            padding: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                    color: Colors.black38.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15),
              ],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              print("clicked");
                              category = subjects[index];
                              Navigator.of(context).pop();
                              widget.update(true);
                            },
                            child: ListTile(
                              leading: SvgPicture.asset(
                                subjectIcons[index],
                                width: 30,
                                color: Colors.white,
                              ),
                              title: Text(
                                subjects[index],
                                style: TextStyle(
                                    fontFamily: 'Poppins_Bold',
                                    color: Colors.white,
                                    fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemCount: subjects.length),
              ),
            )),
      ],
    );
  }
}
