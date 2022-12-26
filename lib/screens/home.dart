import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/includes/appbar.dart';
import 'package:remote_pay_app/screens/scan.dart';
import 'package:remote_pay_app/screens/topup.dart';
import 'package:remote_pay_app/screens/transactions.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.camera, required this.userid}) : super(key: key);

  final String userid;
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    var myAppBar = getAppBar(context, camera, userid);

    return Scaffold(
      appBar: myAppBar,
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: <GestureDetector>[
          GestureDetector(
            onTap: () => {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanPage(camera: camera, userid: userid),
                )
              )
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.qr_code_scanner_sharp,
                    size: 50,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Scan QR code',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopUpPage(camera: camera, userid: userid),
                )
              )
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.paid_sharp,
                    size: 50,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Top Up',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionsPage(camera: camera, userid: userid),
                )
              )
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.receipt_long_sharp,
                    size: 50,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Transactions',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}

