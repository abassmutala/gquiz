import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gquiz/constants/app_colors.dart';
import 'package:gquiz/constants/app_themes.dart';
import 'package:gquiz/constants/constants.dart';
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
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

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

      globals.qoutes = qoutes;
    });

    myNew = new User.fromJson(event.data());
    globals.myUser = myNew;
    debugPrint(myNew.firstname);
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
      for (var element in subjects) {
        Map<String, dynamic> nes = Map<String, dynamic>.from(element);
        Score myscore = Score.fromJson(nes);
        allsubjects.add(myscore);
      }
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
          .set({"subjects": subjects}).then((value) => debugPrint("done"));
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
  initState() {
    super.initState();
    getprefs();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    super.dispose();
  }

  getprefs() async {
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.getString('firstname') == null) {
      setState(() {
        form = true;
      });
    } else {
      getProfile();
      Future.delayed(const Duration(milliseconds: 5000), () {
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
    void _update(SharedPreferences prefs) {
      setState(() {
        form = false;
        _prefs = prefs;
        getprefs();
      });
    }

    return MaterialApp(
      theme: gQuizLightTheme,
      home: !exist && !form
          ? const Startup()
          : form
              ? StartUpForm(
                  update: _update,
                )
              : const MyBottomNavigation(),
      debugShowCheckedModeBanner: false,
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
      color: kGQuizLaunchBG,
      child: const Center(
        child: Image(image: AssetImage("assets/animation.gif")),
      ),
    );
  }
}

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({Key key}) : super(key: key);

  @override
  _MyBottomNavigationState createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  void _update(bool profile) {
    setState(() => _profile = profile);
  }

  int _currentIndex = 0;
  bool battlemood = false;
  bool _profile = false;

  void onTappedBar(int index) {
    setState(() {
      if (index == 3) {
        setState(() {
          battlemood = true;
        });
      }
      _currentIndex = index;
    });
  }

  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(name: '', icon: 'assets/home.svg', index: 0),
    BottomNavItem(name: '', icon: 'assets/cart.svg', index: 1),
    BottomNavItem(name: '', icon: 'assets/online.svg', index: 2),
    BottomNavItem(name: '', icon: 'assets/scoreboard.svg', index: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    List<Widget> _children = [
      _profile
          ? const UserProfile()
          : Home(
              update: _update,
            ),
      SpinngWheel(),
      const Battle(),
      const Scoreboard()
    ];

    return Scaffold(
      appBar: _profile
          ? AppBar(
              leading: GestureDetector(
                  onTap: () {
                    _update(false);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(
                        "assets/backbutton.svg",
                        height: 20,
                      ))),
              elevation: 0,
              backgroundColor: const Color(0xffFED330),
              title: Text("Profile", style: theme.textTheme.headline6),
            )
          : null,
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Corners.xlRadius,
            topRight: Corners.xlRadius,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black38.withOpacity(0.1),
              // spreadRadius: 5,
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Corners.xlRadius,
            topRight: Corners.xlRadius,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTappedBar,
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xff9F9F9F),
            iconSize: 25,
            unselectedItemColor: const Color(0xff9F9F9F),
            items: bottomNavItems
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: _currentIndex == 0
                            ? Colors.grey[200]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(55),
                      ),
                      padding: const EdgeInsets.all(
                        10,
                      ),
                      child: SvgPicture.asset(
                        item.icon,
                        height: 25,
                        color: Colors.grey,
                      ),
                    ),
                    label: item.name,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final String name;
  final String icon;
  final int index;

  BottomNavItem({this.name, this.icon, this.index});
}
