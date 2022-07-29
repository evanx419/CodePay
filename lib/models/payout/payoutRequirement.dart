import 'dart:convert';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

// Request URL: GET https://sandboxapi.rapyd.net/v1/payouts/us_visa_card/details?beneficiary_country=us&beneficiary_entity_type=individual&payout_amount=251&payout_currency=usd&sender_country=us&sender_currency=usd&sender_entity_type=company

// Message body absent

Future getPayoutrequired(payoutmethod, bcountry, btype, amount, payoutcurrency,
    scountry, scurrency, stype) async {
  await RequestInit().getSignature(
      '/v1/payouts/$payoutmethod/details?beneficiary_country=$bcountry&beneficiary_entity_type=$btype&payout_amount=$amount&payout_currency=$payoutcurrency&sender_country=$scountry&sender_currency=$scurrency&sender_entity_type=$stype',
      "post");

  try {
    var list = await post(
      Uri.parse(
          "https://sandboxapi.rapyd.net/v1/payouts/$payoutmethod/details?beneficiary_country=$bcountry&beneficiary_entity_type=$btype&payout_amount=$amount&payout_currency=$payoutcurrency&sender_country=$scountry&sender_currency=$scurrency&sender_entity_type=$stype"),
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
