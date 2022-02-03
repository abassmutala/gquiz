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
      padding: const EdgeInsets.all(48),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/startback.png"), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Spacing.verticalSpace48,
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
          Align(
            alignment: Alignment.bottomRight,
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
          borderRadius: Corners.xlBorder,
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
  String fullNameInitials() {
    return Utilities.getInitials(
      firstname: widget.firstName,
      surname: widget.lastName,
    );
  }

  @override
  Widget build(BuildContext context) {
    colorList.shuffle();
    var myColor = colorList[0];
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
                            _userAvatar(theme),
                            Spacing.verticalSpace24,
                            Hero(
                              tag: 'text',
                              child: Text(
                                '${widget.firstName} ${widget.lastName}',
                                style: theme.textTheme.headline5,
                              ),
                            ),
                            Spacing.verticalSpace16,
                            usernameOptions(theme),

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
                    String now =
                        DateFormat("yyyy-MM-dd").format(DateTime.now());
                    User myUser = User();
                    myUser = User(
                      firstname: widget.firstName,
                      lastname: widget.lastName,
                      initials: fullNameInitials(),
                      gender: gender,
                      number: '',
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

                    await FirebaseFirestore.instance
                        .collection("User")
                        .doc(widget.firstName)
                        .set(myUser.toJson());
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString("firstname", widget.firstName);
                    widget.update(prefs);
                    Navigator.of(context).push(
                      CustomPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                    );
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

  Hero _userAvatar(ThemeData theme) {
    colorList.shuffle();
    var myColor = colorList[0];
    return Hero(
      tag: "profile",
      child: CircleAvatar(
        radius: 110,
        backgroundColor: myColor,
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
    );
  }

  Wrap usernameOptions(ThemeData theme) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      children: [
        RawChip(
          onPressed: () {},
          label: Text(
            "${widget.firstName}${widget.lastName}".toLowerCase(),
            style: theme.textTheme.subtitle1,
          ),
        ),
        Spacing.horizontalSpace4,
        RawChip(
          onPressed: () {},
          label: Text(
            "${widget.firstName}_${widget.lastName}".toLowerCase(),
            style: theme.textTheme.subtitle1,
          ),
        ),
        RawChip(
          onPressed: () {},
          label: Text(
            "${widget.firstName[0]}_${widget.lastName}".toLowerCase(),
            style: theme.textTheme.subtitle1,
          ),
        ),
      ],
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  CustomPageRoute({builder}) : super(builder: builder);
}

String gender = "";
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              setState(() {
                // validate();
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
}
