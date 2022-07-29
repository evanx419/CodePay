import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../utilities/signature.dart';

Future capturePayment() async {
  
  await RequestInit().getSignature("/v1/payments/payment_e35e1dcdf7bc28097e68afea0bdaab1f/capture", "post", bodyData: "");

  try {
    var transfer = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payments/payment_e35e1dcdf7bc28097e68afea0bdaab1f/capture"),
      headers: header,
    );

    print(transfer.body);

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
