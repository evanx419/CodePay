import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

class Simulate {
  Simulate({
    required this.status,
    required this.data,
  });

  final Status status;
  final Data data;

  factory Simulate.fromRawJson(String str) =>
      Simulate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Simulate.fromJson(Map<String, dynamic> json) => Simulate(
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
    required this.id,
    required this.merchantReferenceId,
    required this.ewallet,
    required this.bankAccount,
    required this.metadata,
    required this.status,
    required this.description,
    required this.fundingInstructions,
    required this.currency,
    required this.transactions,
  });

  final String id;
  final String merchantReferenceId;
  final String ewallet;
  final BankAccount bankAccount;
  final Metadata metadata;
  final String status;
  final dynamic description;
  final dynamic fundingInstructions;
  final String currency;
  final List<Transaction> transactions;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        merchantReferenceId: json["merchant_reference_id"],
        ewallet: json["ewallet"],
        bankAccount: BankAccount.fromJson(json["bank_account"]),
        metadata: Metadata.fromJson(json["metadata"]),
        status: json["status"],
        description: json["description"],
        fundingInstructions: json["funding_instructions"],
        currency: json["currency"],
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "merchant_reference_id": merchantReferenceId,
        "ewallet": ewallet,
        "bank_account": bankAccount.toJson(),
        "metadata": metadata.toJson(),
        "status": status,
        "description": description,
        "funding_instructions": fundingInstructions,
        "currency": currency,
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}

class BankAccount {
  BankAccount({
    required this.iban,
  });

  String? iban;

  factory BankAccount.fromRawJson(String str) =>
      BankAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        iban: json["iban"],
      );

  Map<String, dynamic> toJson() => {
        "iban": iban,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromRawJson(String str) =>
      Metadata.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}

class Transaction {
  Transaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.createdAt,
  });

  final String id;
  final int amount;
  final String currency;
  final int createdAt;

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        amount: json["amount"],
        currency: json["currency"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "currency": currency,
        "created_at": createdAt,
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

Future<Simulate> simulateTx(acctnum, currency, amount) async {
  var _myBody = jsonEncode(
      {"issued_bank_account": acctnum, "amount": amount, "currency": currency});

  await RequestInit().getSignature(
      "/v1/issuing/bankaccounts/bankaccounttransfertobankaccount", "post",
      bodyData: _myBody);

  try {
    var simulatetx = await post(
      Uri.parse(
          "https://sandboxapi.rapyd.net/v1/issuing/bankaccounts/bankaccounttransfertobankaccount"),
      headers: header,
      body: _myBody,
    );

    // print(simulatetx.body);

    if (simulatetx.statusCode == 200) {
      return Simulate.fromJson(json.decode(simulatetx.body));
    } else {
      throw Exception(simulatetx);
    }
  } on SocketException {
    rethrow;
  }
}
