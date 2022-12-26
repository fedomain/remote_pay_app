import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/scheduler.dart';

import 'package:remote_pay_app/includes/http_call.dart';
import 'package:remote_pay_app/screens/error.dart';
import 'package:remote_pay_app/screens/home.dart';
import 'package:remote_pay_app/screens/register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.camera, this.justRegistered = false}) : super(key: key);

  final CameraDescription camera;
  final bool justRegistered;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(httpCall: HttpCall(), camera: camera, justRegistered: justRegistered),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.httpCall, required this.camera, required this.justRegistered}) : super(key: key);

  final HttpCall httpCall;
  final bool justRegistered;
  final CameraDescription camera;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _success = false;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onFormSubmit({BuildContext? context}) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> response = await widget.httpCall.checkLogin(_usernameController.text, _passwordController.text);

      final bool success = pick(response, 'success').asBoolOrThrow();

      if (success) {
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => HomePage(camera: widget.camera, userid: response['result'][0]['userId']),
          )
        );
      } else {
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => ErrorPage(camera: widget.camera),
          )
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _success = false;
    });

    if (widget.justRegistered) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context, 
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registration'),
            content: const Text('You have successfully registered.\nPlease login with your new account.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('OK'),
              )
            ],
          )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/remotepay.png'),
                const SizedBox(height: 16.0),
                const Text('RemotePay'),
              ],
            ),
            const SizedBox(height: 30.0),
            TextButton(
              child: Text(
                'Not a user? Register Now',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(camera: widget.camera),
                  )
                );
              },
            ),
            // [Name]
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter your username',
                labelText: 'Username',
              ),
              validator: (String? value) {
                return (value ==null || value.isEmpty) ? 'Please enter your username.' : null;
              },
            ),
            // spacer
            const SizedBox(height: 12.0),
            // [Password]
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter your password',
                labelText: 'Password',
              ),
              validator: (String? value) {
                return (value == null || value.isEmpty) ? 'Please enter your password.' : null;
              },
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                ElevatedButton(
                  child: Text('GO'),
                  onPressed: () {
                    _onFormSubmit(context: context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}