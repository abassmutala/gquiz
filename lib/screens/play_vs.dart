import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:gquiz/global/widgets.dart';
import 'package:gquiz/main.dart';
import 'package:gquiz/models/userplay.dart';
import 'package:gquiz/screens/battle.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:simple_animations/simple_animations.dart';

import 'home.dart';

class PlayVs extends StatefulWidget {
  bool bot;

  PlayVs({this.bot});

  @override
  _PlayVsState createState() => _PlayVsState();
}

AnimationController dialogAnimationController;
Timer timer, adder, player;
int counter, retrycount;
Color colorg1 = Colors.blueAccent[800];
Color colorg2 = Colors.deepPurple;
UserPlay opponentplay;
UserPlay myplay;
double percent;
bool clicked;
List<int> botplaystyle;

Color pColor = Colors.green;
bool done = false;
StateSetter _setState;
Animation<Offset> _slide_left,
    _slide_down,
    _slide_up,
    _slide_out,
    _slide_out2,
    _slide_out3,
    _slide_out4,
    _pointanimation;
bool aCorrect = false,
    bCorrect = false,
    cCorrect = false,
    dCorrect = false,
    point = false,
    scale = false,
    normal = false,
    opponentreplay = false,
    playagain = false;
AnimationController _controller,
    _pointController,
    _controllernew,
    _controllerout,
    _answercontroller;
Animation<double> _aScale, _bScale, _cScale, _dScale, scaleOut, scaleAnim;
bool visibleA = false,
    visibleB = false,
    visibleC = false,
    visibleD = false,
    streak = false,
    load = true,
    animating = true,
    opponentfinish = false;
String question = "",
    answerA = "",
    answerB = "",
    answerC = "",
    answerD = "",
    correctAnswer = "",
    diff = "",
    topic = "";
int index = 0;
int myScore = 0;
int opponentscore = 0;
Stream<DocumentSnapshot> mylisten;
StreamSubscription docStream;

class _PlayVsState extends State<PlayVs> with TickerProviderStateMixin {
  @override
  void dispose() {
    _controller.dispose();
    _pointController.dispose();
    _controllernew.dispose();
    _controllerout.dispose();
    _answercontroller.dispose();
    timer.cancel();

    _PlayVsState().dispose();
    _PlayVsState().reassemble();

    super.dispose();
  }

