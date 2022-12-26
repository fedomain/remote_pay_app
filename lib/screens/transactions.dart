import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:remote_pay_app/includes/appbar.dart';
import 'package:remote_pay_app/includes/http_call.dart';
import 'package:remote_pay_app/includes/bottom_nav_bar.dart';

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
  late Future<List<Transaction>> futureTransactions;

  @override
  void initState() {
    super.initState();

    futureTransactions = widget.httpCall.getUserTransactions(widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    var WIDTH_LEFT = 250;
    var WIDTH_RIGHT = 150;
    var HEIGHT = 25;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Transaction>>(
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
                                  height: HEIGHT.toDouble(),
                                  width: WIDTH_LEFT.toDouble(),
                                  padding: EdgeInsets.all(5),
                                  child: Text('${DateFormat.yMMMEd().format(snapshot.data![index].dateTime)} ${DateFormat.jm().format(snapshot.data![index].dateTime)}'),
                                ),
                                Container(
                                  height: HEIGHT.toDouble(),
                                  width: WIDTH_LEFT.toDouble(),
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.centerRight,
                                  //child: Text('¥${snapshot.data![index].amount}'),
                                ),
                              ]
                            ),
                            TableRow(
                              children: <Widget>[
                                Container(
                                  height: HEIGHT.toDouble(),
                                  width: WIDTH_RIGHT.toDouble(),
                                  padding: EdgeInsets.all(5),
                                  child: Text(snapshot.data![index].description),
                                ),
                                Container(
                                  height: HEIGHT.toDouble(),
                                  width: WIDTH_RIGHT.toDouble(),
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

                return const CircularProgressIndicator();
              },
            ),
          )
        ],
      ),
    );
  }
}