import 'package:http/http.dart';

import '../utilities/signature.dart';

Future test() async {
  String uri =
      "https://sandboxapi.rapyd.net/v1/issuing/bankaccounts/capabilities/country=SG&currency=SGD";

  await RequestInit().getSignature(
      "/v1/issuing/bankaccounts/capabilities/country=SG&currency=SGD", "get");

  try {
    var listAcc = await get(
      Uri.parse(uri),
      headers: header,
    );

    print(listAcc.body);
  } catch (e) {
    rethrow;
  }
}
