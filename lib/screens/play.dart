import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gquiz/global/global.dart' as globals;
import 'package:gquiz/global/global.dart';
import 'package:gquiz/global/widgets.dart';
import 'package:gquiz/models/question.dart';
import 'package:gquiz/models/questions.dart';
import 'package:gquiz/models/score.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:math' as math;

import 'package:simple_animations/simple_animations.dart';
import 'package:tutorial/tutorial.dart';

import '../adhelper.dart';
import 'home.dart';

class Play extends StatefulWidget {
  List<DocumentSnapshot> documents;
  Score myScore;
  int ttq;

  Play({this.documents, this.myScore, this.ttq});
  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> with TickerProviderStateMixin {
  AnimationController _controller,
      _controllerfast,
      _controllernew,
      _controllerout,
      _answercontroller,
      _pointController,
      dialogAnimationController;
  Animation<Offset> _slide_left,
      _slide_down,
      _slide_up,
      _slide_out,
      _slide_out2,
      _slide_out3,
      _slide_out4,
      _pointanimation,
      _showAnimation;
  Animation<double> _aScale, _bScale, _cScale, _dScale, scaleOut, scaleAnim;
  bool load = false, animating = false, timepaused = false;
  bool visibleA = true,
      visibleB = true,
      visibleC = true,
      visibleD = true,
      clicked = false,
      streak = false;
  bool aCorrect = false,
      bCorrect = false,
      cCorrect = false,
      dCorrect = false,
      point = false,
      scale = false,
      normal = false;
  bool firsttime = true;
  double score = 0, newscore = 0;
  bool confetti = true;
  bool back = false;
  bool isfinish = false;
  bool restarted = false;
  int ppq = 5;
  int counter = 0;
  int addedxp = 0;
  double percent = 0.00;
  Color pColor = Colors.green;
  int diff = 0;
  int oldxp;
  double mutiply = 1;
  Timer timer, adder;
  String answer = "";
  int current_question = 1;
  int wincoins = 0;
  int currentScore = 0, addpoint = 0;

  bool isLoading;
  final _topic = GlobalKey();
  final _profile = GlobalKey();
  final _counterkey = GlobalKey();
  final _answerskey = GlobalKey();
  final _questionkey = GlobalKey();
  final _answerakey = GlobalKey();
  final _answerbkey = GlobalKey();
  final _answerckey = GlobalKey();
  final _answerdkey = GlobalKey();
  List<TutorialItens> itens = [];
  List<TutorialItens> itens2 = [];
  var colorList = [
    Colors.red,
    Colors.pink,
    Colors.blue,
    Colors.deepPurple,
    Colors.grey[900],
    Colors.indigo[900],
  ];
  Color colorg1 = Colors.pink;
  Color colorg2 = Colors.purple;
  int totalquestion = 8;
  double singlecount;
  int answeredcorrect = 0, anstreak = 0, prevansstreak = 0;
  double tscore = 0;

  void startTimer() {
    counter = 20;
    percent = 1.0;

    addtime();

    timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          if (counter < 10) {
            pColor = Colors.red;
          } else {
            pColor = Colors.green;
          }

          counter--;
        } else {
          if (!timepaused) {
            if (!back) {
              if (!isfinish) {
                if (current_question == totalquestion) {
                  finishDialog(context);
                } else {
                  animate();
                  back = false;
                }
              }
            }
          }
          timer.cancel();
        }
      });
    });
  }

  void addtime() {
    double singlecount = 100 / (counter) * 0.0001;
    adder = new Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        if (counter > 0) {
          if (percent == 0.0) {
          } else {
            percent -= singlecount;
          }
        } else {
          adder.cancel();
          percent = 0.0;
        }
      });
    });
  }

  void addCount() {
    counter = 20;

    timer = new Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String question = "question goes here",
      answerA = "AnswerA",
      answerB = "AnswerB",
      answerC = "AnswerC",
      answerD = "AnswerD",
      topic = "";

  String correctAnswer = "";
  int index = 0, count = 0;

  correct() {
    print(index.toString());
    String correctAnswer = globals.globalQuestions[index].correctAnswer;
    setState(() {
      if (correctAnswer == "A") {
        aCorrect = true;
      }
      if (correctAnswer == "B") {
        bCorrect = true;
      }
      if (correctAnswer == "C") {
        cCorrect = true;
      }
      if (correctAnswer == "D") {
        dCorrect = true;
      }
    });
  }

  answerClicked(String answer) {
    clicked = true;

    counter = 0;
    timepaused = true;
    correct();

    if (answer == correctAnswer) {
      answeredcorrect += 1;
      anstreak += 1;
      _pointController = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      )..forward();
      _pointanimation = Tween<Offset>(
        begin: const Offset(0.00, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(parent: _pointController, curve: Curves.ease));
      point = true;

      Future.delayed(Duration(milliseconds: 2000), () {
        setState(() {
          addpoint = 30;
          newscore = score + addpoint;
          newscore = score + addpoint;
        });
      });
    } else {
      if (anstreak > prevansstreak) {
        prevansstreak = anstreak;
      }
      anstreak = 0;
    }

    // animate();
    var func = [];
    if (answer == "A") {
      answerAup();

      func = [answerBout(), answerCout(), answerDout()];
    }
    if (answer == "B") {
      answerBup();
      func = [answerAout(), answerCout(), answerDout()];
    }
    if (answer == "C") {
      answerCup();

      func = [answerBout(), answerAout(), answerDout()];
    }
    if (answer == "D") {
      answerDup();

      func = [answerBout(), answerCout(), answerAout()];
    }
    setState(() {
      globals.clicked = true;

      animating = true;
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      if (current_question == totalquestion) {
        if (anstreak > prevansstreak) {
          prevansstreak = anstreak;
        }
        setState(() {
          tscore = score;
        });
        finishDialog(context);
        return;
      }
      if (firsttime) {
      } else {
        animate();
      }
    });
  }

  changeQuestions() {
    setState(() {
      question = globals.globalQuestions[index].question;
      answerA = globals.globalQuestions[index].answerA.trim();
      answerB = globals.globalQuestions[index].answerB.trim();
      answerC = globals.globalQuestions[index].answerC.trim();
      answerD = globals.globalQuestions[index].answerD.trim();
      correctAnswer = globals.globalQuestions[index].correctAnswer;
      topic = globals.globalQuestions[index].topic.trim();
    });
  }

  reset() {
    timepaused = false;
    clicked = false;
    startTimer();
    setState(() {
      score = newscore;
      scale = false;
      point = false;
      aCorrect = false;
      bCorrect = false;
      cCorrect = false;
      dCorrect = false;
      globals.clicked = false;
    });

    _aScale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _bScale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _cScale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _dScale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  answerAout() {
    if (correctAnswer == "A") {
      return;
    }
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _aScale = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _answercontroller, curve: Curves.ease));
  }

  answerAup() {
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _aScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _answercontroller, curve: Curves.ease));
  }

  answerBout() {
    if (correctAnswer == "B") {
      return;
    }
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _bScale = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _answercontroller, curve: Curves.ease));
  }

  answerBup() {
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _bScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _answercontroller, curve: Curves.ease));
  }

  answerCout() {
    if (correctAnswer == "C") {
      return;
    }
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _cScale = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _answercontroller, curve: Curves.ease));
  }

  answerCup() {
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _cScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _answercontroller, curve: Curves.ease));
  }

  answerDout() {
    if (correctAnswer == "D") {
      return;
    }
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _dScale = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _answercontroller, curve: Curves.ease));
  }

  answerDup() {
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
    _dScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _answercontroller, curve: Curves.ease));
  }

  animate() {
    setState(() {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      )..forward();

      _slide_left = Tween<Offset>(
        begin: const Offset(0.00, 0.0),
        end: const Offset(-3.0, 0.0),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));

      animating = false;
      _controllerout = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      )..forward();

      _slide_out = Tween<Offset>(
        begin: const Offset(0.00, 0.0),
        end: const Offset(-1.3, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllerout,
        curve: Curves.ease,
      ));

      _slide_out2 = Tween<Offset>(
        begin: const Offset(0.00, 0.0),
        end: const Offset(-1.3, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllerout,
        curve: Interval(0.2, 1.0, curve: Curves.ease),
      ));
      _slide_out3 = Tween<Offset>(
        begin: const Offset(0.00, 0.0),
        end: const Offset(-1.3, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllerout,
        curve: Interval(0.4, 1.0, curve: Curves.ease),
      ));
      _slide_out4 = Tween<Offset>(
        begin: const Offset(0.00, 0.0),
        end: const Offset(-1.3, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllerout,
        curve: Interval(0.6, 1.0, curve: Curves.ease),
      ));

      Future.delayed(Duration(milliseconds: 500), () {
        current_question += 1;
        if (!restarted) {
          index += 1;
        } else {
          setState(() {
            restarted = false;
          });
        }
        changeQuestions();
      });
      questionIn();
      Future.delayed(Duration(milliseconds: 2000), () {
        animateIn();
      });
    });
  }

  animateIn() {
    setState(() {
      reset();
      _controllerout = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      )..forward();

      _slide_out = Tween<Offset>(
        begin: const Offset(1.3, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllerout,
        curve: Curves.ease,
      ));
      _slide_out2 = Tween<Offset>(
        begin: const Offset(1.3, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllerout,
        curve: Interval(0.2, 1.0, curve: Curves.ease),
      ));
      _slide_out3 = Tween<Offset>(
        begin: const Offset(1.3, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllerout,
        curve: Interval(0.4, 1.0, curve: Curves.ease),
      ));
      _slide_out4 = Tween<Offset>(
        begin: const Offset(1.3, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllerout,
        curve: Interval(0.6, 1.0, curve: Curves.ease),
      ));
    });
  }

  loadCategory() {
    wincoins = 100;
    totalquestion = widget.ttq;
    index = 0;
    int mylevel = globals.myUser.level;
    List<Question> _questionList = [];

    easy(int limit) {
      List<dynamic> map = widget.documents[0]["allQuestions"];
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
      List<dynamic> map = widget.documents[2]["allQuestions"];
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
      List<dynamic> map = widget.documents[1]["allQuestions"];
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

    print("dsdsdsdsdsds");

    if (mylevel <= 10) {
      wincoins = 50;
      easy(8);
      mutiply = 1;
      addedxp = 20;
    } else if (mylevel >= 10 && mylevel < 15) {
      wincoins = 70;
      easy(6);
      normal(3);
      hard(1);
      mutiply = 1.5;
      addedxp = 25;
    } else if (mylevel >= 15 && mylevel < 20) {
      wincoins = 100;
      easy(6);
      normal(2);
      hard(2);
      mutiply = 2;
      addedxp = 30;
    } else if (mylevel >= 20 && mylevel < 25) {
      wincoins = 120;
      easy(4);
      normal(4);
      hard(2);
      mutiply = 2.5;
      addedxp = 35;
    } else if (mylevel >= 25 && mylevel < 30) {
      wincoins = 150;
      easy(3);
      normal(4);
      hard(3);
      mutiply = 3;
      addedxp = 40;
    } else if (mylevel >= 30 && mylevel < 35) {
      wincoins = 180;
      easy(3);
      normal(6);
      hard(3);
      mutiply = 4;
      addedxp = 50;
    } else if (mylevel >= 35 && mylevel < 50) {
      wincoins = 180;
      easy(3);
      normal(5);
      hard(4);
      mutiply = 6;
      addedxp = 60;
    } else if (mylevel >= 50 && mylevel < 60) {
      wincoins = 180;
      easy(4);
      normal(6);
      hard(5);
      mutiply = 8;
      addedxp = 70;
    } else if (mylevel >= 60 && mylevel < 70) {
      wincoins = 200;
      easy(3);
      normal(7);
      hard(5);
      mutiply = 10;
      addedxp = 80;
    } else if (mylevel >= 70 && mylevel < 80) {
      wincoins = 200;
      easy(3);
      normal(5);
      hard(7);
      mutiply = 12;
      addedxp = 100;
    } else if (mylevel >= 80 && mylevel < 90) {
      wincoins = 200;
      easy(3);
      normal(3);
      hard(9);
      mutiply = 14;
      addedxp = 150;
    } else if (mylevel >= 90 && mylevel < 100) {
      wincoins = 250;
      easy(2);
      normal(3);
      hard(10);
      mutiply = 16;
      addedxp = 250;
    } else if (mylevel >= 100) {
      wincoins = 300;
      easy(2);
      normal(2);
      hard(11);
      mutiply = 20;
      addedxp = 300;
    }
    singlecount = 100 / (totalquestion / 2) * 0.01;
    globals.globalQuestions = _questionList;
    globals.globalQuestions.shuffle();
    setState(() {
      question = globals.globalQuestions[index].question;
      answerA = globals.globalQuestions[index].answerA.trim();
      answerB = globals.globalQuestions[index].answerB.trim();
      answerC = globals.globalQuestions[index].answerC.trim();
      answerD = globals.globalQuestions[index].answerD.trim();
      correctAnswer = globals.globalQuestions[index].correctAnswer;
      topic = globals.globalQuestions[index].topic.trim();
    });

    print(globals.globalQuestions.length.toString());
  }

  openStartDialogue() {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Cool',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  questionIn() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _slide_left = Tween<Offset>(
      begin: const Offset(5.00, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  Widget custnext() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black38.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 15),
        ],
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Next",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontFamily: "Poppins_bold"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    itens.addAll({
      TutorialItens(
          globalKey: _topic,
          touchScreen: true,
          top: 300,
          left: 50,
          children: [
            Text(
              "Check for topics on each question before you answer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 500,
            )
          ],
          widgetNext: custnext(),
          shapeFocus: ShapeFocus.oval),
      TutorialItens(
          globalKey: _profile,
          touchScreen: true,
          top: 100,
          left: 50,
          children: [
            Text(
              "Game progress will be displayed here",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 500,
            )
          ],
          widgetNext: custnext(),
          shapeFocus: ShapeFocus.oval),
      TutorialItens(
          globalKey: _questionkey,
          touchScreen: true,
          top: 100,
          left: 50,
          children: [
            Text(
              "Current question will be displayed here",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 600,
            )
          ],
          widgetNext: custnext(),
          shapeFocus: ShapeFocus.oval),
      TutorialItens(
          globalKey: _counterkey,
          touchScreen: true,
          top: 100,
          left: 50,
          children: [
            Text(
              "Each question is timed, try not to run out of time",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 500,
            )
          ],
          widgetNext: custnext(),
          shapeFocus: ShapeFocus.oval)
    });
    loadCategory();

    questionIn();

    dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _pointController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _controllerfast = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    scaleOut = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _aScale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _bScale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _cScale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _dScale = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));

    _slide_down = Tween<Offset>(
      begin: const Offset(0.00, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _pointanimation = Tween<Offset>(
      begin: const Offset(0.00, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _pointController, curve: Curves.ease));
    _slide_up = Tween<Offset>(
      begin: const Offset(0.00, -2.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _controllerfast,
        curve: Interval(0.2, 1.0, curve: Curves.ease)));
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        if (firsttime) {
          Future.delayed(Duration(milliseconds: 2000), () {
            Tutorial.showTutorial(context, itens);
          });
        } else {
          animateIn();
        }

        load = true;
        _controllernew = AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: this,
        )..forward();
      });
    });

    _slide_out = Tween<Offset>(
      begin: const Offset(-1.30, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: Curves.ease),
    ));
    _slide_out2 = Tween<Offset>(
      begin: const Offset(-1.30, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: Curves.ease),
    ));
    _slide_out3 = Tween<Offset>(
      begin: const Offset(-1.30, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: Curves.ease),
    ));
    _slide_out4 = Tween<Offset>(
      begin: const Offset(-1.30, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: Curves.ease),
    ));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    counter = 0;
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timeDialog(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: const Color(0xffFED330),
                image:
                    DecorationImage(image: AssetImage("assets/parrten.png"))),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                back = true;
                                confirmDialogue(context);
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/backbutton.svg",
                                      width: 15,
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      key: _topic,
                                      child: Text(topic,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Poppins_Bold",
                                              fontSize: small ? 18 : 20)),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: large ? 30 : 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width - 90,
                              height: large ? 80 : 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                                gradient: new LinearGradient(
                                    colors: [
                                      const Color(0xFF39CDCE2),
                                      const Color(0xFF51CFD9),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: large ? 60 : 50,
                                        height: large ? 60 : 50,
                                        decoration: BoxDecoration(
                                          color:
                                              colorList[globals.myUser.color],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            globals.myUser.initials
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: large ? 20 : 18,
                                                fontFamily: "Poppins_Bold",
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: large ? 10 : 8,
                                            horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(globals.myUser.firstname),
                                            Text(
                                              "lvl " +
                                                  globals.myUser.level
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: large ? 18 : 15,
                                                fontFamily: "Poppins_Bold",
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          key: _profile,
                                          child: Text(
                                            "$current_question/" +
                                                widget.ttq.toString(),
                                            style: TextStyle(
                                                fontSize: large ? 20 : 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    height: 80,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/trophy.svg",
                                          width: large ? 40 : 35,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: large ? 10 : 7,
                                              horizontal: 5),
                                          child: Column(
                                            children: [
                                              Text("Score"),
                                              Countup(
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                  begin: score,
                                                  maxLines: 2,
                                                  end: newscore,
                                                  style: TextStyle(
                                                    fontSize: large ? 20 : 18,
                                                    fontFamily: "Poppins_Bold",
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          key: _counterkey,
                          child: CircularPercentIndicator(
                            percent: percent,
                            radius: large ? 60 : 50,
                            reverse: true,
                            backgroundColor: Colors.transparent,
                            progressColor: pColor,
                            lineWidth: large ? 6 : 4,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: new Text(
                              "$counter",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: large ? 25.0 : 20,
                                  color: pColor,
                                  fontFamily: "Poppins_Bold",
                                  height: 1.5),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: large ? 25 : 18),
                          height: large ? 150 : 120,
                          // decoration: BoxDecoration(color: Colors.white),
                          child: Center(
                            child: SlideTransition(
                              position: _slide_left,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FadeTransition(
                                    opacity: _controller,
                                    child: Column(
                                      children: [
                                        Text(
                                          question,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: large ? 23 : 20,
                                              fontFamily: "Poppins_Bold",
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[800],
                                              height: 1.3),
                                        ),
                                        Container(
                                          key: _questionkey,
                                          width: 200,
                                          height: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            SizedBox(height: large ? 50 : 40),
                            ScaleTransition(
                              scale: scaleOut,
                              child: FadeTransition(
                                opacity: _pointController,
                                child: Visibility(
                                    visible: scale,
                                    child: Text(
                                      "Great",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            SlideTransition(
                              position: _pointanimation,
                              child: FadeTransition(
                                opacity: _pointController,
                                child: Visibility(
                                    visible: point,
                                    child: Text(
                                      "+30",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          !load
              ? SizedBox(
                  height: 0,
                )
              : FadeTransition(
                  opacity: _controllernew,
                  child: Container(
                    key: _answerskey,
                    height: double.infinity,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: large ? 400 : 350,
                        ),
                        GestureDetector(
                            onTap: () {
                              answerClicked("A");
                            },
                            child: ScaleTransition(
                              scale: _aScale,
                              child: SlideTransition(
                                  position: _slide_out,
                                  child: Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: visibleA,
                                      child: Column(
                                        children: [
                                          answerButton(
                                              answerA, context, aCorrect),
                                          Container(
                                            key: _answerakey,
                                            width: 100,
                                            height: 1,
                                          ),
                                        ],
                                      ))),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              answerClicked("B");
                            },
                            child: ScaleTransition(
                              scale: _bScale,
                              child: SlideTransition(
                                  position: _slide_out2,
                                  child: Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: visibleB,
                                      child: Column(
                                        children: [
                                          answerButton(
                                              answerB, context, bCorrect),
                                          Container(
                                            key: _answerbkey,
                                            width: 100,
                                            height: 1,
                                          ),
                                        ],
                                      ))),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              answerClicked("C");
                            },
                            child: ScaleTransition(
                              scale: _cScale,
                              child: SlideTransition(
                                  position: _slide_out3,
                                  child: Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: visibleC,
                                      child: Column(
                                        children: [
                                          answerButton(
                                              answerC, context, cCorrect),
                                          Container(
                                            key: _answerckey,
                                            width: 100,
                                            height: 1,
                                          ),
                                        ],
                                      ))),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              answerClicked("D");
                            },
                            child: ScaleTransition(
                              scale: _dScale,
                              child: SlideTransition(
                                  position: _slide_out4,
                                  child: Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: visibleD,
                                      child: Column(
                                        children: [
                                          answerButton(
                                              answerD, context, dCorrect),
                                          Container(
                                            key: _answerdkey,
                                            width: 100,
                                            height: 1,
                                          ),
                                        ],
                                      ))),
                            )),
                      ],
                    )),
                  ),
                ),
        ],
      ),
    );
  }

  openAlertBox(context) async {
    dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: dialogAnimationController, curve: Curves.ease));

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ScaleTransition(
            scale: scaleAnim,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              backgroundColor: const Color(0xFFefefef),
              elevation: 0,
              content: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "1/10",
                          style: TextStyle(
                              fontSize: 30.0, fontFamily: "Poppins_Bold"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 10,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: 0.7,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Color(0xff00ff00)),
                                backgroundColor: Colors.brown[900],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 85,
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/trophy.svg",
                                                  color: Colors.orange,
                                                  width: 50,
                                                ),
                                                Countup(
                                                  begin: 0,
                                                  end: tscore,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins_Bold",
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 175,
                                            height: 120,
                                            color: Colors.white,
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      width: 120,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFefefef),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Text(
                                                        "answered correct",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Text(
                                                      "+10",
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 10,
                                                          fontFamily:
                                                              "Poppins"),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      width: 120,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFefefef),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Text(
                                                        "3 answer streak",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Text(
                                                      "+10",
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 10,
                                                          fontFamily:
                                                              "Poppins"),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      width: 120,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFefefef),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Text(
                                                        "10 sec time",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Text(
                                                      "+10",
                                                      style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 10,
                                                          fontFamily:
                                                              "Poppins"),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text(
                            "Quit",
                            style: TextStyle(
                                fontFamily: "Poppins_Bold",
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            animate();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  finishDialog(context) async {
    print("mutiply" + mutiply.toString());
    dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: dialogAnimationController, curve: Curves.ease));
    if (answeredcorrect == totalquestion) {
      addedxp = addedxp +
          (answeredcorrect * mutiply * 1.5).toInt() +
          (prevansstreak * mutiply * 1.5).toInt() +
          (10);
    }
    if (answeredcorrect >= totalquestion / 2) {
      addedxp = addedxp +
          (answeredcorrect * mutiply).toInt() +
          (prevansstreak * mutiply).toInt() +
          (10);
    } else {
      addedxp = (addedxp / 2).toInt() +
          (answeredcorrect * mutiply).toInt() +
          (prevansstreak * mutiply).toInt() +
          (10);
    }

    updatelevel();

    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ScaleTransition(
            scale: scaleAnim,
            child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                contentPadding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                content: finish()),
          );
        });
  }

  updatelevel() {
    oldxp = globals.myUser.xp;
    globals.myUser.xp += addedxp;
    if (globals.myUser.xp > globals.currentlevelxp) {
      int newxp = globals.myUser.xp - globals.currentlevelxp;
      globals.currentlevelxp = globals.nextlevelxp;
      globals.myUser.level += 1;
      globals.myUser.xp = newxp;
      FirebaseFirestore.instance
          .collection("User")
          .doc(globals.myUser.firstname)
          .update({"level": globals.myUser.level.toInt()});
    } else {}
    FirebaseFirestore.instance
        .collection("User")
        .doc(globals.myUser.firstname)
        .update({"xp": globals.myUser.xp.toInt()});
  }

  confirmDialogue(context) async {
    dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: dialogAnimationController, curve: Curves.ease));

    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ScaleTransition(
            scale: scaleAnim,
            child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                contentPadding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                content: confirm()),
          );
        }).then((value) {
      if (counter <= 0) {
        timeDialog(context);
      }
    });
  }

  timeDialog(context) async {
    dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: dialogAnimationController, curve: Curves.ease));

    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ScaleTransition(
            scale: scaleAnim,
            child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: preview()),
          );
        });
  }

  preview() {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 60,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 20),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          "assets/trophy.svg",
                          width: 30,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Column(
                            children: [
                              Text("Score", style: TextStyle(fontSize: 13)),
                              Countup(
                                  duration: Duration(milliseconds: 500),
                                  begin: 0,
                                  end: globals.myUser.score.toDouble(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Poppins_Bold",
                                      color: Colors.grey[800]))
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          "assets/point.svg",
                          width: 30,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Column(
                            children: [
                              Text("Coins", style: TextStyle(fontSize: 13)),
                              Countup(
                                  duration: Duration(milliseconds: 500),
                                  begin: 0,
                                  end: globals.myUser.coins.toDouble(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Poppins_Bold",
                                      color: Colors.grey[800]))
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        WillPopScope(
          onWillPop: () {
            return new Future(() => false);
          },
          child: Container(
            margin: EdgeInsets.only(top: 70),
            padding: EdgeInsets.all(large ? 30 : 23),
            width: MediaQuery.of(context).size.width,
            height: large ? 300 : 250,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/hourglass.svg",
                  width: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "You run out of time",
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontFamily: "Poppins_Bold"),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        elevation: 7,
                        shadowColor: Colors.black38.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 15),
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/running.svg",
                                  width: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Quit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Poppins_bold",
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Material(
                        elevation: 7,
                        shadowColor: Colors.black38.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          focusColor: Colors.white,
                          onTap: () {
                            isfinish = true;
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/coins.svg",
                                  width: 40,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Continue",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Poppins_bold",
                                      color: Colors.grey[800]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  confirm() {
    return Container(
      padding: EdgeInsets.all(large ? 30 : 23),
      width: MediaQuery.of(context).size.width,
      height: large ? 300 : 280,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40)),
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/running.svg",
            width: 100,
            color: Colors.red,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Are you sure you want to quit?",
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
                fontFamily: "Poppins_Bold"),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: Material(
                  elevation: 7,
                  shadowColor: Colors.black38.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {
                      back = false;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 15),
                        ],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "NO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Poppins_bold",
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Material(
                  elevation: 7,
                  shadowColor: Colors.black38.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    focusColor: Colors.white,
                    onTap: () {
                      isfinish = true;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "YES",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Poppins_bold",
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  upload() async {
    globals.myUser.score += score.toInt();
    globals.myUser.coins +=
        answeredcorrect >= (totalquestion / 2) ? wincoins : 0;
    List<Map<String, Object>> subjects = [];
    globals.subjects.forEach((element) {
      if (element.name == widget.myScore.name) {
        element.prevscore = score.toInt();
        element.level += 1;
        widget.myScore = element;
      }
    });

    subjects.add(globals.subjects[0].toJson());
    subjects.add(globals.subjects[1].toJson());
    subjects.add(globals.subjects[2].toJson());
    subjects.add(globals.subjects[3].toJson());
    FirebaseFirestore.instance
        .collection("User")
        .doc(globals.myUser.firstname)
        .update({"coins": globals.myUser.coins});
    FirebaseFirestore.instance
        .collection("User")
        .doc(globals.myUser.firstname)
        .update({"score": globals.myUser.score});
    FirebaseFirestore.instance
        .collection("Score")
        .doc(globals.myUser.firstname)
        .set({"subjects": subjects}).then((value) => print("done"));

    setState(() {
      answeredcorrect = 0;
      anstreak = 0;
      prevansstreak = 0;
      current_question = 0;
      score = 0;
      tscore = 0;
      newscore = 0;
      restarted = true;
      level = widget.myScore.level;
      if (level <= 10) {
        totalquestion = 8;
      } else if (level >= 10 && level < 30) {
        totalquestion = 10;
      } else if (level >= 30 && level < 50) {
        totalquestion = 12;
      } else if (level >= 50) {
        totalquestion = 15;
      }
    });
    loadCategory();
    Navigator.pop(context);
    animate();
  }

  finish() {
    Animation<Offset> _positionAnimation;
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        confetti = true;
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _positionAnimation = Tween<Offset>(
      begin: const Offset(-1.8, 0),
      end: const Offset(0, 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Interval(0.4, 1.0, curve: Curves.elasticInOut)),
    );
    scaleOut = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    Animation<double> scaleOut2 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.4, 1.0, curve: Curves.ease)));
    Animation<double> scaleOut3 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.8, 1.0, curve: Curves.ease)));
    double singlecount = 100 / (globals.currentlevelxp) * 0.01;

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 80,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 20),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                color: colorList[globals.myUser.color],
                                shape: BoxShape.circle),
                            child: Center(
                                child: Text(
                              globals.myUser.initials.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins_Bold",
                                  fontSize: 20),
                            )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 170,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      " Level",
                                      style: TextStyle(
                                          fontFamily: "Poppins_Bold",
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "+" +
                                          (addedxp).toString() +
                                          "XP".toString(),
                                      style: TextStyle(
                                          fontFamily: "Poppins_Bold",
                                          fontSize: 12,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                width: 180,
                                child: LinearPercentIndicator(
                                  percent: singlecount * globals.myUser.xp,
                                  progressColor: const Color(0xffFED330),
                                  lineHeight: 20,
                                  animation: true,
                                  center: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (globals.myUser.level.toString()),
                                        style: TextStyle(
                                            fontFamily: "Poppins_Bold"),
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
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                width: 180,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Countup(
                                            begin: oldxp.toDouble(),
                                            end: oldxp >= globals.currentlevelxp
                                                ? globals.currentlevelxp
                                                : (globals.myUser.xp)
                                                    .toDouble(),
                                            style: TextStyle(
                                                fontFamily: "Poppins_Bold",
                                                fontSize: 10)),
                                        Text(
                                          ("/" +
                                              globals.currentlevelxp
                                                  .toString()),
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Countup(
                                          begin: (globals.currentlevelxp -
                                                  globals.myUser.xp)
                                              .toDouble(),
                                          end: (globals.currentlevelxp -
                                                  globals.myUser.xp)
                                              .toDouble(),
                                          style: TextStyle(
                                              fontFamily: "Poppins_Bold",
                                              fontSize: 10),
                                        ),
                                        Text(
                                          ("/left"),
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
        WillPopScope(
          onWillPop: () {
            return new Future(() => false);
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(large ? 30 : 23),
                margin: EdgeInsets.only(top: 95),
                width: MediaQuery.of(context).size.width,
                height: large ? 425 : 385,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      answeredcorrect == totalquestion
                          ? "PERFECT!"
                          : answeredcorrect >= (totalquestion / 2)
                              ? "PASSED!!"
                              : "YOU FAILED!",
                      style: TextStyle(
                          color: answeredcorrect == totalquestion
                              ? Colors.orangeAccent
                              : answeredcorrect >= (totalquestion / 2)
                                  ? Colors.green
                                  : Colors.red,
                          fontFamily: "Poppins_Bold",
                          fontSize: large ? 30 : 25),
                    ),
                    SizedBox(
                      height: large ? 10 : 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/trophy.svg",
                              width: large ? 40 : 35,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: large ? 10 : 8, horizontal: 5),
                              child: Column(
                                children: [
                                  Text(
                                    "Score",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Countup(
                                      duration: Duration(milliseconds: 1000),
                                      begin: 0,
                                      end: (answeredcorrect * 30).toDouble(),
                                      style: TextStyle(
                                          fontSize: large ? 35 : 30,
                                          fontFamily: "Poppins_Bold",
                                          height: 0.9))
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/point.svg",
                              width: large ? 40 : 35,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Column(
                                children: [
                                  Text(
                                    "Coins",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Countup(
                                      duration: Duration(milliseconds: 1000),
                                      begin: 0,
                                      end:
                                          answeredcorrect >= (totalquestion / 2)
                                              ? wincoins.toDouble()
                                              : 0,
                                      style: TextStyle(
                                          fontSize: large ? 35 : 30,
                                          fontFamily: "Poppins_Bold",
                                          height: 0.9))
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ScaleTransition(
                            scale: scaleOut,
                            child: Column(
                              children: [
                                Text(
                                  "+" +
                                      (answeredcorrect * mutiply)
                                          .toInt()
                                          .toString() +
                                      " XP",
                                  style: TextStyle(
                                      height: 0.8, color: Colors.green),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: large ? 10 : 5),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black38.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 15),
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "$answeredcorrect/" +
                                              "$totalquestion",
                                          style: TextStyle(
                                              fontFamily: "Poppins_Bold",
                                              fontSize: large ? 30 : 25,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Correct Questions",
                                          style: TextStyle(
                                              fontSize: large ? 10 : 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: ScaleTransition(
                            scale: scaleOut2,
                            child: Column(
                              children: [
                                Text(
                                  "+" +
                                      (prevansstreak * mutiply)
                                          .toInt()
                                          .toString() +
                                      "XP",
                                  style: TextStyle(
                                      height: 0.8, color: Colors.green),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black38.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 15),
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "$prevansstreak",
                                          style: TextStyle(
                                              fontFamily: "Poppins_Bold",
                                              fontSize: large ? 30 : 25,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text("Correct Answer in a row",
                                            style: TextStyle(
                                                fontSize: large ? 10 : 8,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: ScaleTransition(
                            scale: scaleOut3,
                            child: Column(
                              children: [
                                Text(
                                  "+10" + "XP",
                                  style: TextStyle(
                                      height: 0.8, color: Colors.green),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black38.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 15),
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "30",
                                          style: TextStyle(
                                              fontFamily: "Poppins_Bold",
                                              fontSize: large ? 30 : 25,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text("Seconds Average time",
                                            style: TextStyle(
                                                fontSize: large ? 10 : 8,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LinearPercentIndicator(
                      percent: answeredcorrect >= (totalquestion / 2)
                          ? 1
                          : (singlecount * answeredcorrect).toDouble(),
                      progressColor: const Color(0xffFED330),
                      lineHeight: 30,
                      animation: true,
                      center: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "level" + (widget.myScore.level.toString()),
                            style: TextStyle(fontFamily: "Poppins_Bold"),
                          ),
                          Text(
                            "level" + ((widget.myScore.level + 1).toString()),
                            style: TextStyle(
                                fontFamily: "Poppins_Bold",
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SlideTransition(
                      position: _positionAnimation,
                      child: GestureDetector(
                        onTap: () {
                          if (answeredcorrect >= (totalquestion / 2)) {
                            upload();
                          } else {
                            restart();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xff5DDD9D),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black38.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 15),
                            ],
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              answeredcorrect < (totalquestion / 2)
                                  ? Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    )
                                  : SizedBox(
                                      width: 0,
                                    ),
                              SizedBox(
                                width: answeredcorrect < (totalquestion / 2)
                                    ? 5
                                    : 0,
                              ),
                              Text(
                                answeredcorrect >= (totalquestion / 2)
                                    ? "Next"
                                    : "Retry",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Poppins_bold",
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  restart() {
    setState(() {
      prevansstreak = 0;

      current_question = 0;
      answeredcorrect = 0;
      score = 0;
      newscore = 0;
    });
    animate();

    Navigator.of(context).pop();
    loadCategory();
  }
}
