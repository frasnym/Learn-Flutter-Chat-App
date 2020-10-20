import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _showSnackBarError(String message, BuildContext ctx) {
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ),
    );
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    print('authResult-$authResult');

    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials';

      if (err.message != null) {
        message = err.message;
      }
      _showSnackBarError(message, ctx);
    } catch (err) {
      var message = 'Something went wrong';
      if (err.message != null) {
        message = err.message;
      }
      _showSnackBarError(message, ctx);
      print('catch-$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
