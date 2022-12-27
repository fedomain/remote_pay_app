import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/includes/appbar.dart';
import 'package:remote_pay_app/includes/http_call.dart';
import 'package:remote_pay_app/includes/bottom_nav_bar.dart';
import 'package:remote_pay_app/models/topup.dart';

import 'package:remote_pay_app/models/transaction.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key, required this.camera, required this.userid}) : super(key: key);

  final String userid;
  final CameraDescription camera;
  
  @override
  Widget build(BuildContext context) {
    var myAppBar = getAppBar(context, camera, userid);

    return Scaffold(
      appBar: myAppBar,
      body: TransactionsTable(httpCall: HttpCall(), userid: userid),
      bottomNavigationBar: MyBottomNavBar(index: 3,userid: userid, camera: camera),
    );
  }
}

class TransactionsTable extends StatefulWidget {
  const TransactionsTable({Key? key, required this.httpCall, required this.userid}) : super(key: key);

  final String userid;
  final HttpCall httpCall;
  
  @override
  _TransactionsTableState createState() => _TransactionsTableState();
}

class _TransactionsTableState extends State<TransactionsTable> {
  bool _showPayments = true;
  late Future<List<Transaction>> futureTransactions;
  late Future<List<TopUp>> futureTopUps;

  @override
  void initState() {
    super.initState();

    futureTransactions = widget.httpCall.getUserTransactions(widget.userid);
  }

  void _toggleTransactionList() {
    setState(() {
      _showPayments = !_showPayments;

      if (_showPayments) {
        futureTransactions = widget.httpCall.getUserTransactions(widget.userid);
      } else {
        futureTopUps = widget.httpCall.getUserTopUps(widget.userid);
      }
    });
  }

  // Return a future list of user transactions
  FutureBuilder<List<Transaction>> getTransactions() {
    const double widthLeft = 250;
    const double widthRight = 150;
    const double height = 25;

    return FutureBuilder<List<Transaction>>(
      future: futureTransactions,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(5),
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(50),
                  },
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: height,
                          width: widthLeft,
                          padding: const EdgeInsets.all(5),
                          child: Text('${DateFormat.yMMMEd().format(snapshot.data![index].dateTime)} ${DateFormat.jm().format(snapshot.data![index].dateTime)}'),
                        ),
                        Container(
                          height: height,
                          width: widthLeft,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.centerRight,
                          //child: Text('¥${snapshot.data![index].amount}'),
                        ),
                      ]
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: height,
                          width: widthRight,
                          padding: EdgeInsets.all(5),
                          child: Text(snapshot.data![index].description),
                        ),
                        Container(
                          height: height,
                          width: widthRight,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.centerRight,
                          child: Text('¥${snapshot.data![index].amount}'),
                        ),
                      ]
                    ),
                  ],
                )
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        } else {
          return const Center(
            child: Text(
              'You have no transactions',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
      },
    );
  }

  // Return a future list of user top ups
  FutureBuilder<List<TopUp>> getTopUps() {
    const double widthLeft = 250;
    const double widthRight = 150;
    const double height = 25;

    return FutureBuilder<List<TopUp>>(
      future: futureTopUps,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(5),
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(50),
                  },
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: height,
                          width: widthLeft,
                          padding: const EdgeInsets.all(5),
                          child: Text('${DateFormat.yMMMEd().format(snapshot.data![index].dateTime)} ${DateFormat.jm().format(snapshot.data![index].dateTime)}'),
                        ),
                        Container(
                          height: height,
                          width: widthLeft,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.centerRight,
                          //child: Text('¥${snapshot.data![index].amount}'),
                        ),
                      ]
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: height,
                          width: widthRight,
                          padding: EdgeInsets.all(5),
                          child: Text('whatever'),
                        ),
                        Container(
                          height: height,
                          width: widthRight,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.centerRight,
                          child: Text('¥${snapshot.data![index].amount}'),
                        ),
                      ]
                    ),
                  ],
                )
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        } else {
          return const Center(
            child: Text(
              'You have no top ups',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _toggleTransactionList,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 10),
                  backgroundColor: (_showPayments) ? Colors.blue : Colors.white,
                ),
                child: Text(
                  'Payments',
                  style: TextStyle(fontSize: 16, color: (_showPayments) ? Colors.white : Colors.blue),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _toggleTransactionList,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 10),
                  backgroundColor: (_showPayments) ? Colors.white : Colors.blue,
                ),
                child: Text(
                  'Top Ups',
                  style: TextStyle(fontSize: 16, color: (_showPayments) ? Colors.blue: Colors.white),
                ),
              )
            ],
          ),
          Expanded(
            child: (_showPayments) ? getTransactions() : getTopUps(),
          )
        ],
      ),
    );
  }
}