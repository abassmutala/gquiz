import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';

import 'dialogue/hero_dialogue.dart';

String mylabel = '';
String myoldlabel = '';
String image = '';
double dd = 0;

class SpinngWheel extends StatefulWidget {
  @override
  _SpinngWheelState createState() => _SpinngWheelState();
}

class _SpinngWheelState extends State<SpinngWheel> {
  final StreamController _dividerController = StreamController<int>();

  final _wheelNotifier = StreamController<double>();
  @override
  void dispose() {
    super.dispose();
    _dividerController.close();
    _wheelNotifier.close();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinningWheel(
            Image(image: new AssetImage('assets/roulette-8-300.png')),
            width: 310,
            height: 310,
            initialSpinAngle: _generateRandomAngle(),
            spinResistance: 0.6,
            canInteractWhileSpinning: false,
            dividers: 8,
            onUpdate: _dividerController.add,
            onEnd: (value) {
              Navigator.of(context)
                  .push(HeroDialogRoute(builder: (context) => ItemChossen()));
            },
            secondaryImage:
                Image(image: new AssetImage('assets/roulette-center-300.png')),
            secondaryImageHeight: 110,
            secondaryImageWidth: 110,
            shouldStartOrStop: _wheelNotifier.stream,
          ),
          SizedBox(height: 30),
          StreamBuilder(
            stream: _dividerController.stream,
            builder: (context, snapshot) =>
                snapshot.hasData ? RouletteScore(snapshot.data) : Container(),
          ),
          SizedBox(height: 30),
          new ElevatedButton(
              child: new Text("Start"),
              onPressed: () {
                _wheelNotifier.sink.add(_generateRandomVelocity());
              })
        ],
      ),
    );
  }

  double _generateRandomVelocity() {
    dd = (Random().nextDouble() * 20000) + 2000;
    return (Random().nextDouble() * 20000) + 2000;
  }

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}

class RouletteScore extends StatelessWidget {
  final int selected;

  final Map<int, String> labels = {
    1: 'mini stationery',
    2: '50 coins',
    3: '5GHS Airtime',
    4: '100 coins',
    5: '50GHS Cash',
    6: '200 coins',
    7: 'mini provisions',
    8: '300 coins',
  };
  final Map<int, String> mimage = {
    1: 'stationaries.png',
    2: 'point.svg',
    3: 'airtime.png',
    4: '100 coins',
    5: 'moneyprice.png',
    6: 'coins.png',
    7: 'provisions',
    8: 'point.svg',
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    myoldlabel = labels[selected];
    image = mimage[selected];

    return SizedBox();
  }
}

class ItemChossen extends StatefulWidget {
  @override
  _ItemChossenState createState() => _ItemChossenState();
}

class _ItemChossenState extends State<ItemChossen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/" + image,
                      width: 200,
                    ),
                    Text(
                      myoldlabel,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Poppins_Bold",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
