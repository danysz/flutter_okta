import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import 'package:okta_flutter/providers/auth.dart';
import 'package:okta_flutter/utils/screen_arguments.dart';
import 'package:okta_flutter/utils/validate.dart';
import 'package:okta_flutter/styles/styles.dart';
import 'package:okta_flutter/styles/palette.dart';
import 'package:okta_flutter/widgets/styled_flat_button.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: LogInForm(),
          ),
        ),
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({Key key}) : super(key: key);

  @override
  LogInFormState createState() => LogInFormState();
}

class LogInFormState extends State<LogInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String message = '';

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      await Provider.of<AuthProvider>(context).login(email, password);
    }
  }

  void gotoRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  void gotoPasswordReset(BuildContext context) {
    Navigator.pushNamed(context, '/password-reset');
  }

  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    if (args != null) {
      setState(() {
        message = args.message;
      });
    }
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Log in to the App',
            textAlign: TextAlign.center,
            style: Styles.h1,
          ),
          SizedBox(height: 10.0),
          Consumer<AuthProvider>(
            builder: (context, provider, child) => Text(
              provider.notification ?? this.message ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: Styles.input.copyWith(
              hintText: 'Email',
            ),
            validator: (value) {
              email = value.trim();
              return Validate.validateEmail(value);
            }
          ),
          SizedBox(height: 15.0),
          TextFormField(
            obscureText: true,
            decoration: Styles.input.copyWith(
              hintText: 'Password',
            ),
            validator: (value) {
              password = value.trim();
              return Validate.requiredField(value, 'Password is required.');
            }
          ),
          SizedBox(height: 15.0),
          StyledFlatButton(
            'Sign In',
            onPressed: submit,
          ),
          SizedBox(height: 20.0),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: Styles.p,
                  ),
                  TextSpan(
                    text: 'Register.',
                    style: Styles.p.copyWith(color: Palette.accent500),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => gotoRegister(context),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: RichText(
              text: TextSpan(
                text: 'Forgot Your Password?',
                style: Styles.p.copyWith(color: Palette.accent500),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () => gotoPasswordReset(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
