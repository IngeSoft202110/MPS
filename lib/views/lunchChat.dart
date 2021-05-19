import 'package:flutter/material.dart';

class LunchChat extends StatefulWidget {
  @override
  _LunchChatState createState() => _LunchChatState();
}

class _LunchChatState extends State<LunchChat> {

   Future Deploy_chat () async {
    
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LunchChat()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}