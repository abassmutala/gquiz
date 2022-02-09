import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gquiz/constants/constants.dart';
import 'package:gquiz/main.dart';
import 'package:gquiz/models/user.dart';
import 'package:gquiz/screens/home.dart';
import 'package:gquiz/utils/utilities.dart';
import 'package:intl/intl.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class StartUpForm extends StatefulWidget {
  const StartUpForm({Key key, this.update}) : super(key: key);
  final ValueChanged<SharedPreferences> update;

  @override
  _StartUpFormState createState() => _StartUpFormState();
}

class _StartUpFormState extends State<StartUpForm> {
  final PageController _viewController = PageController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: PageView(
        controller: _viewController,
        children: getpages(theme),
      ),
    );
  }

  Widget welcome(ThemeData theme) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/startback.png"), fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset("assets/logo.svg"),
                    Spacing.verticalSpace16,
                    Text(
                      "Welcome\nto the\nlearning app",
                      style: theme.textTheme.headline5,
                    ),
                    Spacing.verticalSpace24,
                    Text(
                      "The App that lets you learn new things in a better way",
                      style: theme.textTheme.headline6,
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      "assets/space.svg",
                      width: 290,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: kTabLabelPadding,
              child: TextButton(
                onPressed: () {
                  _viewController.nextPage(
                      duration: TimeLengths.halfSec, curve: Curves.easeIn);
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getpages(ThemeData theme) {
    return [
      welcome(theme),
      SignUpView(
        update: widget.update,
      ),
    ];
  }
}

class SignUpView extends StatelessWidget {
  SignUpView({Key key, @required this.update}) : super(key: key);
  final ValueChanged<SharedPreferences> update;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: _signUpAppbar(theme),
      body: SafeArea(
        child: Container(
          padding: kTabLabelPadding,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Spacing.verticalSpace48,
                    createAccountForm(theme),
                    Spacing.verticalSpace48,
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Already a user? Sign In",
                        style: theme.textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.of(context).push(
                        CustomPageRoute(
                          builder: (context) => ProfileView(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            update: update,
                          ),
                        ),
                      );
                      // _viewController.nextPage(
                      //     duration: TimeLengths.halfSec, curve: Curves.easeIn);
                    } else {
                      return null;
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _signUpAppbar(ThemeData theme) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: AnimatedContainer(
        padding: const EdgeInsets.all(20),
        duration: TimeLengths.fullSec,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.only(
              bottomLeft: Corners.xlRadius, bottomRight: Corners.xlRadius),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create a profile",
                style: theme.textTheme.headline5,
              ),
              Spacing.verticalSpace8,
              Text(
                "Fill the form with your personal info",
                style: theme.textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createAccountForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: "First Name",
              contentPadding: Insets.standardPadding,
              border: OutlineInputBorder(
                borderRadius: Corners.xlBorder,
              ),
            ),
            style: theme.textTheme.subtitle1,
            // onChanged: (val) {
            //   setState(() {
            //     _firstname = val;
            //   });
            // },
            validator: (value) =>
                value.isEmpty ? 'First name cannot be blank' : null,
            textInputAction: TextInputAction.next,
          ),
          Spacing.verticalSpace16,
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: "Last Name",
              contentPadding: Insets.standardPadding,
              border: OutlineInputBorder(
                borderRadius: Corners.xlBorder,
              ),
            ),
            style: theme.textTheme.subtitle1,
            // onChanged: (val) {
            //   setState(() {
            //     _lastname = val;
            //   });
            // },
            validator: (value) =>
                value.isEmpty ? 'Last name cannot be blank' : null,
            textInputAction: TextInputAction.next,
          ),
          Spacing.verticalSpace16,
          // InternationalPhoneNumberInput(
          //   inputDecoration: InputDecoration(
          //       labelText: "Number",
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          //       border: new OutlineInputBorder(
          //         borderRadius: const BorderRadius.all(
          //           const Radius.circular(30.0),
          //         ),
          //       )),
          //   onInputChanged: (PhoneNumber number) {
          //     telnumber = number.phoneNumber;
          //   },
          //   validator: (value) => value.length < 9 ? 'invalid number' : null,
          //   selectorConfig: SelectorConfig(
          //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          //   ),
          //   textStyle: TextStyle(fontFamily: "Poppins", fontSize: 15),
          //   selectorTextStyle: TextStyle(color: Colors.black),
          //   formatInput: false,
          //   initialValue: number,
          //   keyboardAction: TextInputAction.done,
          // ),
          // SizedBox(
          //   height: 25,
          // ),
          const CustomRadio(),
        ],
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key key,
    @required this.firstName,
    @required this.lastName,
    @required this.update,
  }) : super(key: key);
  final String firstName;
  final String lastName;
  final ValueChanged<SharedPreferences> update;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

bool loading = false;

class _ProfileViewState extends State<ProfileView> {
  bool nameIsTaken;
  String fullNameInitials() {
    return Utilities.getInitials(
      firstname: widget.firstName,
      surname: widget.lastName,
    );
  }

  void selectName(option) {
    setState(() {
      option['isSelected'] = !option['isSelected'];
    });
  }

