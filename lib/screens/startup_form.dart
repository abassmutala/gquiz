import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gquiz/main.dart';
import 'package:gquiz/models/user.dart';
import 'package:gquiz/screens/home.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

bool validated = false;
bool hiden = true;
bool page = false;
Color myColor = null;
User myUser = User();
bool loading = false;
final _formKey = GlobalKey<FormState>();
List<String> suggestnames = [];

class StartUpForm extends StatefulWidget {
  final ValueChanged<SharedPreferences> update;

  StartUpForm({this.update});

  @override
  _StartUpFormState createState() => _StartUpFormState();
}

class _StartUpFormState extends State<StartUpForm> {
  List<Widget> getpages() {
    return [
      welcome(),
      myForm(),
      Profile(widget.update, loading),
    ];
  }

  Widget welcome() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/startback.png"), fit: BoxFit.cover)),
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  large
                      ? SizedBox(
                          height: 60,
                        )
                      : normal
                          ? SizedBox(
                              height: 50,
                            )
                          : SizedBox(
                              height: 30,
                            ),
                  SvgPicture.asset("assets/logo.svg"),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Welcome,",
                    style: TextStyle(
                        fontSize: large
                            ? 40
                            : normal
                                ? 35
                                : 25,
                        fontFamily: "Poppins_Bold"),
                  ),
                  Text(
                    "to the",
                    style: TextStyle(
                        fontSize: large
                            ? 40
                            : normal
                                ? 35
                                : 25,
                        fontFamily: "Poppins_Bold",
                        height: 0.8),
                  ),
                  Text(
                    "learning App",
                    style: TextStyle(
                        fontSize: large
                            ? 40
                            : normal
                                ? 35
                                : 25,
                        fontFamily: "Poppins_Bold",
                        height: 1),
                  ),
                  SizedBox(
                    height: large ? 20 : 18,
                  ),
                  Text(
                    "The App that lets you learn new things in a better way",
                    style: TextStyle(fontSize: 22, fontFamily: "Poppins"),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              children: [
                Container(
                    child: SvgPicture.asset(
                  "assets/space.svg",
                  width: large
                      ? 400
                      : normal
                          ? 310
                          : 290,
                )),
              ],
            ),
            SizedBox(
              height: large ? 150 : 80,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: [
              Container(
                child: IntroductionScreen(
                  color: Colors.black,
                  done: Text(
                    "Done",
                    style: TextStyle(color: Colors.black),
                  ),
                  onDone: () async {
                    setState(() {
                      loading = false;
                    });
                    String now =
                        DateFormat("yyyy-MM-dd").format(DateTime.now());
                    myUser = User(
                      firstname: firstname,
                      lastname: lastname,
                      initials: firstname[0] + lastname[0],
                      gender: gender,
                      number: telnumber,
                      created: now,
                      birthday: "",
                      image: null,
                      color: globals.colorListfixed.indexOf(myColor),
                      level: 1,
                      xp: 0,
                      score: 0,
                      coins: 0,
                      rank: 0,
                    );
                    print(firstname);

                    await FirebaseFirestore.instance
                        .collection("User")
                        .doc(firstname)
                        .set(myUser.toJson());
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString("firstname", firstname);
                    widget.update(prefs);
                    Navigator.of(context).push(CustomPageRoute(
                      builder: (context) => MyApp(),
                    ));
                  },
                  onChange: (int) {
                    if (int == 1) {
                      setState(() {
                        page = true;
                      });
                    }
                    if (int == 2) {
                      colorList.shuffle();
                      myColor = colorList[0];
                    }
                  },
                  next: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                  ),
                  rawPages: getpages(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  CustomPageRoute({builder}) : super(builder: builder);
}

String gender = " ";
PhoneNumber number = PhoneNumber(isoCode: 'GH');
String firstname, lastname, telnumber;
bool hide = false;

class myForm extends StatefulWidget {
  const myForm({Key key}) : super(key: key);

  @override
  _myFormState createState() => _myFormState();
}

class _myFormState extends State<myForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  SingleChildScrollView(child: InputForm()),
                ],
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: mypadding),
              width: MediaQuery.of(context).size.width,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xffFED330),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50)),
              ),
              child: Container()),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  hide
                      ? SizedBox(
                          width: 0,
                        )
                      : Row(
                          children: [
                            Text(
                              "Create A Profile",
                              style: TextStyle(
                                  fontSize: large
                                      ? 34
                                      : normal
                                          ? 34
                                          : 30,
                                  fontFamily: "Poppins_Bold"),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  hide
                      ? SizedBox(
                          width: 0,
                        )
                      : Text(
                          "Fill the forms with your personal info",
                          style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  const InputForm({Key key}) : super(key: key);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                hide = true;
              });
            },
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "First Name",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
              ),
              style: TextStyle(fontFamily: "Poppins", fontSize: 15),
              onChanged: (val) {
                firstname = val;
              },
              validator: (value) =>
                  value.isEmpty ? 'Last name cannot be blank' : null,
              initialValue: firstname,
              textInputAction: TextInputAction.next,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            validator: (value) =>
                value.isEmpty ? 'Last name cannot be blank' : null,
            decoration: InputDecoration(
                labelText: "Last Name",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                )),
            style: TextStyle(fontFamily: "Poppins", fontSize: 15),
            onChanged: (val) {
              lastname = val;
            },
            initialValue: lastname,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 20,
          ),
          InternationalPhoneNumberInput(
            inputDecoration: InputDecoration(
                labelText: "Number",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                )),
            onInputChanged: (PhoneNumber number) {
              telnumber = number.phoneNumber;
            },
            validator: (value) => value.length < 9 ? 'invalid number' : null,
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            textStyle: TextStyle(fontFamily: "Poppins", fontSize: 15),
            selectorTextStyle: TextStyle(color: Colors.black),
            formatInput: false,
            initialValue: number,
            keyboardAction: TextInputAction.done,
          ),
          SizedBox(
            height: 25,
          ),
          CustomRadio(),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "Already a User?",
                style: TextStyle(fontFamily: "Poppins", color: Colors.blue),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Profile extends StatefulWidget {
  final ValueChanged<SharedPreferences> update;
  bool loading;
  Profile(this.update, this.loading);

  @override
  _ProfileState createState() => _ProfileState();
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
TextEditingController controller;

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(() {
      setState(() {
        telnumber = controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool mloading = widget.loading;
    return Container(
      color: Colors.white,
      child: Center(
        child: loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "profile",
                    child: Container(
                      child: Center(
                        child: Text(
                          firstname[0].toUpperCase() +
                              lastname[0].toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 100,
                              fontFamily: "Poppins_Bold"),
                        ),
                      ),
                      width: large ? 230 : 220,
                      height: large ? 230 : 220,
                      decoration: BoxDecoration(
                        color: myColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30)),
                          child: Text("username")),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30)),
                          child: Text("username")),
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30)),
                          child: Text("username")),
                    ],
                  ),
                  Hero(
                      tag: "text",
                      child: Text(
                        capitalize(firstname) + " " + capitalize(lastname),
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800]),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    telnumber,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[800]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    gender,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
      ),
    );
  }
}

