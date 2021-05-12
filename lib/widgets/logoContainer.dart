import 'package:flutter/material.dart';

class LogoContainer {
  getLogo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 0),
      child: Center(
        child: Image(
          image: AssetImage('assets/Logo.png'),
        ),
      ),
    );
  }
}
