import "package:flutter/material.dart";

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    animationController.forward();
    super.initState();

  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
