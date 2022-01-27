import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gquiz/spin.dart';
import 'package:gquiz/models/score.dart';
import 'package:gquiz/screens/battle.dart';
import 'package:gquiz/screens/home.dart';
import 'package:flutter/services.dart';
import 'package:gquiz/screens/scorebaord.dart';
import 'package:gquiz/screens/startup_form.dart';
import 'package:gquiz/screens/userprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/home.dart';
import 'package:gquiz/global/global.dart' as globals;

import 'models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  Admob.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

bool change, exist = false, form = false;
SharedPreferences _prefs;

getProfile() async {
  await FirebaseFirestore.instance
      .collection("User")
      .doc(_prefs.getString("firstname"))
      .snapshots()
      .listen((event) {
    listenxp();
    getscore();
    User myNew = User();

    FirebaseFirestore.instance
        .collection('Quotes')
        .doc("all")
        .get()
        .then((value) {
      List<Object> qoutes = value["quotes"];
      print(qoutes.length.toString());
      print(qoutes[1].toString());
      globals.qoutes = qoutes;
    });

    myNew = new User.fromJson(event.data());
    globals.myUser = myNew;
    print(myNew.firstname);
  });
}

getscore() async {
  await FirebaseFirestore.instance
      .collection("Score")
      .doc(_prefs.getString("firstname"))
      .get()
      .then((value) async {
    if (value.exists) {
      List<Score> allsubjects = [];
      List<dynamic> subjects = value["subjects"];
      subjects.forEach((element) {
        Map<String, dynamic> nes = Map<String, dynamic>.from(element);
        Score myscore = Score.fromJson(nes);
        allsubjects.add(myscore);
        print(myscore.name);
      });
      globals.subjects = allsubjects;
    } else {
      List<Map<String, Object>> subjects = [];
      Score english = Score(
          name: "English",
          level: 1,
          tscore: 0,
          prevscore: 0,
          tquestions: 8,
          prevs: "",
          plays: "");
      Score maths = Score(
          name: "Maths",
          level: 1,
          tscore: 0,
          prevscore: 0,
          tquestions: 8,
          prevs: "",
          plays: "");
      Score science = Score(
          name: "Science",
          level: 1,
          tscore: 0,
          prevscore: 0,
          tquestions: 8,
          prevs: "",
          plays: "");
      Score social = Score(
          name: "Social",
          level: 1,
          tscore: 0,
          prevscore: 0,
          tquestions: 8,
          prevs: "",
          plays: "");
      subjects.add(english.toJson());
      subjects.add(maths.toJson());
      subjects.add(science.toJson());
      subjects.add(social.toJson());
      globals.subjects.add(english);
      globals.subjects.add(maths);
      globals.subjects.add(science);
      globals.subjects.add(social);

      await FirebaseFirestore.instance
          .collection("Score")
          .doc(_prefs.getString("firstname"))
          .set({"subjects": subjects}).then((value) => print("done"));
    }
  });
}

listenxp() async {
  await FirebaseFirestore.instance
      .collection("XP")
      .doc("user")
      .get()
      .then((value) {
    globals.currentlevelxp = value["level" + globals.myUser.level.toString()];
    globals.nextlevelxp =
        value["level" + (globals.myUser.level + 1).toString()];
  });
}

class _MyAppState extends State<MyApp> {
  bool isLoading;

  @override
  Future<void> initState() {
    getprefs();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<int> getprefs() async {
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.getString('firstname') == null) {
      print("null");

      setState(() {
        form = true;
      });
    } else {
      print("not null");
      getProfile();
      Future.delayed(Duration(milliseconds: 5000), () {
        setState(() {
          changeScreen();
        });
      });
    }
  }