class CustomRadio extends StatefulWidget {
  const CustomRadio({Key key}) : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          borderRadius: BorderRadius.circular(30),
          color: gender == "Male" ? Colors.black : Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              validate();
              setState(() {
                FocusScope.of(context).unfocus();
                gender = "Male";
                print(gender);
              });
            },
            child: Container(
                child: Text(
                  "Male",
                  style: TextStyle(
                      fontFamily: "Poppins_Bold",
                      fontSize: 18,
                      color: gender == "Male" ? Colors.white : Colors.black),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        width: 1,
                        color: gender == "Male" ? Colors.black : Colors.grey),
                    borderRadius: BorderRadius.circular(30))),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Material(
          borderRadius: BorderRadius.circular(30),
          color: gender == "Female" ? Colors.black : Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              setState(() {
                validate();
                FocusScope.of(context).unfocus();
                gender = "Female";
                print(gender);
              });
            },
            child: Container(
                child: Text(
                  "Female",
                  style: TextStyle(
                      fontFamily: "Poppins_Bold",
                      fontSize: 18,
                      color: gender == "Female" ? Colors.white : Colors.black),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: gender == "Female"
                            ? Colors.black
                            : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(30))),
          ),
        )
      ],
    );
  }

  void validate() {
    if (_formKey.currentState.validate()) {
      setState(() {
        validated = true;
      });
      if (page) {
        setState(() {
          hiden = false;
        });
      }
    } else {
      setState(() {
        validated = false;
      });
    }
  }
}

saveForm() async {}
