import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Image.asset(
        "images/Rolling-1s-200px.gif",
        width: 50,
      )),
    );
  }
}
