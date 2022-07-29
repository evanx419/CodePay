import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

Future addPayment2Customer() async {
  var _myBody = jsonEncode({
    "type": "us_ach_bank",
    "fields": {
      "proof_of_authorization": false,
      "first_name": "John",
      "last_name": "Doe",
      "company_name": "Acme",
      "routing_number": "345-345-op4",
      "payment_purpose": "goods",
      "account_number": "rete-34534-4t"
    },
    "metadata": {"merchant_defined": true}
  });

  await RequestInit().getSignature(
      "/v1/customers/cus_5d5df611edf5db5bd7fa8ee4c3740753/payment_methods",
      "post",
      bodyData: _myBody);

  try {
    var create = await post(
      Uri.parse(
          "https://sandboxapi.rapyd.net/v1/customers/cus_5d5df611edf5db5bd7fa8ee4c3740753/payment_methods"),
      headers: header,
      body: _myBody,
    );

    print(create.body);

    if (create.statusCode == 200) {
      return json.decode(create.body);
    } else {
      // print(transfer.body);
      throw Exception();
    }
  } on SocketException {
    throw Exception();
  }
}
