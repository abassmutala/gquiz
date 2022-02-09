class User {
  String firstname,
      lastname,
      initials,
      gender,
      number,
      created,
      birthday,
      image,
      username,color;
  int level, xp, score, coins, rank;

  User(
      {this.firstname,
      this.lastname,
      this.initials,
      this.gender,
      this.number,
      this.created,
      this.birthday,
      this.image,
      this.username,
      this.color,
      this.level,
      this.xp,
      this.score,
      this.coins,
      this.rank});

  User.fromJson(Map<String, dynamic> mapData)
      : firstname = mapData['firstname'],
        lastname = mapData['lastname'],
        initials = mapData['initials'],
        gender = mapData['gender'],
        number = mapData['number'],
        created = mapData['created'],
        birthday = mapData['birthday'],
        image = mapData['image'],
        username = mapData["username"],
        color = mapData['color'],
        level = mapData['level'],
        xp = mapData['xp'],
        score = mapData['score'],
        coins = mapData['coins'],
        rank = mapData['rank'];

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'initials': initials,
      'gender': gender,
      'number': number,
      'created': created,
      'birthday': birthday,
      'image': image,
      'username': username,
      'color': color,
      'level': level,
      'xp': xp,
      'score': score,
      'coins': coins,
      'rank': rank,
    };
  }
}
