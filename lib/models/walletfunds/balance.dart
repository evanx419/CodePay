import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../utilities/signature.dart';

class Balaceclass {
  Balaceclass({
    required this.status,
    required this.data,
  });

  final Status status;
  final List<Datum> data;

  factory Balaceclass.fromRawJson(String str) =>
      Balaceclass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Balaceclass.fromJson(Map<String, dynamic> json) => Balaceclass(
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
    required this.alias,
    required this.balance,
    required this.receivedBalance,
    required this.onHoldBalance,
    required this.reserveBalance,
    required this.limits,
    required this.limit,
  });

  final String id;
  final String currency;
  final String alias;
  final num balance;
  final num receivedBalance;
  final num onHoldBalance;
  final num reserveBalance;
  final dynamic limits;
  final dynamic limit;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        currency: json["currency"],
        alias: json["alias"],
        balance: json["balance"],
        receivedBalance: json["received_balance"],
        onHoldBalance: json["on_hold_balance"],
        reserveBalance: json["reserve_balance"],
        limits: json["limits"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency": currency,
        "alias": alias,
        // "balance": balance,
        "received_balance": receivedBalance,
        "on_hold_balance": onHoldBalance,
        "reserve_balance": reserveBalance,
        "limits": limits,
        "limit": limit,
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

Stream<Balaceclass> streamBalanace(wallet) =>
    Stream.periodic(const Duration(seconds: 4))
        .asyncMap((event) => walletbalace(wallet));

Future<Balaceclass> walletbalace(String wallet) async {
  await RequestInit().getSignature('/v1/user/$wallet/accounts', "get");

  try {
    var balacelist = await get(
      Uri.parse("https://sandboxapi.rapyd.net/v1/user/$wallet/accounts"),
      headers: header,
    );

    // print(balacelist.body);

    if (balacelist.statusCode == 200) {

      var result = Balaceclass.fromJson(json.decode(balacelist.body));

      return result;
    } else {
      throw Exception();
    }
  } on SocketException {
    // print(e);
    rethrow;
  }
}
