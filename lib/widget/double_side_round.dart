import 'package:flutter/material.dart';

import 'package:apipratice/widget/constant.dart';

class TwoSideRoundedButton extends StatefulWidget {
  //  String text;
  // final double radious;
  // final Function press;
  // const TwoSideRoundedButton({
  //   this.text,
  //   this.radious = 29,
  //   this.press,
  // });
  String text;
  double radious;
  TwoSideRoundedButton({
    required this.text,
    required this.radious,
  });

  @override
  State<TwoSideRoundedButton> createState() => _TwoSideRoundedButtonState();
}

class _TwoSideRoundedButtonState extends State<TwoSideRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 25.0),
      width: 101,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: kBlackColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.radious),
          bottomRight: Radius.circular(widget.radious),
        ),
      ),
      child: Text(
        widget.text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
