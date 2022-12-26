import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/includes/appbar.dart';
import 'package:remote_pay_app/includes/http_call.dart';
import 'package:remote_pay_app/screens/error.dart';
import 'package:remote_pay_app/screens/home.dart';

class ScanFormPage extends StatelessWidget {
  const ScanFormPage({Key? key, required this.camera, required this.imagePath, required this.userid}) : super(key: key);

  final CameraDescription camera;
  final String imagePath;
  final String userid;

  @override
  Widget build(BuildContext context) {
    var myAppBar = getAppBar(context, camera, userid);

    return Scaffold(
      appBar: myAppBar,
      body: ScanForm(httpCall: HttpCall(), camera: camera, imagePath: imagePath, userid: userid),
    );
  }
}

class ScanForm extends StatefulWidget {
  const ScanForm({Key? key, required this.httpCall, required this.camera, required this.imagePath, required this.userid}) : super(key: key);

  final HttpCall httpCall;
  final String imagePath;
  final String userid;
  final CameraDescription camera;

  @override
  _ScanFormState createState() => _ScanFormState();
}

class _ScanFormState extends State<ScanForm> {
  bool _success = false;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _onFormSubmit({BuildContext? context, required String path}) async {
    if (_formKey.currentState!.validate()) {
      bool success = await widget.httpCall.scanPaymentRequest(_amountController.text, _descriptionController.text, path, widget.userid);
      
      String page = success ? '/login' : '/error';

      if (success) {
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => HomePage(camera: widget.camera, userid: widget.userid),
          )
        );
      } else {
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => ErrorPage(camera: widget.camera, userid: widget.userid),
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
    //final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Form(
      key: _formKey,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Request Payment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            Center(
              child: SizedBox(
                height: 300.0,
                width: 300.0,
                child: Image.file(File(widget.imagePath), width: 300, height: 300, alignment: Alignment.center),
              )
            ),

            // [Payment Amount]
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                icon: Icon(Icons.currency_yen_sharp),
                hintText: 'Enter the amount you want to pay',
                labelText: 'Payment Amount',
              ),
              validator: (String? value) {
                return (value == null || value.isEmpty) ? 'Please enter the amount you want to pay.' : null;
              },
            ),
            // spacer
            const SizedBox(height: 12.0),

            // [Description]
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                icon: Icon(Icons.description_sharp),
                hintText: 'Enter the a description',
                labelText: 'Description',
              ),
              validator: (String? value) {
                return (value == null || value.isEmpty) ? 'Please enter a description.' : null;
              },
            ),
            
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _amountController.clear();
                    _descriptionController.clear();
                  },
                ),
                ElevatedButton(
                  child: Text('PAY'),
                  onPressed: () {
                    _onFormSubmit(context: context, path: widget.imagePath);
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


