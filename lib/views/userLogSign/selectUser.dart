import 'package:flutter/material.dart';
import 'package:mps/views/userLogSign/formUser.dart';
import 'package:mps/widgets/formContainer.dart';
import 'package:mps/widgets/logoContainer.dart';

class SelectUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  LogoContainer().getLogo(),
                  SizedBox(
                    height: 60,
                  ),
                  FormUser(),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
