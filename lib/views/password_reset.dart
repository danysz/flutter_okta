import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:okta_flutter/providers/auth.dart';
import 'package:okta_flutter/classes/screen_arguments.dart';
import 'package:okta_flutter/styles/styles.dart';
import 'package:okta_flutter/widgets/styled_flat_button.dart';

class PasswordReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: PasswordResetForm(),
          ),
        ),
      ),
    );
  }
}

class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({Key key}) : super(key: key);

  @override
  PasswordResetFormState createState() => PasswordResetFormState();
}

class PasswordResetFormState extends State<PasswordResetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String message = '';

  Map response = new Map();

  String validateEmail(String value) {
    if (value.trim().isEmpty) {
      return 'Email is required.';
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return 'Valid email required.';
    }
    email = value.trim();
    return null;
  }

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      response = await Provider.of<AuthProvider>(context).passwordReset(email);
      if (response['reset']) {
        Navigator.pushReplacementNamed(
          context,
          '/login',
          arguments: ScreenArguments(
            response['message'],
          ),
        );
      } else {
        setState(() {
          message = response['message'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Request Password Reset',
            textAlign: TextAlign.center,
            style: Styles.h1,
          ),
          SizedBox(height: 10.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            decoration: Styles.input.copyWith(
              hintText: 'Email',
            ),
            validator: validateEmail,
          ),
          SizedBox(height: 15.0),
          StyledFlatButton(
            'Send Password Reset Email',
            onPressed: submit,
          ),
        ],
      ),
    );
  }
}
