import 'package:flutter/material.dart';

import '../../services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown.shade100,
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          elevation: 0.0,
          title: Text('Sign up to Brew Crew'),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 25
          ),
          actions: <Widget>[
            TextButton.icon(
              icon:Icon(Icons.person),
              label:Text('Sign In'),
              onPressed: () {
                widget.toggleView();
              },
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.black)
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          /*child: ElevatedButton(
            onPressed: () async {
              dynamic result = await _auth.signInAnon();
              if(result == null){
                print('error signing in');
              } else {
                print('signed in');
                print(result);
              }
            },
            child: Text('Sign in anon'),
        ),*/
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => (val == null || val.isEmpty) ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    validator: (val) => (val == null || val.length < 6) ? 'Enter a password 6+ char long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.pink.shade400)
                      ),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          if(result == null){
                            setState(() {
                              error = 'please supply a valid email';
                            });
                          }
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      )
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              )
          ),
        )
    );
  }
}