  Future<bool> checkUsernameAvilability(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(docID)
          .get()
          .then((doc) {
        nameIsTaken = doc.exists;
        debugPrint(nameIsTaken.toString());
      });
      return nameIsTaken;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var myColor = Utilities.generateRandomColor();
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: kTabLabelPadding,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              Flexible(
                child: Center(
                  child: loading
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _userAvatar(theme, myColor),
                            Spacing.verticalSpace24,
                            Hero(
                              tag: 'text',
                              child: Text(
                                '${widget.firstName} ${widget.lastName}',
                                style: theme.textTheme.headline5,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Spacing.verticalSpace16,
                            UsernameChoice(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                            ),
                            Spacing.verticalSpace16,
                            // Text(
                            //   "telnumber",
                            //   style: theme.textTheme.headline6.copyWith(
                            //       fontWeight: FontWeight.w300, color: Colors.grey[800]),
                            // ),
                            // Spacing.verticalSpace4,
                            Text(
                              gender,
                              style: theme.textTheme.headline6.copyWith(
                                  // fontWeight: FontWeight.w300,
                                  color: Colors.grey[800]),
                            ),
                          ],
                        ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      loading = false;
                    });
                    if (username == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please, select a username'),
                      ));
                    }
                    checkUsernameAvilability(username).then((value) async {
                      debugPrint(value.toString());
                      if (value == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'The selected username is already taken by another user. Please, select a different username'),
                          ),
                        );
                      } else {
                        String now =
                            DateFormat("yyyy-MM-dd").format(DateTime.now());
                        User myUser = User(
                          firstname: widget.firstName,
                          lastname: widget.lastName,
                          username: username,
                          initials: fullNameInitials(),
                          gender: gender,
                          number: '',
                          created: now,
                          birthday: "",
                          image: null,
                          color: myColor,
                          level: 1,
                          xp: 0,
                          score: 0,
                          coins: 0,
                          rank: 0,
                        );

                        await FirebaseFirestore.instance
                            .collection("User")
                            .doc(username)
                            .set(myUser.toJson());
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString("username", username);
                        widget.update(prefs);
                        Navigator.of(context).push(
                          CustomPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                        );
                      }
                    });
                  },
                  child: Text(
                    'Done',
                    style: theme.textTheme.subtitle1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Hero _userAvatar(ThemeData theme, String myColor) {
    return Hero(
      tag: "profile",
      child: CircleAvatar(
        radius: 114,
        backgroundColor: Color(
          int.parse(myColor),
        ),
        child: CircleAvatar(
          radius: 112,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 110,
            backgroundColor: Color(
              int.parse(myColor),
            ),
            child: Center(
              child: Text(
                fullNameInitials(),
                style: theme.textTheme.headline5.copyWith(
                  color: Colors.white,
                  fontSize: 100,
                ),
              ),
            ),
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

String gender = "";
String username;

// PhoneNumber number = PhoneNumber(isoCode: 'GH');
// String _firstname, _lastname, telnumber;
// String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              // validate();
              setState(() {
                FocusScope.of(context).unfocus();
                gender = "Male";
                debugPrint(gender);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        width: 1,
                        color: gender == "Male" ? Colors.black : Colors.grey),
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
        Spacing.horizontalSpace8,
        Material(
          borderRadius: BorderRadius.circular(30),
          color: gender == "Female" ? Colors.black : Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              // validate();
              setState(() {
                FocusScope.of(context).unfocus();
                gender = "Female";
                debugPrint(gender);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        width: 1,
                        color: gender == "Female" ? Colors.black : Colors.grey),
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
      ],
    );
  }
}

class UsernameChoice extends StatefulWidget {
  const UsernameChoice({
    Key key,
    @required this.firstName,
    @required this.lastName,
  }) : super(key: key);
  final String firstName;
  final String lastName;

  @override
  UsernameChoiceState createState() => UsernameChoiceState();
}

class UsernameChoiceState extends State<UsernameChoice>
    with TickerProviderStateMixin {
  int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    List<String> _options = [
      '${widget.firstName.replaceAll(RegExp(r' '), '')}${widget.lastName.replaceAll(RegExp(r' '), '')}',
      '${widget.firstName.replaceAll(RegExp(r' '), '_')}_${widget.lastName.replaceAll(RegExp(r' '), '_')}',
      '${widget.firstName[0]}.${widget.lastName.replaceAll(RegExp(r' '), '.')}',
      '${widget.firstName[0]}_${widget.lastName.replaceAll(RegExp(r' '), '_')}',
      '${widget.firstName.replaceAll(RegExp(r' '), '_')}_${widget.lastName[0]}',
    ];

    List<Widget> chips = [];

    for (int i = 0; i < _options.length; i++) {
      Widget choiceChip = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChoiceChip(
          selected: _selectedIndex == i,
          label: Text(
            _options[i].toLowerCase(),
            style: theme.textTheme.subtitle2.copyWith(
                color: _selectedIndex == i ? Colors.white : Colors.black87),
          ),
          backgroundColor: Colors.grey[400],
          selectedColor: Colors.black87,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedIndex = i;
              }
              username = _options[i].toLowerCase();
            });
            debugPrint(username);
          },
        ),
      );

      chips.add(choiceChip);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: chips,
    );
  }
}
