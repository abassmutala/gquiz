class Score{
  String name;
  int level;
  int tscore;
  int prevscore;
  int tquestions;
  String prevs;
  String plays;

  Score({this.name, this.level, this.tscore, this.prevscore,this.tquestions,this.prevs,this.plays});

  Score.fromJson(Map<String, dynamic> mapData) :
      name = mapData['name'],
      level = mapData['level'],
      tscore = mapData['tscore'],
      prevscore = mapData['prevscore'],
      tquestions = mapData['tquestions'],
      prevs = mapData['prevs'],
      plays = mapData['plays'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level':level,
      'tscore':tscore,
      'prevscore':prevscore,
      'tquestions':tquestions,
      'prevs' : prevs,
      'plays' : plays
    };
  }

}