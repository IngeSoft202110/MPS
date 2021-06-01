import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/services/database.dart';

import 'package:mps/views/homeClient.dart';
import 'package:mps/views/userLogSign/signin.dart';
import 'package:mps/widgets/logoContainer.dart';

import '../errorDialog.dart';
import '../homePartner.dart';

class SignUp extends StatefulWidget {
  final typeUser;
  SignUp({Key key, this.typeUser}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String name, email, password;
  AuthMethods authMethods = new AuthMethods();
  bool _isLoading = false;

  signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (await authMethods.signUpWithEmailAndPassword(
                context, email, password, name, widget.typeUser) !=
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
            List<QueryDocumentSnapshot> lista = []; 
              lista = await Queries().owner();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePartner(lista:lista)));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
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
                        height: 120,
                      ),
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty ? "Ingrese nombre" : null;
                        },
                        decoration: InputDecoration(hintText: "Name"),
                        onChanged: (val) {
                          name = val;
                        },
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
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          signUp();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Registrarse",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 110,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿Ya tienes una cuenta? ",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn(
                                            typeUser: widget.typeUser,
                                          )));
                            },
                            child: Text("Inicia Sesión",
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
