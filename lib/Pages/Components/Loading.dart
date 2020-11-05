import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Image.asset(
        "images/Wedges-3s-200px.gif",
        width: 100,
      )),
    );
  }
}