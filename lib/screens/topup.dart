import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/includes/appbar.dart';
import 'package:remote_pay_app/includes/http_call.dart';
import 'package:remote_pay_app/screens/error.dart';
import 'package:remote_pay_app/screens/home.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({Key? key, required this.camera, required this.userid}) : super(key: key);

  final String userid;
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    var myAppBar = getAppBar(context, camera, userid);

    return Scaffold(
      appBar: myAppBar,
      body: TopUpForm(camera: camera, httpCall: HttpCall(), userid: userid),
    );
  }
}

class TopUpForm extends StatefulWidget {
  const TopUpForm({Key? key, required this.httpCall, required this.camera, required this.userid}) : super(key: key);

  final String userid;
  final HttpCall httpCall;
  final CameraDescription camera;

  @override
  _TopUpFormState createState() => _TopUpFormState();
}

class _TopUpFormState extends State<TopUpForm> {
  bool _success = false;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  static const String tokenizationKey = 'sandbox_hc5tvcty_qqs7pr8w92yy2vyg';

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            const SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            const SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  void _onFormSubmit({BuildContext? context, required String nonce}) async {
    if (_formKey.currentState!.validate()) {
      bool success = await widget.httpCall.topup(_amountController.text, widget.userid, nonce);

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Text(
              'Top Up Credit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            // [Name]
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter an amount',
                labelText: 'Amount',
              ),
              validator: (String? value) {
                return (value ==null || value.isEmpty) ? 'Please enter an amount to top up.' : null;
              },
            ),

            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _amountController.clear();
                  },
                ),
                ElevatedButton(
                  child: Text('Top Up'),
                  onPressed: () async {
                    var request = BraintreeDropInRequest(
                      tokenizationKey: tokenizationKey,
                      collectDeviceData: true,
                      cardEnabled: true,
                      paypalRequest: BraintreePayPalRequest(
                        amount: _amountController.text,
                        displayName: 'Example company',
                      ),
                    );

                    final result = await BraintreeDropIn.start(request);

                    if (result != null) {
                      //showNonce(result);
                      _onFormSubmit(context: context, nonce: result.paymentMethodNonce.nonce);
                    }
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