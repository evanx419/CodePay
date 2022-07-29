import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';


Future confirmfFx(payout) async {

  await RequestInit().getSignature("/v1/payouts/confirm/$payout", "post");

  try {
    var create = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payouts/confirm/$payout"),
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
