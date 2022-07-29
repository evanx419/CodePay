import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

Future createPayment1(amount, currency, method, wallet) async {
  var _myBody = jsonEncode(
    {
      "amount": amount.toString(),
      "currency": currency,
      "description": "Payment by bank transfer",
      "payment_method": {"type": method},
      "ewallets": [
        {
          "ewallet": wallet,
          "percentage": 100,
        }
      ],
      "metadata": {
        "merchant_defined": true,
      }
    },
  );

  await RequestInit().getSignature("/v1/payments", "post", bodyData: _myBody);

  try {
    var transfer = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payments"),
      headers: header,
      body: _myBody,
    );

    print(transfer.body);

    if (transfer.statusCode == 200) {
      return json.decode(transfer.body);
    } else {
      throw Exception(transfer);
    }
  } on SocketException {
    throw Exception();
  }
}

Future createPayment2(amount, currency, method, wallet, mapdata) async {
  var _myBody = jsonEncode(
    {
      "amount": amount.toString(),
      "currency": currency,
      "description": "Payment by bank transfer",
      "payment_method": {"type": method, "fields": mapdata},
      "ewallets": [
        {
          "ewallet": wallet,
          "percentage": 100,
        }
      ],
      "metadata": {
        "merchant_defined": true,
      }
    },
  );

  await RequestInit().getSignature("/v1/payments", "post", bodyData: _myBody);

  try {
    var transfer = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payments"),
      headers: header,
      body: _myBody,
    );

    print(transfer.body);

    if (transfer.statusCode == 200) {
      return json.decode(transfer.body);
    } else {
      throw Exception(transfer);
    }
  } on SocketException {
    throw Exception();
  }
}
