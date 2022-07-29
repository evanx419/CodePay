import 'dart:convert';

import 'package:http/http.dart';

import '../../utilities/signature.dart';

Future getcustomersList() async {
  await RequestInit().getSignature('/v1/customers?limit=10', "get");

  try {
    var list = await get(
      Uri.parse("https://sandboxapi.rapyd.net/v1/customers?limit=10"),
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
  } catch (e) {
    // print(e);
    throw Exception(e);
  }
}
