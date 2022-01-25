import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gquiz/global/global.dart' as globals;

Widget customButton(color, String label, double width) {
  return Container(
    padding: EdgeInsets.all(10),
    alignment: Alignment.center,
    width: width == null ? 200 : width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: Text(
      label,
      style: TextStyle(fontFamily: "Poppins_Bold"),
    ),
  );
}

Widget customCard(String image, String text) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.8), BlendMode.dstATop),
            fit: BoxFit.cover,
            image: AssetImage(image)),
        color: Colors.black),
    width: double.infinity,
    height: 160,
    padding: EdgeInsets.all(10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Text(
          text,
          style: TextStyle(
              color: Colors.white, fontFamily: "Poppins_Bold", fontSize: 20),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    ),
  );
}

Widget pointCount(String detail, String point) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 200,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFefefef),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          detail,
          style: TextStyle(
              fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
      Text(
        point,
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Colors.orange,
            fontSize: 11),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget answerButton(text, context, bool correct) {
  return Container(
    width: MediaQuery.of(context).size.width - 100,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
    decoration: BoxDecoration(
      color: correct
          ? Colors.green
          : globals.clicked
              ? const Color(0xffFD4E4E)
              : Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: globals.clicked ? Colors.white : Colors.grey[800],
            fontFamily: "Poppins_Bold",
            fontSize: 18,
            height: 1.2),
      ),
    ),
  );
}

Widget playItem(String text, String image) {
  return Expanded(
      child: Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    elevation: 10,
    child: Container(
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: SvgPicture.asset(
            image,
            color: Colors.grey,
            width: 100,
          )),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 20, fontFamily: "Poppins_Bold"),
          )
        ],
      ),
    ),
  ));
}
