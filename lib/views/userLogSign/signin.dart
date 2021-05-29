import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/homeClient.dart';
import 'package:mps/views/homePartner.dart';
import 'package:mps/views/userLogSign/signup.dart';
import 'package:mps/widgets/logoContainer.dart';

import '../errorDialog.dart';

class SignIn extends StatefulWidget {
  final typeUser;
  SignIn({Key key, this.typeUser}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthMethods authMethods = new AuthMethods();

  bool _isLoading = false;

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (await AuthMethods().signInEmailAndPassword(email, password) !=
            null) {
          setState(() {
            _isLoading = false;
          });
          //aassas
          if (widget.typeUser == 'cliente') {
            print("ando por aquí");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeClient()));
          } else if (widget.typeUser == 'socio') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePartner()));
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (context) => ErrorDialog("Error", e.message),
            barrierDismissible: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.typeUser);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
      ),
      body: _isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      LogoContainer().getLogo(),
                      SizedBox(
                        height: 140,
                      ),
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty ? "Ingrese Email" : null;
                        },
                        decoration: InputDecoration(hintText: "Email"),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val.isEmpty ? "Ingrese la contraseña" : null;
                        },
                        decoration: InputDecoration(hintText: "Password"),
                        onChanged: (val) {
                          password = val;
                        },
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      GestureDetector(
                        onTap: () {
                          AuthMethods()
                              .signInWithGoogle(context, widget.typeUser);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Iniciar sesión con Google",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿No tienes una cuenta? ",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignUp(typeUser: widget.typeUser)));
                            },
                            child: Text("Regístrate",
                                style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
