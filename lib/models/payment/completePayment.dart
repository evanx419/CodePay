import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

Future completePayment(payment) async {
  var _myBody = jsonEncode({
    "token": payment,
  });

  await RequestInit()
      .getSignature("/v1/payments/completePayment", "post", bodyData: _myBody);

  try {
    var transfer = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payments/completePayment"),
      headers: header,
      body: _myBody,
    );

    // print(transfer.body);

    if (transfer.statusCode == 200) {
      return json.decode(transfer.body);
    } else {
      // print(transfer.body);
      throw Exception(transfer);
    }
  } on SocketException {
    throw Exception();
  }
}

Future completePayment2(payment, param1, param2) async {
  var _myBody = jsonEncode({
    "token": payment,
    "param1": param1,
    "param2": param2,
  });

  await RequestInit()
      .getSignature("/v1/payments/completePayment", "post", bodyData: _myBody);

  try {
    var transfer = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payments/completePayment"),
      headers: header,
      body: _myBody,
    );

    // print(transfer.body);

    if (transfer.statusCode == 200) {
      return json.decode(transfer.body);
    } else {
      // print(transfer.body);
      throw Exception(transfer);
    }
  } on SocketException {
    throw Exception();
  }
}
