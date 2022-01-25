import 'package:gquiz/models/question.dart';

class Questions {
  List<Question> questions;

Questions({this.questions});
  Questions.fromMap(Map<String, dynamic> data){
    questions = data["questions"];
  }
  Map<String, dynamic> toMap() {
    return {
      'questions': questions.map((i) => i.toMap()).toList(),  // this worked well
    };}

}
