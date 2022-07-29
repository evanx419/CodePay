import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../utilities/signature.dart';

class CustomerpaymentMethodClass {
  CustomerpaymentMethodClass({
    required this.status,
    required this.data,
  });

  final Status status;
  final List<Datum> data;

  factory CustomerpaymentMethodClass.fromRawJson(String str) =>
      CustomerpaymentMethodClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerpaymentMethodClass.fromJson(Map<String, dynamic> json) =>
      CustomerpaymentMethodClass(
        status: Status.fromJson(json["status"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.type,
    required this.name,
    required this.category,
    required this.image,
    required this.country,
    required this.paymentFlowType,
    required this.currencies,
    required this.status,
    required this.isCancelable,
    required this.paymentOptions,
    required this.isExpirable,
    required this.isOnline,
    required this.isRefundable,
    required this.minimumExpirationSeconds,
    required this.maximumExpirationSeconds,
    required this.virtualPaymentMethodType,
    required this.isVirtual,
    required this.multipleOverageAllowed,
    required this.amountRangePerCurrency,
    required this.isTokenizable,
    required this.supportedDigitalWalletProviders,
  });

  final String type;
  final String name;
  final Category? category;
  final String image;
  final Country? country;
  final Category? paymentFlowType;
  final List<Currency>? currencies;
  final int status;
  final bool isCancelable;
  final List<PaymentOption> paymentOptions;
  final bool isExpirable;
  final bool isOnline;
  final bool isRefundable;
  final int minimumExpirationSeconds;
  final int maximumExpirationSeconds;
  final String virtualPaymentMethodType;
  final bool isVirtual;
  final bool multipleOverageAllowed;
  final List<AmountRangePerCurrency> amountRangePerCurrency;
  final bool isTokenizable;
  final List<dynamic> supportedDigitalWalletProviders;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["type"],
        name: json["name"],
        category: categoryValues.map![json["category"]],
        image: json["image"],
        country: countryValues.map![json["country"]],
        paymentFlowType: categoryValues.map![json["payment_flow_type"]],
        currencies: List<Currency>.from(
            json["currencies"].map((x) => currencyValues.map![x])),
        status: json["status"],
        isCancelable: json["is_cancelable"],
        paymentOptions: List<PaymentOption>.from(
            json["payment_options"].map((x) => PaymentOption.fromJson(x))),
        isExpirable: json["is_expirable"],
        isOnline: json["is_online"],
        isRefundable: json["is_refundable"],
        minimumExpirationSeconds: json["minimum_expiration_seconds"],
        maximumExpirationSeconds: json["maximum_expiration_seconds"],
        virtualPaymentMethodType: json["virtual_payment_method_type"],
        isVirtual: json["is_virtual"],
        multipleOverageAllowed: json["multiple_overage_allowed"],
        amountRangePerCurrency: List<AmountRangePerCurrency>.from(
            json["amount_range_per_currency"]
                .map((x) => AmountRangePerCurrency.fromJson(x))),
        isTokenizable: json["is_tokenizable"],
        supportedDigitalWalletProviders: List<dynamic>.from(
            json["supported_digital_wallet_providers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "category": categoryValues.reverse![category],
        "image": image,
        "country": countryValues.reverse![country],
        "payment_flow_type": categoryValues.reverse![paymentFlowType],
        "currencies": List<dynamic>.from(
            currencies!.map((x) => currencyValues.reverse![x])),
        "status": status,
        "is_cancelable": isCancelable,
        "payment_options":
            List<dynamic>.from(paymentOptions.map((x) => x.toJson())),
        "is_expirable": isExpirable,
        "is_online": isOnline,
        "is_refundable": isRefundable,
        "minimum_expiration_seconds": minimumExpirationSeconds,
        "maximum_expiration_seconds": maximumExpirationSeconds,
        "virtual_payment_method_type": virtualPaymentMethodType,
        "is_virtual": isVirtual,
        "multiple_overage_allowed": multipleOverageAllowed,
        "amount_range_per_currency":
            List<dynamic>.from(amountRangePerCurrency.map((x) => x.toJson())),
        "is_tokenizable": isTokenizable,
        "supported_digital_wallet_providers":
            List<dynamic>.from(supportedDigitalWalletProviders.map((x) => x)),
      };
}

class AmountRangePerCurrency {
  AmountRangePerCurrency({
    required this.currency,
    required this.maximumAmount,
    required this.minimumAmount,
  });

  final Currency? currency;
  final int maximumAmount;
  final int minimumAmount;

  factory AmountRangePerCurrency.fromRawJson(String str) =>
      AmountRangePerCurrency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AmountRangePerCurrency.fromJson(Map<String, dynamic> json) =>
      AmountRangePerCurrency(
        currency: currencyValues.map![json["currency"]],
        maximumAmount:
            json["maximum_amount"] == null ? null : json["maximum_amount"],
        minimumAmount:
            json["minimum_amount"] == null ? null : json["minimum_amount"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currencyValues.reverse![currency],
        "maximum_amount": maximumAmount == null ? null : maximumAmount,
        "minimum_amount": minimumAmount == null ? null : minimumAmount,
      };
}

enum Currency { USD }

final currencyValues = EnumValues({"USD": Currency.USD});

enum Category {
  CASH,
  BANK_REDIRECT,
  EWALLET,
  CARD,
  BANK_TRANSFER,
  BANK,
  E_WALLET
}

final categoryValues = EnumValues({
  "bank": Category.BANK,
  "bank_redirect": Category.BANK_REDIRECT,
  "bank_transfer": Category.BANK_TRANSFER,
  "card": Category.CARD,
  "cash": Category.CASH,
  "ewallet": Category.EWALLET,
  "eWallet": Category.E_WALLET
});

enum Country { US, COUNTRY_US }

final countryValues = EnumValues({"us": Country.COUNTRY_US, "US": Country.US});

class PaymentOption {
  PaymentOption({
    required this.name,
    required this.type,
    required this.regex,
    required this.description,
    required this.isRequired,
    required this.isUpdatable,
  });

  final String name;
  final String type;
  final String regex;
  final String description;
  final bool isRequired;
  final bool isUpdatable;

  factory PaymentOption.fromRawJson(String str) =>
      PaymentOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
        name: json["name"],
        type: json["type"],
        regex: json["regex"],
        description: json["description"],
        isRequired: json["is_required"],
        isUpdatable: json["is_updatable"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "regex": regex,
        "description": description,
        "is_required": isRequired,
        "is_updatable": isUpdatable,
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

  final String errorCode;
  final String status;
  final String message;
  final String responseCode;
  final String operationId;

  factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        errorCode: json["error_code"],
        status: json["status"],
        message: json["message"],
        responseCode: json["response_code"],
        operationId: json["operation_id"],
      );

  Map<String, dynamic> toJson() => {
        "error_code": errorCode,
        "status": status,
        "message": message,
        "response_code": responseCode,
        "operation_id": operationId,
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}



List datadata = [];

Future getPaymentlistMethod(country, currency) async {
  await RequestInit().getSignature(
      '/v1/payment_methods/country?country=$country&currency=$currency', "get");

  try {
    var list = await get(
      Uri.parse(
          "https://sandboxapi.rapyd.net/v1/payment_methods/country?country=$country&currency=$currency"),
      headers: header,
    );

    // print(list.body);
 
    if (list.statusCode == 200) {
      // print(json.decode(balacelist.body));

      var result = json.decode(list.body) as Map<dynamic, dynamic>;

      // print(result["data"][20]["type"]);

      return result;
    } else {
      throw Exception();
    }
  } on SocketException {
    // print(e);
    rethrow;
  }
}
