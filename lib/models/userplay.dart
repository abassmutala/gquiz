class UserPlay {
  String firstname;
  int question,correct;

  UserPlay({
    this.firstname,
    this.question,
    this.correct
  });

  UserPlay.fromJson(Map<String, dynamic> mapData)
      : firstname = mapData['firstname'],
        question = mapData['question'],
        correct = mapData['correct'];



  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'question' : question,
      'correct' : correct
    };
  }
}
