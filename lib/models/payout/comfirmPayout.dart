// Request URL: POST https://sandboxapi.rapyd.net/v1/payouts/complete/payout_f85eca81e10e2a0bd6bf0ac5ed35a926/2000

// Message body absent

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

Future completePayout(amount, payout) async {
  await RequestInit().getSignature(
    "/v1/payouts/complete/$payout/$amount",
    "post",
  );

  try {
    var create = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payouts/complete/$payout/$amount"),
      headers: header,
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
