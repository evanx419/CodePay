import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

Future createCustomer() async {
  var _myBody = jsonEncode({
    // "business_vat_id": "123456789",
    "email": "klindcg@rapyd.net",
    "ewallet": "ewallet_5b52b9f7df0ed4b3de29be00c786bc62",
    "invoice_prefix": "JD-",
    "metadata": {"merchant_defined": true},
    "name": "John Doe",
    "phone_number": "+14155559993"
  });

// ewallet_41e7e61d1381f6e95c9d5e922d3ea071

// ewallet_41092a1c255e5c8992b9a27393721150

  await RequestInit().getSignature("/v1/customers", "post", bodyData: _myBody);

  try {
    var create = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/customers"),
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






// {"status":{"error_code":"","status":"SUCCESS","message":"","response_code":"","operation_id":"2219c326-b8af-4bcf-8f65-d5bb4e9e7eaf"},
// "data":{"id":"cus_5d5df611edf5db5bd7fa8ee4c3740753","delinquent":false,"discount":null,"name":"John Doe",
// "default_payment_method":"","description":"","email":"klindcg@rapyd.net","phone_number":"+14155559993","invoice_prefix":"JD-","
// addresses":[],"payment_methods":null,"subscriptions":null,"created_at":1657515343,"metadata":{"merchant_defined":true},
// "business_vat_id":"","ewallet":"ewallet_5b52b9f7df0ed4b3de29be00c786bc62"}}













// // Request URL: POST https://sandboxapi.rapyd.net/v1/customers

// // Message body:
// {
//     "business_vat_id": "123456789",
//     "email": "johndoe@rapyd.net",
//     "ewallet": "ewallet_ebfe4c4f4d36b076a21369fb0d055f3e",
//     "invoice_prefix": "JD-",
//     "metadata": {
//     	"merchant_defined": true
//     },
//     "name": "John Doe",
//     "phone_number": "+14155559993"
// }