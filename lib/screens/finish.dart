import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class Finish extends StatefulWidget {
  @override
  _FinishState createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  Color colorg1 = Colors.blueAccent;
  Color colorg2 = Colors.blue[900];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Finish!",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins_Bold",
                        fontSize: 40),
                  ),
                  Container(
                    width: 250,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 60,
                          color: Colors.blueAccent,
                        ),
                        Icon(
                          Icons.star,
                          size: 60,
                          color: Colors.blueAccent,
                        ),
                        Icon(
                          Icons.star,
                          size: 60,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "LEVEL 1 :",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "PASSED",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Poppins",
                                  color: Colors.green),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "LEVEL 2 :",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "PASSED",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Poppins",
                                  color: Colors.green),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
