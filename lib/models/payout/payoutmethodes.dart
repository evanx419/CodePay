import 'dart:convert';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

class PayoutMethodClass {
  PayoutMethodClass({
    required this.status,
    required this.data,
  });

  final Status status;
  final List<Datum> data;

  factory PayoutMethodClass.fromRawJson(String? str) =>
      PayoutMethodClass.fromJson(json.decode(str!));

  String? toRawJson() => json.encode(toJson());

  factory PayoutMethodClass.fromJson(Map<String?, dynamic> json) =>
      PayoutMethodClass(
        status: Status.fromJson(json["status"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String?, dynamic> toJson() => {
        "status": status.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.payoutMethodType,
    required this.name,
    required this.isCancelable,
    required this.isExpirable,
    required this.isLocationSpecific,
    required this.status,
    required this.image,
    required this.category,
    required this.beneficiaryCountry,
    required this.senderCountry,
    required this.payoutCurrencies,
    required this.senderEntityTypes,
    required this.beneficiaryEntityTypes,
    required this.amountRangePerCurrency,
    required this.minimumExpirationSeconds,
    required this.maximumExpirationSeconds,
    required this.senderCurrencies,
  });

  final String? payoutMethodType;
  final String? name;
  final int isCancelable;
  final int isExpirable;
  final int isLocationSpecific;
  final int status;
  final String? image;
  final String? category;
  final String? beneficiaryCountry;
  final String? senderCountry;
  final List<String?> payoutCurrencies;
  final List<String?> senderEntityTypes;
  final List<String?> beneficiaryEntityTypes;
  final List<AmountRangePerCurrency> amountRangePerCurrency;
  final dynamic minimumExpirationSeconds;
  final dynamic maximumExpirationSeconds;
  final List<String?> senderCurrencies;

  factory Datum.fromRawJson(String? str) => Datum.fromJson(json.decode(str!));

  String? toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String?, dynamic> json) => Datum(
        payoutMethodType: json["payout_method_type"],
        name: json["name"],
        isCancelable: json["is_cancelable"],
        isExpirable: json["is_expirable"],
        isLocationSpecific: json["is_location_specific"],
        status: json["status"],
        image: json["image"],
        category: json["category"],
        beneficiaryCountry: json["beneficiary_country"],
        senderCountry: json["sender_country"],
        payoutCurrencies:
            List<String?>.from(json["payout_currencies"].map((x) => x)),
        senderEntityTypes:
            List<String?>.from(json["sender_entity_types"].map((x) => x)),
        beneficiaryEntityTypes:
            List<String?>.from(json["beneficiary_entity_types"].map((x) => x)),
        amountRangePerCurrency: List<AmountRangePerCurrency>.from(
            json["amount_range_per_currency"]
                .map((x) => AmountRangePerCurrency.fromJson(x))),
        minimumExpirationSeconds: json["minimum_expiration_seconds"],
        maximumExpirationSeconds: json["maximum_expiration_seconds"],
        senderCurrencies:
            List<String?>.from(json["sender_currencies"].map((x) => x)),
      );

  Map<String?, dynamic> toJson() => {
        "payout_method_type": payoutMethodType,
        "name": name,
        "is_cancelable": isCancelable,
        "is_expirable": isExpirable,
        "is_location_specific": isLocationSpecific,
        "status": status,
        "image": image,
        "category": category,
        "beneficiary_country": beneficiaryCountry,
        "sender_country": senderCountry,
        "payout_currencies": List<dynamic>.from(payoutCurrencies.map((x) => x)),
        "sender_entity_types":
            List<dynamic>.from(senderEntityTypes.map((x) => x)),
        "beneficiary_entity_types":
            List<dynamic>.from(beneficiaryEntityTypes.map((x) => x)),
        "amount_range_per_currency":
            List<dynamic>.from(amountRangePerCurrency.map((x) => x.toJson())),
        "minimum_expiration_seconds": minimumExpirationSeconds,
        "maximum_expiration_seconds": maximumExpirationSeconds,
        "sender_currencies": List<dynamic>.from(senderCurrencies.map((x) => x)),
      };
}

class AmountRangePerCurrency {
  AmountRangePerCurrency({
    required this.maximumAmount,
    required this.minimumAmount,
    required this.payoutCurrency,
  });

  final dynamic maximumAmount;
  final dynamic minimumAmount;
  final String? payoutCurrency;

  factory AmountRangePerCurrency.fromRawJson(String? str) =>
      AmountRangePerCurrency.fromJson(json.decode(str!));

  String? toRawJson() => json.encode(toJson());

  factory AmountRangePerCurrency.fromJson(Map<String?, dynamic> json) =>
      AmountRangePerCurrency(
        maximumAmount: json["maximum_amount"],
        minimumAmount: json["minimum_amount"],
        payoutCurrency: json["payout_currency"],
      );

  Map<String?, dynamic> toJson() => {
        "maximum_amount": maximumAmount,
        "minimum_amount": minimumAmount,
        "payout_currency": payoutCurrency,
      };
}

class Status {
  Status({
    required this.errorCode,
    required this.status,
    required this.message,
    required this.responseCode,
    required this.operationId,
  });

  final String? errorCode;
  final String? status;
  final String? message;
  final String? responseCode;
  final String? operationId;

  factory Status.fromRawJson(String? str) => Status.fromJson(json.decode(str!));

  String? toRawJson() => json.encode(toJson());

  factory Status.fromJson(Map<String?, dynamic> json) => Status(
        errorCode: json["error_code"],
        status: json["status"],
        message: json["message"],
        responseCode: json["response_code"],
        operationId: json["operation_id"],
      );

  Map<String?, dynamic> toJson() => {
        "error_code": errorCode,
        "status": status,
        "message": message,
        "response_code": responseCode,
        "operation_id": operationId, 
      };
}

Future getPayoutlistMethod(currency) async { 
  await RequestInit().getSignature(
      '/v1/payouts/supported_types?payout_currency=$currency&limit=20', "get");

  try {
    var list = await get(
      Uri.parse(
          "https://sandboxapi.rapyd.net/v1/payouts/supported_types?payout_currency=$currency&limit=20"),
      headers: header,
    );

    print(list.body);

    if (list.statusCode == 200) {
      var result = json.decode(list.body) as Map<dynamic, dynamic>;

      return result;
    } else {
      throw Exception();
    }
  } catch (e) {
    // print(e);
    throw Exception(e);
  }
}
