import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:remote_pay_app/models/transaction.dart';

var host = "http://192.168.31.45:3000";

class HttpCall {
  Future<Map<String, dynamic>> checkLogin(String username, String password) async {
    var bytes = utf8.encode(password);
    var uri = Uri.parse('$host/login');
    //var headers = '{HttpHeaders.authorizationHeader: "header"}';

    Map<String, String> body = {
      "username": username,
      "password": sha256.convert(bytes).toString(),
    };

    var httpResponse = await http.post(uri, body: body);
    var jsonResponse = jsonDecode(httpResponse.body);

    return jsonResponse;
  }

  Future<bool> register(String firstname, String lastname, String email, String username, String password) async {
    var bytes = utf8.encode(password);
    var uri = Uri.parse('$host/register');
    //var headers = {HttpHeaders.authorizationHeader: 'whatever'};

    Map<String, String> body = {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "username": username,
      "password": sha256.convert(bytes).toString(),
    };

    var httpResponse = await http.post(uri, body: body);
    var jsonResponse = jsonDecode(httpResponse.body);

    final bool success = pick(jsonResponse, 'success').asBoolOrThrow();

    if (httpResponse.statusCode == 200 && success) {
      return true;
    }

    return false;
  }

  Future<List<Transaction>> getUserTransactions(userid) async {
    var uri = Uri.parse('$host/transactions');

    Map<String, String> body = {
      "userid": userid
    };
    
    var httpResponse = await http.post(uri, body: body);
    var jsonResponse = jsonDecode(httpResponse.body);

    final bool success = pick(jsonResponse, 'success').asBoolOrThrow();

    if (httpResponse.statusCode == 200 && success) {
      List<Transaction> transactions = [];
      final List<dynamic> transactionsData = jsonResponse['result'] as List<dynamic>;
      
      print(transactionsData);

      try {
        transactions = transactionsData.map((transactionData) => Transaction.fromJson(transactionData)).toList();
      } catch(e) {
        print(e);
      }

      return transactions;
    } else {
      throw Exception('Failed to get transactions');
    }
  }

  Future<bool> scanPaymentRequest(String amount, String description, String path, String userid) async {
    var uri = Uri.parse('$host/scanPaymentRequest');
    //var headers = {HttpHeaders.authorizationHeader: 'whatever'};

    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('files', path));

    request.fields['amount'] = amount;
    request.fields['description'] = description;
    request.fields['userid'] = userid;

    http.StreamedResponse response = await request.send();

    //var responseBytes = await response.stream.toBytes();
    //var responseString = utf8.decode(responseBytes);

    print(response);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}