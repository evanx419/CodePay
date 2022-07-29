import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

Future respondPayout(wallet) async {
  var _body = jsonEncode({
    "id": wallet,
    "status": "accept",
  });

  await RequestInit()
      .getSignature("/v1/payouts/response", "post", bodyData: _body);

  try {
    var create = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payouts/response"),
      headers: header,
      body: _body,
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
