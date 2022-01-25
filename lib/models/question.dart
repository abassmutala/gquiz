class Question {
  String question;
  String answerA;
  String answerB;
  String answerC;
  String answerD;
  String correctAnswer;
  String categ;
  String dif;
  String topic;

Question({this.question,this.answerA,this.answerB,this.answerC,this.answerD,this.correctAnswer,this.categ,this.dif,this.topic});
  Question.fromMap(Map<String, dynamic> data){
    question = data["question"];
    answerA = data["answerA"];
    answerB = data["answerB"];
    answerC = data["answerC"];
    answerD = data["answerD"];
    correctAnswer = data["correctAnswer"];
    categ = data["categ"];
    dif = data["dif"];
    topic = data["topic"];
  }
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answerA':answerA,
      'answerB':answerB,
      'answerC':answerC,
      'answerD':answerD,
      'correctAnswer':correctAnswer,
      'categ':categ,
      'dif':dif,
      'topic':topic,
    };}



}