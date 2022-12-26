import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/includes/http_call.dart';
import 'package:remote_pay_app/screens/login.dart';
import 'package:remote_pay_app/screens/error.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RemotePay'),
        centerTitle: true,
      ),
      body: RegisterForm(httpCall: HttpCall(), camera: camera),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key, required this.httpCall, required this.camera}) : super(key: key);

  final HttpCall httpCall;
  final CameraDescription camera;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _success = false;

  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onFormSubmit({BuildContext? context}) async {
    if (_formKey.currentState!.validate()) {
      bool success = await widget.httpCall.register(_firstnameController.text, _lastnameController.text, _emailController.text, _usernameController.text, _passwordController.text);

      if (success) {

        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => LoginPage(camera: widget.camera, justRegistered: true),
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
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Text(
              'Registration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            // [First Name]
            TextFormField(
              controller: _firstnameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter your first name',
                labelText: 'First Name',
              ),
              validator: (String? value) {
                return (value ==null || value.isEmpty) ? 'Please enter your first name.' : null;
              },
            ),
            // spacer
            const SizedBox(height: 12.0),

            // [Last Name]
            TextFormField(
              controller: _lastnameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter your last name',
                labelText: 'Last Name',
              ),
              validator: (String? value) {
                return (value ==null || value.isEmpty) ? 'Please enter your last name.' : null;
              },
            ),
            // spacer
            const SizedBox(height: 12.0),

            // [Email]
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter your email address',
                labelText: 'Email Address',
              ),
              validator: (String? value) {
                return (value ==null || value.isEmpty) ? 'Please enter your email address.' : null;
              },
            ),
            // spacer
            const SizedBox(height: 12.0),

            // [Username]
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
            // spacer
            const SizedBox(height: 12.0),

            // [Confirm Password]
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter your password',
                labelText: 'Confirm Password',
              ),
              validator: (String? value) {
                return (value == null || value.isEmpty || value != _passwordController.text) ? 'Please enter your password again to confirm.' : null;
              },
              obscureText: true,
            ),

            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _firstnameController.clear();
                    _lastnameController.clear();
                    _emailController.clear();
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                ElevatedButton(
                  child: Text('REGISTER'),
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