  void startTimer() {
    counter = 20;
    percent = 1.0;
    addtime();
    timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          if (counter < 10) {
            pColor = const Color(0xffFD4E4E);
          } else {
            pColor = Colors.white;
          }
          counter--;
        } else {
          animate();
          timer.cancel();
          return;
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
          return;
        }
      });
    });
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 120,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new CircularProgressIndicator(),
                new Text("Loading Questions"),
              ],
            ),
          ),
        );
      },
    );
  }

  listenChanges() async {
    await FirebaseFirestore.instance
        .collection("PlayTable")
        .doc(globals.table)
        .snapshots()
        .listen((event) {
      setState(() {
        opponentplay = UserPlay.fromJson(Map<String, dynamic>.from(
            event[globals.opponentProfile.firstname]));
        opponentscore = opponentplay.correct * 30;
        if (opponentplay.question == 10) {
          opponentfinish = true;
          return;
        }
      });
      _setState(() {});
    });
  }

  playbot() {
    int opprank = globals.opponentProfile.rank;
    int opplevel = globals.opponentProfile.level;
    List<int> style0 = [1, 0, 1, 1, 1, 1, 0, 1, 1, 1];
    List<int> style1 = [1, 0, 1, 1, 0, 1, 0, 1, 1, 1];
    List<int> style2 = [1, 0, 1, 0, 1, 1, 0, 1, 0, 0];
    List<int> style3 = [0, 0, 1, 1, 0, 1, 0, 1, 0, 0];
    List<List> styles = [];
    if (opprank < 50) {
      styles.add(style1);
      styles.add(style2);
      styles.add(style3);
    } else if (opprank >= 50 && opprank < 100) {
      styles.add(style0);
      styles.add(style1);
      styles.add(style2);
    } else if (opprank >= 100 && opprank < 200) {
      styles.add(style0);
      styles.add(style1);
    } else if (opprank >= 200) {
      styles.add(style0);
    }
    styles.shuffle();
    styles.shuffle();
    List<int> opstyle = styles[0];
    botplaystyle = opstyle;
    botaction();
  }

  botaction() {
    botplaystyle.shuffle();
    botplaystyle.shuffle();
    List<int> playtime = [5, 5, 8, 6, 4, 12, 7, 11, 9, 6, 5, 5, 4, 5];
    playtime.shuffle();
    playtime.shuffle();
    Future.delayed(Duration(seconds: playtime[0]), () {
      if (globals.opponentProfile == null) {
        return;
      }
      if (opponentplay.question < 10) {
        FirebaseFirestore.instance
            .collection("PlayTable")
            .doc(globals.table)
            .update({
          globals.opponentProfile.firstname + ".correct":
              opponentplay.correct += botplaystyle[0]
        });
        FirebaseFirestore.instance
            .collection("PlayTable")
            .doc(globals.table)
            .update({
          globals.opponentProfile.firstname + ".question":
              opponentplay.question += 1
        }).then((value) {
          botaction();
          setState(() {});
        });
      } else {
        return;
      }
    });
  }

  @override
  void initState() {
    aCorrect = false;
    bCorrect = false;
    cCorrect = false;
    dCorrect = false;
    point = false;
    scale = false;
    normal = false;
    opponentreplay = false;
    playagain = false;
    botplaystyle = [];
    clicked = false;
    percent = 0.0;
    index = 0;
    if (widget.bot == null) {
    } else {
      playbot();
    }
    opponentplay = globals.opponentPlay;
    myplay = globals.myPlay;
    startTimer();
    listenChanges();
    _answercontroller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _pointController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

    setState(() {
      animateIn();
      load = true;
      _controllernew = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      )..forward();
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
    _slide_left = Tween<Offset>(
      begin: const Offset(5.00, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));

    question = globals.globalQuestions[index].question;
    answerA = globals.globalQuestions[index].answerA.trim();
    answerB = globals.globalQuestions[index].answerB.trim();
    answerC = globals.globalQuestions[index].answerC.trim();
    answerD = globals.globalQuestions[index].answerD.trim();
    correctAnswer = globals.globalQuestions[index].correctAnswer;
    topic = globals.globalQuestions[index].topic.trim();

    super.initState();
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

  changeQuestions() {
    if (globals.globalQuestions.isEmpty) {
      return;
    }
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
        index += 1;
        changeQuestions();
        print("change");
      });
      questionIn();
      Future.delayed(Duration(milliseconds: 2000), () {
        animateIn();
      });
    });
  }

  animateIn() {
    reset();
    setState(() {
      visibleA = true;
      visibleB = true;
      visibleC = true;
      visibleD = true;

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

  correct() {
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

  answerClicked(String answer) async {
    counter = 0;

    if (!clicked) {
      clicked = true;
    } else {
      return;
    }
    setState(() {
      counter = 20;
      percent = 1;
    });

    correct();
    //animate();
    if (answer == correctAnswer) {
      myplay.correct += 1;
      setState(() {
        myScore += 30;
      });

      FirebaseFirestore.instance
          .collection("PlayTable")
          .doc(globals.table)
          .update({globals.myUser.firstname + ".correct": myplay.correct});
    }
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
    Future.delayed(Duration(milliseconds: 1000), () async {
      setState(() {
        myplay.question += 1;
      });
      FirebaseFirestore.instance
          .collection("PlayTable")
          .doc(globals.table)
          .update({globals.myUser.firstname + ".question": myplay.question});
      if (myplay.question >= 10) {
        finishDialog(context);
      } else {
        setState(() {
          clicked = false;
        });

        animate();
      }
    });
  }

  reset() {
    clicked = false;

    setState(() {
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

  finishDialog(context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  _setState = setState;
                  return preview();
                },
              ));
        }).then((value) async => {});
  }

  preview() {
    Animation<Offset> _positionAnimation;
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {});
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                                    width: 150,
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
                                          "+",
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
                                            ((globals.myUser.level + 1)
                                                .toString()),
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
                                                begin: 0,
                                                end: 5,
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
            SizedBox(
              height: 350,
            )
          ],
        ),
        WillPopScope(
          onWillPop: () {
            return new Future(() => false);
          },
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(large ? 30 : 23),
                    margin: EdgeInsets.only(top: 95),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            !opponentfinish
                                ? SizedBox()
                                : Text(
                                    myScore > opponentscore
                                        ? "WON"
                                        : myScore < opponentscore
                                            ? "LOST"
                                            : "DRAW",
                                    style: TextStyle(
                                        color: myScore > opponentscore
                                            ? Colors.green
                                            : myScore < opponentscore
                                                ? Colors.grey
                                                : Colors.red,
                                        fontFamily: "Poppins_Bold",
                                        fontSize: 30),
                                  ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  !opponentfinish
                                      ? SizedBox()
                                      : Container(
                                          height: 30,
                                          child: myScore > opponentscore
                                              ? SvgPicture.asset(
                                                  "assets/crown.svg")
                                              : SizedBox()),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 80,
                                    height: 80,
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
                                    height: 3,
                                  ),
                                  Text("@" + globals.myUser.firstname),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/trophy.svg',
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        myScore.toString(),
                                        style: TextStyle(
                                            fontFamily: "Poppins_Bold",
                                            fontSize: 20),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: !opponentfinish
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                            height: 30,
                                            child: myScore < opponentscore
                                                ? SvgPicture.asset(
                                                    "assets/crown.svg")
                                                : SizedBox()),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: colorList[globals
                                                  .opponentProfile.color],
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Text(
                                            globals.opponentProfile.initials
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins_Bold",
                                                fontSize: 20),
                                          )),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text("@" +
                                            globals.opponentProfile.firstname),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/trophy.svg',
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              opponentscore.toString(),
                                              style: TextStyle(
                                                  fontFamily: "Poppins_Bold",
                                                  fontSize: 20),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        !opponentfinish
                            ? SizedBox()
                            : SlideTransition(
                                position: _positionAnimation,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            FirebaseFirestore.instance
                                                .collection("PlayTable")
                                                .doc(globals.table)
                                                .delete();
                                            opponentscore = 0;
                                            opponentfinish = false;
                                            globals.opponentProfile = null;
                                            myplay = null;
                                            opponentplay = null;
                                            globals.opponentPlay = null;
                                            globals.opponentProfile = null;
                                            globals.globalQuestions = [];
                                            globals.bot = false;

                                            reset();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff5DDD9D),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black38
                                                          .withOpacity(0.1),
                                                      spreadRadius: 5,
                                                      blurRadius: 15),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Text(
                                                "Quit",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Poppins_Bold"),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black38
                                                        .withOpacity(0.1),
                                                    spreadRadius: 5,
                                                    blurRadius: 15),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Text(
                                              "Retry",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Poppins_Bold"),
                                              textAlign: TextAlign.center,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: const Color(0xff4D7DF9),
              image: DecorationImage(image: AssetImage("assets/parrten.png"))),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      confirmDialogue(context);
                    },
                    child: Container(
                      child: Row(
                        children: [SvgPicture.asset("assets/backbutton.svg")],
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
                          Text("Battle Mode",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins_Bold",
                                  fontSize: 20)),
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: large ? 10 : 10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Text(
                              myplay.question.toString() + "/10",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            child: Text(
                              opponentplay.question.toString() + "/10",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 90,
                        height: large ? 70 : 65,
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
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
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
                                child: Row(
                                  children: [
                                    Container(
                                      width: large ? 55 : 45,
                                      height: large ? 55 : 45,
                                      decoration: BoxDecoration(
                                        color: colorList[globals.myUser.color],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          globals.myUser.initials.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: large ? 20 : 18,
                                              fontFamily: "Poppins_Bold",
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "@" + globals.myUser.firstname,
                                            style: TextStyle(
                                                fontSize: 14, height: 0.8),
                                          ),
                                          Text(
                                            myScore.toString(),
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
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(60),
                                      bottomRight: Radius.circular(60)),
                                  gradient: new LinearGradient(
                                      colors: [
                                        const Color(0xFF88FFC5),
                                        const Color(0xFF41E093),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "@" +
                                                globals
                                                    .opponentProfile.firstname,
                                            style: TextStyle(
                                                fontSize: 14, height: 0.8),
                                          ),
                                          Text(
                                            opponentscore.toString(),
                                            style: TextStyle(
                                              fontSize: large ? 18 : 15,
                                              fontFamily: "Poppins_Bold",
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: large ? 55 : 45,
                                      height: large ? 55 : 45,
                                      decoration: BoxDecoration(
                                        color: colorList[
                                            globals.opponentProfile.color],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          globals.opponentProfile.initials
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: large ? 20 : 18,
                                              fontFamily: "Poppins_Bold",
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
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
              ),
              Container(
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
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: large ? 25 : 18),
                    height: large ? 130 : 100,
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
                              child: Text(
                                question,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: large ? 23 : 20,
                                    fontFamily: "Poppins_Bold",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
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
                                    "+23",
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
            : Container(
                height: double.infinity,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: large ? 350 : 300,
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
                                  child: answerButton(
                                      answerA, context, aCorrect))),
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
                                  child: answerButton(
                                      answerB, context, bCorrect))),
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
                                  child: answerButton(
                                      answerC, context, cCorrect))),
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
                                  child: answerButton(
                                      answerD, context, dCorrect))),
                        )),
                  ],
                )),
              ),
      ],
    ));
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
      if (counter <= 0) {}
    });
  }

  uploadscore() {}

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
}
