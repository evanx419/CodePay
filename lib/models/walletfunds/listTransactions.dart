import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

class TransactionsClass {
  TransactionsClass({
    required this.status,
    required this.data,
  });


    final Status status;
    final List<Datum> data;

    factory TransactionsClass.fromRawJson(String str) => TransactionsClass.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TransactionsClass.fromJson(Map<String, dynamic> json) => TransactionsClass(
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
        required this.id,
        required this.currency,
        // required this.amount,
        required this.ewalletId,
        required this.type,
        required this.balanceType,
        // required this.balance,
        required this.destinationEwalletId,
        required this.sourceEwalletId,
        required this.createdAt,
        required this.status,
        required this.reason,
        required this.metadata,
    });

    final String id;
    final String currency;
    // final double amount;
    final String ewalletId;
    final String type;
    final String balanceType;
    // final double balance;
    final String? destinationEwalletId;
    final String? sourceEwalletId;
    final int createdAt;
    final String status;
    final String reason;
    final Metadata metadata;

    // factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        currency: json["currency"],
        // amount: json["amount"],
        ewalletId: json["ewallet_id"],
        type: json["type"],
        balanceType: json["balance_type"],
        // balance: json["balance"] ,
        destinationEwalletId: json["destination_ewallet_id"],
        sourceEwalletId: json["source_ewallet_id"],
        createdAt: json["created_at"],
        status: json["status"],
        reason: json["reason"],
        metadata: Metadata.fromJson(json["metadata"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "currency": currency,
        // "amount": amount,
        "ewallet_id": ewalletId,
        "type": type,
        "balance_type": balanceType,
        // "balance": balance,
        "destination_ewallet_id": destinationEwalletId,
        "source_ewallet_id": sourceEwalletId,
        "created_at": createdAt,
        "status": status,
        "reason": reason,
        "metadata": metadata.toJson(),
    };
}

class Metadata {
    Metadata();

    factory Metadata.fromRawJson(String str) => Metadata.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    );

    Map<String, dynamic> toJson() => {
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



// TransactionsClass? walletTransList;

Future<TransactionsClass> walletTransactions(String wallet) async {
  await RequestInit().getSignature('/v1/user/$wallet/transactions', "get");

  try {
    var transactionlist = await get(
      Uri.parse("https://sandboxapi.rapyd.net/v1/user/$wallet/transactions"),
      headers: header,
    );

    // print(transactionlist.body);

    if (transactionlist.statusCode == 200) {

      var result = TransactionsClass.fromJson(json.decode(transactionlist.body));

      // walletTransList = result;

      return result;
    } else {
      throw Exception();
    }
  } on SocketException {
    // print(e);
    rethrow;
  }
}
