import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Text(
          '{R}',
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
      ),
    );
  }
}
