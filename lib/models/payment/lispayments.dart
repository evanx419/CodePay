import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

int? paymentlenght;

Future getPaymentslist(wallet) async {
  await RequestInit().getSignature('/v1/payments?ewallet=$wallet', "get");

  try {
    var list = await get(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payments?ewallet=$wallet"),
      headers: header,
    );

    // print(list.body);

    if (list.statusCode == 200) {
      // print(json.decode(balacelist.body));

      var result = json.decode(list.body) as Map<dynamic, dynamic>;
      var r = result["data"] as List;

      paymentlenght = r.length;

      return result;
    } else {
      throw Exception();
    }
  } on SocketException {
    // print(e);
    rethrow;
  }
}
