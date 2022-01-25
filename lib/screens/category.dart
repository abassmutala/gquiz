import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gquiz/dialogue/start.dart';
import 'package:gquiz/global/widgets.dart';
import 'package:gquiz/screens/play.dart';
import 'package:gquiz/global/global.dart' as globals;

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> with TickerProviderStateMixin{

  AnimationController _controller;
  Animation<double> _scale, _scaleDely,_scaleDely1,_scaleDely2,_scaleDely3;

  nextPage(){

    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 300.0,
        width: 300.0,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


             CircularProgressIndicator(),

            Padding(
              padding:  EdgeInsets.all(15.0),
              child: Text('Cool', style: TextStyle(color: Colors.red),),
            ),

          ],
        ),
      ),
    );
   // showDialog(context: context, builder: (BuildContext context) => errorDialog);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Play()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),

      vsync: this,
    )..forward();
    _scale = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.ease
    ));
    _scaleDely = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2,1.0,curve:Curves.ease )
    ));
    _scaleDely1 = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4,1.0,curve:Curves.ease )
    ));
    _scaleDely2 = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6,1.0,curve:Curves.ease )
    ));
    _scaleDely3 = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.7,1.0,curve:Curves.ease )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
      child: Column(

        children: [

          SizedBox(height:100),
          Row(children: [
            Expanded(
              child: FadeTransition(
                opacity: _controller,
                child: ScaleTransition(
                  scale: _scale,
                  child: GestureDetector(
                    onTap: (){
                      globals.category = "Science";
                    nextPage();
                    

                    },
                    child: Card(
                      margin: EdgeInsets.only(right: 10),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: customCard("assets/science.jpg", "Science"),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _controller,
                child: ScaleTransition(
                  scale: _scaleDely,
                  child: GestureDetector(
                    onTap: (){
                      globals.category = "Maths";
                      nextPage();
                    },
                    child: Card(
                      margin: EdgeInsets.only(left: 10),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: customCard("assets/maths.jpg", "Maths"),
                    ),
                  ),
                ),
              ),
            ),
          ],),
          SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: FadeTransition(
                opacity: _controller,
                child: ScaleTransition(
                  scale: _scaleDely1,
                  child: GestureDetector(
                    onTap: (){
                      globals.category = "English";
                      nextPage();
                    },
                    child: Card(
                      margin: EdgeInsets.only(right: 10),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child:customCard("assets/english.jpg", "English"),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _controller,
                child: ScaleTransition(
                  scale: _scaleDely2,
                  child: GestureDetector(
                    onTap: (){
                      globals.category = "Social";
                      nextPage();
                    },
                    child: Card(
                      margin: EdgeInsets.only(left: 10),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child:customCard("assets/social.jpg", "Social"),
                    ),
                  ),
                ),
              ),
            ),
          ],),
          SizedBox(height: 20,),
          ScaleTransition(
            scale: _scaleDely3,
            child:

            Container(

              child: GestureDetector(
                onTap: (){
                  globals.category = "All";
                  nextPage();
                },
                child: Card(
                    margin: EdgeInsets.only(left: 10),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: customCard("assets/all.jpg", "All")),
              ),
            ),
          ),
          SizedBox(height: 80,),
        ],
      ),
    );
  }
}
