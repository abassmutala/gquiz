import 'package:gquiz/models/score.dart';

class Scores{
   List<Score> subjects;

  Scores({this.subjects});


  Scores.fromJson(Map<String, dynamic> mapData) :
      subjects = mapData['subjects'];

  Map<String, dynamic> toJson() {
    return {
      'subjects': subjects,
    };
  }

}