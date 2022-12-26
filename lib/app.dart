import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/screens/login.dart';

class RemotePayApp extends StatelessWidget {
  const RemotePayApp({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RemotePayApp',
      home: LoginPage(camera: camera),
    );
  }
}