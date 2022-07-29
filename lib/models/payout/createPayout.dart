import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';



Future createPayout(
    method,
    mywallet,
    amount,
    payoutcurrency,
    scurrency,
    scountry,
    stype,
    btype,
    bcountry,
    bname,
    email,
    lname,
    fname,
    mach,
    wallet,
    acctnumber,
    category) async {
  var _myBody = jsonEncode({
    "payout_method_type": method,
    "ewallet": mywallet,
    "description": "Confirmation Required",
    "payout_amount": amount,
    "payout_currency": payoutcurrency,
    "sender_country": scountry,
    "sender_currency": scurrency,
    "sender_entity_type": stype,
    // "category": category,
    "sender": {},
    "beneficiary_entity_type": btype,
    "confirm_automatically": true,
    "beneficiary_country": bcountry,
    "payout_fees": {
      "transaction_fee": {
        "calc_type": "gross",
        "fee_type": "percentage",
        "value": 0.5
      },
      "fx_fee": {
        "calc_type": "gross",
        "fee_type": "percentage",
        "value": 0.5,
      },
    },
    "beneficiary": {
      "name": bname,
      "email": email,
      "last_name": lname,
      "first_name": fname,
      "payout_method_type": method,
      "merchant_reference_id": mach,
      "confirmation_required": false,
      "account_number": acctnumber,
      "ewallet": wallet
    },
  });

// "card_number": "1111",
  // "card_expiration_year": "23",
  // "identification_value": "123456789",
  // "card_expiration_month": "11",

//    "category": "bank",
//     "company_name": "All Star Limousine",
//     "country": "US",
//     "currency": "USD",
//     "entity_type": "company",
//     "identification_type": "company_registered_number",
//     "identification_value": "9876543210",
//     "merchant_reference_id": "AllStarLimo",
// // Fields from 'beneficiary_required_fields' in the response to 'Get Payout Method Type Required Fields'
//     "account_number": "0987654321",
//     "aba": "987654321"

  await RequestInit().getSignature("/v1/payouts", "post", bodyData: _myBody);

  try {
    var create = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/payouts"),
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
