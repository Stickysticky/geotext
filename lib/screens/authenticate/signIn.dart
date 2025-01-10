import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/authServiceProvider.dart';
import '../../services/auth.dart';
import 'package:geotext/services/utils.dart';

class SignIn extends ConsumerStatefulWidget {

  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {


  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final AuthService auth = ref.read(authServiceProvider);
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        elevation: 0.0,
        title: Text(capitalizeFirstLetter(S.of(context).signInTitle)),
        actions: <Widget>[
          TextButton.icon(
            icon:Icon(Icons.person),
            label:Text(capitalizeFirstLetter(S.of(context).register)),
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
                validator: (val) => (val == null || val.isEmpty) ? capitalizeFirstLetter(S.of(context).enterEmail) : null,
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
                    dynamic result = await auth.signIn(email, password);
                    if(result == null){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(capitalizeFirstLetter(S.of(context).errorTitle)),
                            content: Text(capitalizeFirstLetter(S.of(context).signInError)),
                          );
                        },
                      );
                    }

                  },
                  child: Text(
                    capitalizeFirstLetter(S.of(context).signIn),
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