  void changeScreen() {
    setState(() {
      exist = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    void _update(SharedPreferences prefs) {
      setState(() {
        form = false;
        _prefs = prefs;
        getprefs();
      });
    }

    return KeyedSubtree(
      key: UniqueKey(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Poppins'),
        home: !exist && !form
            ? Startup()
            : form
                ? StartUpForm(
                    update: _update,
                  )
                : MyBottomNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Startup extends StatelessWidget {
  const Startup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(80),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xffE9CC6D),
      child: const Center(
        child: Image(image: AssetImage("assets/animation.gif")),
      ),
    );
  }
}

class MyBottomNavigation extends StatefulWidget {
  int index;
  MyBottomNavigation({this.index});
  @override
  _MyBottomNavigationState createState() => _MyBottomNavigationState();
}

bool _profile = false;

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  void _update(bool profile) {
    setState(() => _profile = profile);
  }

  int _currentIndex = 0;

  bool battlemood = false;
  // bool one=true, two=false,three=false,four=false;

  void onTappedBar(int index) {
    setState(() {
      if (index == 3) {
        setState(() {
          battlemood = true;
        });
      } else {
        setState(() {
          battlemood = false;
        });
      }
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      _profile
          ? const UserProfile()
          : Home(
              update: _update,
            ),
      SpinngWheel(),
      Battle(),
      const Scoreboard()
    ];

    return Scaffold(
      body: Scaffold(
        backgroundColor:
            _currentIndex == 3 ? const Color(0xff5DE2A2) : Colors.white,
        appBar: _currentIndex == 3
            ? AppBar(
                elevation: 0,
                backgroundColor: const Color(0xff5DE2A2),
                title: Text("Leaderboard",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins_Bold",
                        fontSize: 25)),
              )
            : _currentIndex == 2
                ? AppBar(
                    elevation: 0,
                    backgroundColor: const Color(0xffC4D5FE),
                    title: Text("Battle",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins_Bold",
                            fontSize: 25)),
                  )
                : _profile
                    ? AppBar(
                        leading: GestureDetector(
                            onTap: () {
                              _update(false);
                            },
                            child: Container(
                                padding: EdgeInsets.all(15),
                                child: SvgPicture.asset(
                                  "assets/backbutton.svg",
                                  height: 20,
                                ))),
                        elevation: 0,
                        backgroundColor: const Color(0xffFED330),
                        title: Text("Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins_Bold",
                                fontSize: 25)),
                      )
                    : null,
        body: Stack(
          children: [
            SingleChildScrollView(child: _children[_currentIndex]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 20),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      onTap: onTappedBar,
                      currentIndex: _currentIndex,
                      selectedItemColor: const Color(0xff9F9F9F),
                      iconSize: 25,
                      unselectedItemColor: const Color(0xff9F9F9F),
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Container(
                              width: large
                                  ? 55
                                  : normal
                                      ? 45
                                      : 40,
                              height: large
                                  ? 55
                                  : normal
                                      ? 45
                                      : 40,
                              decoration: BoxDecoration(
                                  color: _currentIndex == 0
                                      ? Colors.grey[200]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(55)),
                              padding: EdgeInsets.all(large ? 15 : 10),
                              child: SvgPicture.asset(
                                "assets/home.svg",
                                height: 25,
                                color: Colors.grey,
                              )),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          icon: Container(
                              width: large
                                  ? 55
                                  : normal
                                      ? 45
                                      : 40,
                              height: large
                                  ? 55
                                  : normal
                                      ? 45
                                      : 40,
                              decoration: BoxDecoration(
                                  color: _currentIndex == 1
                                      ? Colors.grey[200]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(55)),
                              padding: EdgeInsets.all(large ? 15 : 10),
                              child: SvgPicture.asset(
                                "assets/cart.svg",
                                height: 25,
                                color: Colors.grey,
                              )),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          icon: Container(
                              width: large
                                  ? 55
                                  : normal
                                      ? 45
                                      : 40,
                              height: large
                                  ? 55
                                  : normal
                                      ? 45
                                      : 40,
                              decoration: BoxDecoration(
                                  color: _currentIndex == 2
                                      ? Colors.grey[200]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(55)),
                              padding: EdgeInsets.all(large ? 15 : 10),
                              child: SvgPicture.asset(
                                "assets/online.svg",
                                height: 25,
                                color: Colors.grey,
                              )),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          icon: Container(
                              width: large
                                  ? 55
                                  : normal
                                      ? 45
                                      : 40,
                              height: large
                                  ? 55
                                  : normal
                                      ? 45
                                      : 40,
                              decoration: BoxDecoration(
                                  color: _currentIndex == 3
                                      ? Colors.grey[200]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(55)),
                              padding: EdgeInsets.all(large
                                  ? 15
                                  : normal
                                      ? 10
                                      : 8),
                              child: SvgPicture.asset(
                                "assets/scoreboard.svg",
                                height: 25,
                                color: Colors.grey,
                              )),
                          label: "",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
