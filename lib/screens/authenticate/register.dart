import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../../providers/authServiceProvider.dart';
import '../../services/auth.dart';
import 'package:geotext/services/utils.dart';

class Register extends ConsumerStatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
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
          title: Text(capitalizeFirstLetter(S.of(context).registerTitle)),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 25
          ),
          actions: <Widget>[
            TextButton.icon(
              icon:Icon(Icons.person),
              label:Text(capitalizeFirstLetter(S.of(context).signIn)),
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
                    validator: (val) => (val == null || val.length < 6) ? capitalizeFirstLetter(S.of(context).enterPassword) : null,
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
                          dynamic result = await auth.registerWithEmailAndPassword(email, password);
                          if (result is FirebaseAuthException) {
                            switch (result.code) {
                              case 'email-already-in-use':
                                setState(() {
                                  error = capitalizeFirstLetter(S
                                      .of(context)
                                      .registerErrorMailUsed);
                                });
                                break;

                              case 'invalid-email':
                                setState(() {
                                  error = capitalizeFirstLetter(S
                                      .of(context)
                                      .invalidEmail);
                                });
                                break;

                              case 'weak-password':
                                setState(() {
                                  error = capitalizeFirstLetter(S
                                      .of(context)
                                      .registerWeakPassword);
                                });
                                break;

                              default:
                                setState(() {
                                  error = capitalizeFirstLetter(S
                                      .of(context)
                                      .unknownErrorRegister);
                                });
                            }
                          }
                        }
                      },
                      child: Text(
                        capitalizeFirstLetter(S.of(context).register),
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
