import 'package:flutter/material.dart';
import 'package:mps/views/userLogSign/signin.dart';

class FormUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Seleccione un usuario",
              style: TextStyle(
                //color: Color.fromARGB(255, 119, 124, 135),
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignIn(
                                    typeUser: 'cliente',
                                  )));
                    },
                    child: button('assets/User.png'),
                  ),
                  Text(
                    "Cliente",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignIn(
                                    typeUser: 'socio',
                                  )));
                    },
                    child: button('assets/Owner.png'),
                  ),
                  Text(
                    "Socio",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

button(String image) {
  return Container(
    height: 90,
    width: 90,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.blue[900],
        width: 5,
      ),
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.scaleDown,
      ),
    ),
  );
}
