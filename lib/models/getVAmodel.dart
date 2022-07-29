import 'dart:convert';
import 'package:http/http.dart';
import '../utilities/signature.dart';

class VirtualAccounts {
  VirtualAccounts({
    required this.status,
    required this.data,
  });

  final Status status;
  final Data data;

  factory VirtualAccounts.fromRawJson(String str) =>
      VirtualAccounts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VirtualAccounts.fromJson(Map<String, dynamic> json) =>
      VirtualAccounts(
        status: Status.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.ewallet,
    required this.bankAccounts,
  });

  final String ewallet;
  final List<BankAccount> bankAccounts;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ewallet: json["ewallet"],
        bankAccounts: List<BankAccount>.from(
            json["bank_accounts"].map((x) => BankAccount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ewallet": ewallet,
        "bank_accounts":
            List<dynamic>.from(bankAccounts.map((x) => x.toJson())),
      };
}

class BankAccount {
  BankAccount({
    required this.accountId,
    required this.accountIdType,
    required this.currency,
    required this.countryIso,
    required this.issuingId,
  });

  final String accountId;
  final String accountIdType;
  final String currency;
  final String countryIso;
  final String issuingId;

  factory BankAccount.fromRawJson(String str) =>
      BankAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        accountId: json["account_id"],
        accountIdType: json["account_id_type"],
        currency: json["currency"],
        countryIso: json["country_iso"],
        issuingId: json["issuing_id"],
      );

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "account_id_type": accountIdType,
        "currency": currency,
        "country_iso": countryIso,
        "issuing_id": issuingId,
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

// #####################################################################

// ######################## get virtual accounts associated to a wallet

Stream<VirtualAccounts> getVAacct(wallet) =>
    Stream.periodic(const Duration(seconds: 4))
        .asyncMap((event) => getvAccounts(wallet));

Future<VirtualAccounts> getvAccounts(String wallet) async {
  String uri =
      "https://sandboxapi.rapyd.net/v1/issuing/bankaccounts/list?ewallet=$wallet";

  await RequestInit()
      .getSignature("/v1/issuing/bankaccounts/list?ewallet=$wallet", "get");

  try {
    var listAcc = await get(
      Uri.parse(uri),
      headers: header,
    );

    // print(listAcc.body);

    if (listAcc.statusCode == 200) {
      var result = VirtualAccounts.fromJson(json.decode(listAcc.body));
      // print(result.data[7].name.toString());
      // print(listAcc.body);

      return result;
    } else {
      throw Exception(listAcc.statusCode);
    }
  } catch (e) {
    // throw Exception(e.toString());
    rethrow;
  }

  // print(result);
}

// https://sandboxapi.rapyd.net/v1/data/currencies
