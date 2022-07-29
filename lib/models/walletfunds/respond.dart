import 'dart:convert';

import 'package:http/http.dart';

import '../../utilities/signature.dart';

class Respond {
  Respond({
    required this.status,
    required this.data,
  });

  final Status status;
  final Data data;

  factory Respond.fromRawJson(String str) => Respond.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Respond.fromJson(Map<String, dynamic> json) => Respond(
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
    required this.status,
    required this.amount,
    required this.currencyCode,
    required this.destinationPhoneNumber,
    required this.destinationEwalletId,
    required this.destinationTransactionId,
    required this.sourceEwalletId,
    required this.sourceTransactionId,
    required this.transferResponseAt,
    required this.createdAt,
    required this.metadata,
    required this.responseMetadata,
  });

  final String id;
  final String status;
  final int amount;
  final String currencyCode;
  final dynamic destinationPhoneNumber;
  final String destinationEwalletId;
  final String destinationTransactionId;
  final String sourceEwalletId;
  final String sourceTransactionId;
  final int transferResponseAt;
  final int createdAt;
  final Metadata metadata;
  final ResponseMetadata responseMetadata;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        amount: json["amount"],
        currencyCode: json["currency_code"],
        destinationPhoneNumber: json["destination_phone_number"],
        destinationEwalletId: json["destination_ewallet_id"],
        destinationTransactionId: json["destination_transaction_id"],
        sourceEwalletId: json["source_ewallet_id"],
        sourceTransactionId: json["source_transaction_id"],
        transferResponseAt: json["transfer_response_at"],
        createdAt: json["created_at"],
        metadata: Metadata.fromJson(json["metadata"]),
        responseMetadata: ResponseMetadata.fromJson(json["response_metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "amount": amount,
        "currency_code": currencyCode,
        "destination_phone_number": destinationPhoneNumber,
        "destination_ewallet_id": destinationEwalletId,
        "destination_transaction_id": destinationTransactionId,
        "source_ewallet_id": sourceEwalletId,
        "source_transaction_id": sourceTransactionId,
        "transfer_response_at": transferResponseAt,
        "created_at": createdAt,
        "metadata": metadata.toJson(),
        "response_metadata": responseMetadata.toJson(),
      };
}

class Metadata {
  Metadata({
    required this.merchantDefined,
  });

  final bool merchantDefined;

  factory Metadata.fromRawJson(String str) =>
      Metadata.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        merchantDefined: json["merchant_defined"],
      );

  Map<String, dynamic> toJson() => {
        "merchant_defined": merchantDefined,
      };
}

class ResponseMetadata {
  ResponseMetadata({
    required this.merchantDefined,
  });

  final String merchantDefined;

  factory ResponseMetadata.fromRawJson(String str) =>
      ResponseMetadata.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseMetadata.fromJson(Map<String, dynamic> json) =>
      ResponseMetadata(
        merchantDefined: json["merchant_defined"],
      );

  Map<String, dynamic> toJson() => {
        "merchant_defined": merchantDefined,
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








Future<Respond> txRespond(id, status, meta) async {
  var _myBody = jsonEncode({
    "id": id,
    "metadata": {
      "merchant_defined": meta,
    },
    "status": status
  });

  await RequestInit()
      .getSignature("/v1/account/transfer/response", "post", bodyData: _myBody);

  try {
    var transactionResponse = await post(
      Uri.parse("https://sandboxapi.rapyd.net/v1/account/transfer/response"),
      headers: header,
      body: _myBody,
    );

    // print(transactionResponse.body);

    if (transactionResponse.statusCode == 200) {
      return Respond.fromJson(json.decode(transactionResponse.body));
    } else {
      // print(transactionResponse.body);
      throw Exception(transactionResponse);
    }
  } catch (error) {
    throw Exception(error);
  }
}
