import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({Key key, this.icon, this.text, this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(primary: Colors.black),
      onPressed: onClicked,
      child: buildContent(),
    );
  }

  Widget buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          icon,
          size: 28,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 22, color: Colors.grey),
        )
      ],
    );
  }
}
