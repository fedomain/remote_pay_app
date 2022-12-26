import 'package:flutter/material.dart';
import 'package:remote_pay_app/screens/home.dart';

AppBar getAppBar(context, camera, userid) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(camera: camera, userid: userid),
          )
        );
      },
    ),
    title: Text('RemotePay'),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(Icons.account_circle_sharp),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(camera: camera, userid: userid),
            )
          );
        },
      ),
    ],
  );
}