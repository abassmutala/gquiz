import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gquiz/constants/constants.dart';
import 'package:gquiz/global/global.dart' as globals;
import 'package:gquiz/models/user.dart';
import 'package:gquiz/services/database_service.dart';

int position;

class Scoreboard extends StatefulWidget {
  const Scoreboard({Key key}) : super(key: key);

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  final DatabaseService _databaseService = DatabaseService();
  @override
  void initState() {
    position = 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff5DE2A2),
        title: Text(
          "Leaderboard",
          style: theme.textTheme.headline5.copyWith(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _databaseService.getUsers(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Spacing.verticalSpace(80),
                              topPlayersWidget(theme,
                                  user: User.fromJson(
                                    snapshot.data[1].data(),
                                  ),
                                  rank: '2',
                                  icon: 'assets/rank_normal.svg',
                                  radius: 65,
                                  mainAxisAlignment: MainAxisAlignment.start),
                            ],
                          ),
                          Column(
                            children: [
                              Spacing.verticalSpace(80),
                              topPlayersWidget(theme,
                                  user: User.fromJson(
                                    snapshot.data[2].data(),
                                  ),
                                  rank: '3',
                                  icon: 'assets/rank_down.svg',
                                  radius: 65,
                                  mainAxisAlignment: MainAxisAlignment.end),
                            ],
                          ),
                          topPlayersWidget(theme,
                              user: User.fromJson(
                                snapshot.data[0].data(),
                              ),
                              rank: '1',
                              icon: 'assets/crown.svg',
                              radius: 80,
                              mainAxisAlignment: MainAxisAlignment.center),
                        ],
                      ),
                    ),
                    Spacing.verticalSpace24,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length - 3,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: UserItem(
                          user: User.fromJson(
                            snapshot.data[index + 3].data(),
                          ),
                          index: '${index + 4}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

Widget topPlayersWidget(
  ThemeData theme, {
  @required User user,
  @required String rank,
  @required String icon,
  @required double radius,
  @required MainAxisAlignment mainAxisAlignment,
}) {
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    children: [
      Column(
        children: [
          Text(
            rank,
            style: theme.textTheme.headline5.copyWith(color: Colors.white),
          ),
          Spacing.verticalSpace4,
          SvgPicture.asset(icon),
          Spacing.verticalSpace8,
          CircleAvatar(
            backgroundColor: globals.colorList[user.color],
            radius: radius,
            child: Text(
              user.initials,
              style: theme.textTheme.headline5
                  .copyWith(fontSize: 64, color: Colors.white),
            ),
          ),
          Spacing.verticalSpace4,
          Text(
            '@${user.firstname}',
            style:
                theme.textTheme.subtitle1.copyWith(fontWeight: FontWeight.w900),
          ),
          Spacing.verticalSpace8,
          Text(
            user.score.toString(),
            style: theme.textTheme.headline5.copyWith(color: Colors.white),
          ),
        ],
      ),
    ],
  );
}

class UserItem extends StatelessWidget {
  final User user;
  final String index;
  const UserItem({Key key, @required this.user, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            children: [
              SvgPicture.asset('assets/rank_${user.rank.toString()}.svg'),
              Spacing.verticalSpace4,
              Text(
                index,
                maxLines: 1,
                style: theme.textTheme.headline5.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        Flexible(
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 0.0, right: 16.0),
            shape: const StadiumBorder(),
            tileColor: Colors.white,
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: globals.colorList[user.color],
              child: Center(
                child: Text(
                  user.initials,
                  style:
                      theme.textTheme.headline5.copyWith(color: Colors.white),
                ),
              ),
            ),
            title: Text(
              '@${user.firstname}',
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              user.score.toString(),
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headline6
                  .copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        )
      ],
    );
  }
}
