import 'package:admob_flutter/admob_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gquiz/constants/constants.dart';
import 'package:gquiz/dialogue/hero_dialogue.dart';
import 'package:gquiz/global/widgets.dart';
import 'package:gquiz/main.dart';
import 'package:gquiz/models/score.dart';
import 'package:gquiz/screens/category.dart';
import 'package:gquiz/screens/play.dart';
import 'package:gquiz/screens/play_vs.dart';
import 'package:gquiz/screens/startup_form.dart';
import 'package:gquiz/services/soundService.dart';
import 'package:gquiz/spin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:gquiz/dialogue/next.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial/tutorial.dart';

import '../adhelper.dart';

SoundService soundService = SoundService();

class Home extends StatefulWidget {
  final ValueChanged<bool> update;

  Home({this.update});
  @override
  _HomeState createState() => _HomeState();
}

bool test = false;

final _profile = GlobalKey();
final _firstitem = GlobalKey();
final _seconditem = GlobalKey();
final _thirdItem = GlobalKey();
final _fourthitem = GlobalKey();
List<TutorialItens> itens = [];
List<TutorialItens> itens2 = [];
double mypadding = 20;
double text, texBig = 40, textNormal = 20;
bool large = false, normal = false, small = false;
bool opencard = false;
String qoute = "";

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController _controller, _controller2;
  Animation<double> _scale, _scale1, _scale2, _scale3;
  Animation<Offset> _positionAnimation;

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return "Evening";
  }

  inputlevels() async {
    int xp = 100;
    int count = 2;
    for (var i = 0; i < 200; i++) {
      await FirebaseFirestore.instance.collection("XP").doc("user").update(
          {"level$count": xp + (xp / (count / 1.5)).toInt()}).then((value) {
        count++;
        xp = xp + (xp / (count / 1.5)).toInt();
      });
    }
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
    itens.clear();
    itens.addAll({
      TutorialItens(
          globalKey: _firstitem,
          touchScreen: true,
          top: 200,
          left: 50,
          children: [
            Text(
              "Select A Category to start playing",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 500,
            )
          ],
          widgetNext: custnext(),
          shapeFocus: ShapeFocus.oval),
    });
    itens2.addAll({
      TutorialItens(
          globalKey: _seconditem,
          touchScreen: true,
          top: 200,
          left: 50,
          children: [
            Text(
              "This shows the total questions you've answers in the category",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 500,
            )
          ],
          widgetNext: custnext(),
          shapeFocus: ShapeFocus.oval),
      TutorialItens(
          globalKey: _thirdItem,
          touchScreen: true,
          top: 200,
          left: 50,
          children: [
            Text(
              "You will be rewarded after passing each level",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 500,
            )
          ],
          widgetNext: custnext(),
          shapeFocus: ShapeFocus.oval),
      TutorialItens(
          globalKey: _fourthitem,
          touchScreen: true,
          top: 200,
          left: 50,
          children: [
            Text(
              "Click next to start playing",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 500,
            )
          ],
          widgetNext: custnext(),
          shapeFocus: ShapeFocus.oval)
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      Tutorial.showTutorial(context, itens);
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    //scale animations
    _scale = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _scale1 = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.2, 1.0, curve: Curves.ease)));
    _scale2 = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.4, 1.0, curve: Curves.ease)));
    _scale3 = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.ease)));

    //slide animations
    _positionAnimation = Tween<Offset>(
      begin: const Offset(-1.2, 0),
      end: const Offset(0, 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller2,
          curve: Interval(0.4, 1.0, curve: Curves.elasticInOut)),
    );
    soundService.playLocalAsset();
    super.initState();
  }

  @override
  void dispose() {
    if (opencard) {
      _AddTodoCardState().dispose();
      // controller.dispose();
      _controller2.dispose();
      opencard = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double screensize = MediaQuery.of(context).size.width;
    globals.qoutes.shuffle();
    qoute = globals.qoutes[1].toString();
    if (screensize < 380) {
      texBig = 28;
      small = true;
      mypadding = 20;
    } else if (screensize < 400) {
      texBig = 35;
      mypadding = 30;
      normal = true;
    } else {
      mypadding = 40;
      large = true;
    }

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: mypadding),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color(0xffFED330),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: "profile",
                      child: GestureDetector(
                        onTap: () {
                          widget.update(true);
                        },
                        child: Container(
                          child: Center(
                              child: Text(
                            globals.myUser.initials.toUpperCase(),
                            style: theme.textTheme.headline5
                                .copyWith(color: Colors.white, fontSize: 20),
                          )),
                          width: large ? 60 : 50,
                          height: large ? 60 : 50,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(globals.myUser.color),
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black38.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/trophy.svg",
                                width: large ? 30 : 28,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: Column(
                                  children: [
                                    Text("Score",
                                        style: theme.textTheme.subtitle1),
                                    Countup(
                                      duration: TimeLengths.halfSec,
                                      begin: 0,
                                      end: globals.myUser.score.toDouble(),
                                      style: theme.textTheme.subtitle1,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Spacing.horizontalSpace12,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/point.svg",
                                width: large ? 30 : 28,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: Column(
                                  children: [
                                    Text("Coins",
                                        style: theme.textTheme.subtitle1),
                                    Countup(
                                      duration: TimeLengths.halfSec,
                                      begin: 0,
                                      end: globals.myUser.coins.toDouble(),
                                      style: theme.textTheme.subtitle1,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacing.verticalSpace4,
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Good  ${greeting()}',
                      style: theme.textTheme.headline5,
                    ),
                  ),
                ),
                Spacing.verticalSpace12,
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 70,
                  child: Text(
                    '"$qoute"',
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    style: theme.textTheme.subtitle1,
                  ),
                ),
                Spacing.verticalSpace12,
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: large
                ? 620
                : normal
                    ? 480
                    : 450,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 20),
                      ],
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Choose a Subject",
                    style: theme.textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: large
                          ? 360
                          : normal
                              ? 280
                              : 265),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: mypadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          key: _firstitem,
                          child: CategoryCard(
                              text: 'Science',
                              icon: "science",
                              bColor: const Color(0xff5DE2A2),
                              mColor: const Color(0xffE5FFF2),
                              box: false,
                              animation: _scale),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        CategoryCard(
                          text: 'Maths',
                          icon: "maths",
                          bColor: const Color(0xffA7E3E8),
                          mColor: const Color(0xff4ABBC4),
                          box: false,
                          animation: _scale1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: large ? 18 : 13,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: mypadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CategoryCard(
                            text: 'English',
                            icon: "english",
                            bColor: const Color(0xffFED330),
                            mColor: const Color(0xffFFEEAF),
                            box: false,
                            animation: _scale2),
                        SizedBox(
                          width: 20,
                        ),
                        CategoryCard(
                            text: 'Social Studies',
                            icon: "social",
                            bColor: const Color(0xff4E7FFF),
                            mColor: const Color(0xffC4D5FF),
                            box: true,
                            animation: _scale3)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: large ? 18 : 13,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: SlideTransition(
                      position: _positionAnimation,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/random.svg"),
                        label: Text(
                          'Random',
                          style: theme.textTheme.button,
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String text;
  final String icon;
  final Color bColor;
  final Color mColor;
  final bool box;
  final Animation<double> animation;

  const CategoryCard(
      {Key key,
      this.text,
      this.icon,
      this.bColor,
      this.mColor,
      this.box,
      this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Hero(
      tag: "image$text",
      child: ScaleTransition(
        scale: animation,
        child: Container(
          width: large
              ? 150
              : normal
                  ? 140
                  : 120,
          padding: EdgeInsets.symmetric(vertical: large ? 10 : 6),
          decoration: BoxDecoration(
            color: bColor,
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
              onTap: () {
                Future.delayed(TimeLengths.fullSec * 2, () {
                  Tutorial.showTutorial(context, itens2);
                });
                globals.category = text;
                soundService.Click1();
                soundService.dialog();
                Navigator.of(context).push(HeroDialogRoute(
                    builder: (context) => test
                        ? SpinngWheel()
                        : AddTodoCard(
                            text: text,
                            icon: icon,
                            mColor: mColor,
                            bColor: bColor,
                            mScore: globals.subjects[text == 'English'
                                ? 0
                                : text == 'Maths'
                                    ? 1
                                    : text == 'Science'
                                        ? 2
                                        : 3])));
              },
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: box ? EdgeInsets.all(5) : EdgeInsets.all(10),
                        child: Center(
                            child: SvgPicture.asset(
                          "assets/icons/$icon.svg",
                          height: small ? 50 : 75,
                        )),
                      ),
                      box
                          ? SizedBox(
                              height: 0,
                            )
                          : SizedBox(
                              height: small ? 3 : 10,
                            ),
                      Container(
                        width: 160,
                        child: Text(
                          text,
                          style: theme.textTheme.headline5.copyWith(
                            color: mColor,
                            fontSize: 29,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      box
                          ? SizedBox(
                              height: 0,
                            )
                          : SizedBox(
                              height: 15,
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Score getScore(String name) {
  globals.subjects.forEach((element) {
    if (element.name == name) {
      print(element.name);
      return element;
    }
  });
}

class AddTodoCard extends StatefulWidget {
  final String text, icon;
  final Color bColor;
  final Color mColor;
  final Score mScore;

  AddTodoCard({this.text, this.icon, this.mColor, this.bColor, this.mScore});

  @override
  _AddTodoCardState createState() => _AddTodoCardState();
}

class _AddTodoCardState extends State<AddTodoCard> {
  List<DocumentSnapshot> documents = [];
  int count;
  bool questionloaded = false;
  int level;
  int questions;

  getQuestions() async {
    opencard = true;
    count = 0;
    level = widget.mScore.level;
    if (level <= 10) {
      questions = 8;
    } else if (level >= 10 && level < 30) {
      questions = 10;
    } else if (level >= 30 && level < 50) {
      questions = 12;
    } else if (level >= 50) {
      questions = 15;
    }
    print(widget.mScore.name);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Question")
        .doc(widget.text != "Social Studies" ? widget.text : "Social")
        .collection("Difficulty")
        .get();

    snapshot.docs.forEach((document) {
      documents.add(document);
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        questionloaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getQuestions();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Hero(
                      tag: "image${widget.text}",
                      child: Container(
                        width: 350,
                        child: Material(
                          color: widget.bColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Wrap(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/${widget.icon}.svg",
                                              height: 30,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.text == "Social Studies"
                                                  ? "Social"
                                                  : widget.text,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontFamily: "Poppins_Bold",
                                                  color: widget.mColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Container(
                                            key: _seconditem,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 25),
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
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "0/$questions",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins_Bold",
                                                      fontSize: 30,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  "Total Questions",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Container(
                                            key: _thirdItem,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 25),
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
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/point.svg",
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      "30",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Poppins_Bold",
                                                          fontSize: 30,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "Reward",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LinearPercentIndicator(
                                    percent: 0.1,
                                    progressColor: const Color(0xffFED330),
                                    lineHeight: 30,
                                    animation: true,
                                    center: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "level" +
                                              (widget.mScore.level).toString(),
                                          style: TextStyle(
                                              fontFamily: "Poppins_Bold"),
                                        ),
                                        Text(
                                          "level" +
                                              ((widget.mScore.level + 1)
                                                  .toString()),
                                          style: TextStyle(
                                              fontFamily: "Poppins_Bold",
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 60,
                                    child: !questionloaded
                                        ? Container(
                                            width: 60,
                                            height: 60,
                                            padding: EdgeInsets.all(10),
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                            ))
                                        : GestureDetector(
                                            key: _fourthitem,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Play(
                                                            documents:
                                                                documents,
                                                            myScore:
                                                                widget.mScore,
                                                            ttq: questions,
                                                          )));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Next",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            "Poppins_bold"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 80,
                  child: AdmobBanner(
                    adUnitId: AdHelper.bannerAdUnitId,
                    adSize: AdmobBannerSize.BANNER,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
