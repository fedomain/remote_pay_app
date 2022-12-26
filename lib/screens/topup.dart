import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/includes/appbar.dart';


class TopUpPage extends StatelessWidget {
  const TopUpPage({Key? key, required this.camera, required this.userid}) : super(key: key);

  final String userid;
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    var myAppBar = getAppBar(context, camera, userid);

    return Scaffold(
      appBar: myAppBar,
      body: const Text('Top up bro'),
    );
  }
}