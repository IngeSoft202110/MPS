import 'dart:ui';
import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final String title;
  final String content;
  ErrorDialog(this.title, this.content);

  @override
  _ErrorDialog createState() => _ErrorDialog(title, content);
}

class _ErrorDialog extends State<ErrorDialog> {
  String title;
  String content;
  _ErrorDialog(this.title, this.content);

  Widget alert() {
    return new BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: new Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue[900])),
        content: new Text(content, style: TextStyle(color: Colors.black)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blue[100],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Aceptar"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return alert();
  }
}
