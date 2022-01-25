import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gquiz/global/widgets.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:gquiz/models/question.dart';
import 'package:gquiz/models/questions.dart';
import 'package:gquiz/screens/play_vs.dart';

class Difficulty extends StatefulWidget {
  @override
  _DifficultyState createState() => _DifficultyState();
}

class _DifficultyState extends State<Difficulty> {
  bool showit = false, done = false;
  int count, index = 0;
  //String question="", answerA="",answerB="",answerC="",answerD="",correct="",all="",category,dif,topic;
  // String all = "";
  final all = TextEditingController();
  final question = TextEditingController();
  final answerA = TextEditingController();
  final answerB = TextEditingController();
  final answerC = TextEditingController();
  final answerD = TextEditingController();
  final correct = TextEditingController();
  final topic = TextEditingController();
  final diff = TextEditingController();

  List<DocumentSnapshot> documents = [];
  List<Question> _questionList = [];
  String subject = "English", di = "Normal";
  final _formkey = GlobalKey<FormState>();

  getQuestions() async {
    count = 0;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Question")
        .doc(subject)
        .collection("Difficulty")
        .get();

    snapshot.docs.forEach((document) {
      documents.add(document);
    });

    remove() async {
      Map<String, dynamic> object = {
        "question": question,
        "answerA": answerA,
        "answerB": answerB,
        "answerC": answerC,
        "answerD": answerD,
        "correctAnswer": correct,
        "categ": subject,
        "dif": di,
        "topic": topic
      };
      await FirebaseFirestore.instance
          .collection("Question")
          .doc(subject)
          .collection("Difficulty")
          .doc(di)
          .update({
        "allQuestions": FieldValue.arrayRemove([object])
      }).then((value) {
        print("deleted");
        done = true;
      });
    }

    add() async {
      Map<String, dynamic> object = {
        "question": question,
        "answerA": answerA,
        ''
            ''
            "answerB": answerB,
        "answerC": answerC,
        "answerD": answerD,
        "correctAnswer": correct,
        "categ": subject,
        "dif": di,
        "topic": topic
      };
      await FirebaseFirestore.instance
          .collection("Question")
          .doc(subject)
          .collection("Difficulty")
          .doc(di)
          .update({
        "allQuestions": FieldValue.arrayUnion([object])
      }).then((value) {
        print("added");
        done = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Card(
            elevation: 20,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formkey,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: all,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "all",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: question,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "Question",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: answerA,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 18),
                          textAlign: TextAlign.center,
                          onChanged: (val) => answerA.text = val,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "AnswerA",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: answerB,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 18),
                          textAlign: TextAlign.center,
                          onChanged: (val) => answerB.text = val,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "AnswerB",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: answerC,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 18),
                          textAlign: TextAlign.center,
                          onChanged: (val) => answerC.text = val,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "AnswerC",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: answerD,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 18),
                          textAlign: TextAlign.center,
                          onChanged: (val) => answerD.text = val,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "AnswerD",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: correct,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 18),
                          textAlign: TextAlign.center,
                          onChanged: (val) => correct.text = val,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "Correct Answer",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: topic,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "Topic",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: diff,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              hintText: "Diff",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (index != 0) {
                                    index -= 1;
                                  }
                                },
                                child:
                                    customButton(Colors.orange, "back", 100)),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  var full = all.text.split("A:");
                                  String que = full[0];
                                  print(que);
                                  var split1 = full[1].split("B:");
                                  String qa = split1[0];
                                  var split2 = split1[1].split("C:");
                                  String qb = split2[0];
                                  var split3 = split2[1].split("D:");
                                  String qc = split3[0];
                                  String qd = split3[1];
                                  _formkey.currentState.validate();
                                  setState(() {
                                    question.text = que;
                                    answerA.text = qa;
                                    answerB.text = qb;
                                    answerC.text = qc;
                                    answerD.text = qd;
                                    print(question.text);
                                  });

                                  Question single = new Question(
                                      question: question.text,
                                      answerA: answerA.text,
                                      answerB: answerB.text,
                                      answerC: answerC.text,
                                      answerD: answerD.text,
                                      correctAnswer: correct.text,
                                      categ: "English",
                                      dif: diff.text,
                                      topic: topic.text);
                                  List<Question> mylistquest = [];
                                  mylistquest.add(single);
                                  Questions myquestions =
                                      new Questions(questions: mylistquest);
                                  await FirebaseFirestore.instance
                                      .collection("Question")
                                      .doc("English")
                                      .collection("Difficulty")
                                      .doc(diff.text)
                                      .update({
                                    "allQuestions":
                                        FieldValue.arrayUnion([single.toMap()])
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("Question_backup")
                                      .doc("English")
                                      .collection("Difficulty")
                                      .doc(diff.text)
                                      .update({
                                    "allQuestions":
                                        FieldValue.arrayUnion([single.toMap()])
                                  });

                                  setState(() {
                                    all.text = "";
                                    question.text = "";
                                    answerA.text = "";
                                    answerB.text = "";
                                    answerC.text = "";
                                    answerD.text = "";
                                    correct.text = "";
                                  });
                                },
                                child:
                                    customButton(Colors.orange, "next", 100)),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (!done) {
                              } else {}
                              setState(() {
                                showit = !showit;
                              });
                            },
                            child: Icon(
                              Icons.check,
                              color: Colors.orange,
                              size: 30,
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text((index + 1).toString() +
                            "/" +
                            _questionList.length.toString())
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
