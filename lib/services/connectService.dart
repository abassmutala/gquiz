import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:gquiz/models/question.dart';
import 'package:gquiz/models/questions.dart';
import 'package:gquiz/models/user.dart';
import 'package:gquiz/models/userplay.dart';
import 'package:gquiz/screens/battle.dart';

class ConnectService {
  Future<String> getTable(String category) async {
    bool found = false;
    print("getting");
    String mytablename;

    await FirebaseFirestore.instance
        .collection("Tables")
        .doc(category)
        .collection("Players")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          if (!found) {
            if (element["player2"] == "none") {
              found = true;
              mytablename = element["player1"];
            }
          }
        });
      } else {
        print("empty");
        mytablename = null;
      }
    });
    return mytablename;
  }

  Future<String> createTable(String category) async {
    await FirebaseFirestore.instance
        .collection("Tables")
        .doc(category)
        .collection("Players")
        .doc(globals.myUser.firstname)
        .set({
      "player1": globals.myUser.firstname,
      "player2": "none",
      "loaded": false
    }).then((value) {});
    return "created";
  }

  Future<String> getmybot() async {
    return "bot";
  }

  Future<bool> getCreatedTable(String table, String opponent) async {
    await FirebaseFirestore.instance
        .collection("PlayTable")
        .doc(table)
        .get()
        .then((value) async {
      UserPlay player1 = UserPlay(
          firstname: globals.myUser.firstname, question: 1, correct: 0);
      UserPlay mplayer2 =
          UserPlay(firstname: opponent, question: 1, correct: 0);
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

      globals.globalQuestions = _questionList;
      globals.opponentProfile = myopponent;
      globals.opponentPlay = mplayer2;
      globals.myPlay = player1;
    });
    return true;
  }

  Future<User> loadbot() async {
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
    globals.opponentProfile = currentbot;
    return currentbot;
  }

  Future<String> joinTable(String category, String player) async {
    String tableName;

    await FirebaseFirestore.instance
        .collection("Tables")
        .doc(category)
        .collection("Players")
        .doc(player)
        .update({'player2': globals.myUser.firstname}).then((value) {
      tableName = player + "_VS_" + globals.myUser.firstname;
    });
    return tableName;
  }

  Future<List<Question>> getQuestions(
      String category, String table, String opponent) async {
    List<DocumentSnapshot> documents = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Question")
        .doc(category)
        .collection("Difficulty")
        .get();

    snapshot.docs.forEach((document) {
      print("adding" + document.id.toString());
      documents.add(document);
    });

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
    UserPlay player1 =
        UserPlay(firstname: globals.myUser.firstname, question: 1, correct: 0);
    UserPlay player2 = UserPlay(firstname: opponent, question: 1, correct: 0);
    Questions myquestions = Questions(questions: _questionList);
    globals.globalQuestions = _questionList;
    globals.globalQuestions.shuffle();
    globals.opponentPlay = player1;
    globals.myPlay = player2;
    globals.table = table;

    await FirebaseFirestore.instance.collection("PlayTable").doc(table).set({
      globals.myUser.firstname: player1.toJson(),
      opponent: player2.toJson(),
      "questions": myquestions.toMap()["questions"]
    }).then((value) async {
      print("completed");
    });
    print(globals.globalQuestions.length.toString());
    //await Firestore.instance.collection("Tables").doc(category).collection("Players").doc(globals.myUser.firstname).delete();
    return _questionList;
  }

  Future<User> getPlayerData(String user) async {
    User myNew = User();
    await FirebaseFirestore.instance
        .collection("User")
        .doc(user)
        .get()
        .then((value) {
      myNew = new User.fromJson(value.data());
    });
    return myNew;
  }
}
