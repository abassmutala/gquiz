import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:gquiz/models/questions.dart';

class QuestionNotifier {
  List<Questions> _myquestionsList = [];
  Questions _currentQuestions;

  UnmodifiableListView<Questions> get myquestionsList =>
      UnmodifiableListView(_myquestionsList);

  Questions get currentQuestions => _currentQuestions;

  set myquestionsList(List<Questions> myquestionsList) {
    _myquestionsList = myquestionsList;
  }

  set currentQuestions(Questions questions) {
    _currentQuestions = questions;
  }
}
