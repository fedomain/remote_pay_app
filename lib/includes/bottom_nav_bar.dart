import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/screens/home.dart';
import 'package:remote_pay_app/screens/scan.dart';
import 'package:remote_pay_app/screens/topup.dart';
import 'package:remote_pay_app/screens/transactions.dart';

class MyBottomNavBar extends StatefulWidget {
  final int index;
  final String userid;
  final CameraDescription camera;

  const MyBottomNavBar({Key? key, required this.index, required this.camera, required this.userid}) : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(camera: widget.camera, userid: widget.userid),
          )
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanPage(camera: widget.camera, userid: widget.userid),
          )
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopUpPage(camera: widget.camera, userid: widget.userid),
          )
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionsPage(camera: widget.camera, userid: widget.userid),
          )
        );
        break;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner_sharp),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.paid_sharp),
          label: 'Top Up',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_sharp),
          label: 'Transactions',
        ),
      ],
      currentIndex: widget.index,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}