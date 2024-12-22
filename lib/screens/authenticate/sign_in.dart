import 'package:flutter/material.dart';

import '../../services/auth.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
        title: Text('Sign in to Brew Crew'),
        actions: <Widget>[
          TextButton.icon(
            icon:Icon(Icons.person),
            label:Text('Register'),
            onPressed: () {
              widget.toggleView();
            },
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.black)
            ),
          )
        ],
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 25
        ),
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
                    print('email');
                    print('password');
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  )
              )
            ],
          )
        ),
      )
    );
  }
}
