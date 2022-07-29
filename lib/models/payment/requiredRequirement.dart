import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../utilities/signature.dart';

Future getPaymentRequirement(type) async {
  await RequestInit()
      .getSignature('/v1/payment_methods/required_fields/$type', "get");

  try {
    var list = await get(
      Uri.parse(
          "https://sandboxapi.rapyd.net/v1/payment_methods/required_fields/$type"),
      headers: header,
    );

    print(list.body);

    if (list.statusCode == 200) {
      // print(json.decode(balacelist.body));

      var result = json.decode(list.body);

      return result;
    } else {
      throw Exception();
    }
  } on SocketException {
    // print(e);
    rethrow;
  }
}
