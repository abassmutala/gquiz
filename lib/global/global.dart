import 'package:flutter/material.dart';
import 'package:gquiz/models/question.dart';
import 'package:gquiz/models/score.dart';
import 'package:gquiz/models/user.dart';
import 'package:gquiz/models/userplay.dart';

String category = "None";
List<Question> globalQuestions = [];
bool clicked = false;
bool next = false, bot = false;
var colorListnum = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
];
List<Object> qoutes = [];
var colorList = [
  Colors.red,
  Colors.pink,
  Colors.blue,
  Colors.deepPurple,
  Colors.grey[900],
  Colors.indigo[900],
  Colors.green[900],
  Colors.orange[800],
  Colors.brown[800],
  Colors.teal[600],
  Colors.blueGrey[700],
  Colors.limeAccent[100],
  Colors.amber
];
var colorListfixed = [
  Colors.red,
  Colors.pink,
  Colors.blue,
  Colors.deepPurple,
  Colors.grey[900],
  Colors.indigo[900],
  Colors.green[900],
  Colors.orange[800],
  Colors.brown[800],
  Colors.teal[600],
  Colors.blueGrey[700],
  Colors.limeAccent[100],
  Colors.amber
];
int pageIndex = 0, level = 0;
Color profilecolor = Colors.grey[300];
List<Score> subjects = [];
User myUser = User();
int currentlevelxp, nextlevelxp;
UserPlay opponentPlay;
UserPlay myPlay;
User opponentProfile;
String table = " ";
String username = "",
    number = "",
    age = "",
    firstname = "",
    lastname = "",
    initials = "ini",
    gender = "",
    created = "";

bool hasaccount = false;
