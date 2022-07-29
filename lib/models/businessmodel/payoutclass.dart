import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../utilities/urls.dart';

class Payoutclass {
  Payoutclass({
    required this.error,
    required this.errmsg,
    required this.data,
  });

  final bool error;
  final String errmsg;
  final List<Datum> data;

  factory Payoutclass.fromRawJson(String str) =>
      Payoutclass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Payoutclass.fromJson(Map<String, dynamic> json) => Payoutclass(
        error: json["error"],
        errmsg: json["errmsg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "errmsg": errmsg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.mywallet,
    required this.wallet,
    required this.amount, 
    required this.balance,
    required this.status,
    required this.currency,
    required this.postId,
    required this.number,
  });

  final String id;
  final String mywallet;
  final String wallet;
  final String amount;
  final String balance;
  final String status;
  final String currency;
  final String postId;
  final String number;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["Id"],
        mywallet: json["mywallet"],
        wallet: json["wallet"],
        amount: json["amount"],
        balance: json["balance"],
        status: json["status"],
        currency: json["currency"],
        postId: json["postId"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "mywallet": mywallet,
        "wallet": wallet,
        "amount": amount,
        "balance": balance,
        "status": status,
        "currency": currency,
        "postId": postId,
        "number": number,
      };
}

Future postuserpayout(
    mywallet, wallet, amout, balance, status, currency, postid, number) async {
  try {
    var businessList = await post(
      Uri.parse(postpayout),
      body: {
        "mywallet": mywallet,
        "wallet": wallet,
        "amount": amout,
        "balance": balance,
        "status": status,
        "currency": currency,
        "postId": postid,
        "number": number,
      },
    );

    if (businessList.statusCode == 200) {
      return businessList.body;
    } else {
      throw Exception();
    }
  } on SocketException {
    rethrow;
  }
}

List<String> bizlist = [];
List<String> bizbal = [];
List<String> persons = [];
List<String> balcurrency = [];

Future<Payoutclass> getuserpayout() async {
  try {
    var payout = await get(
      Uri.parse(getpayout),
    );
    // print(payout.body);

    if (payout.statusCode == 200) {
      var result = Payoutclass.fromJson(json.decode(payout.body));

      result.data.forEach((e) {
        bizlist.add(e.postId);
        bizbal.add(e.balance);
        persons.add(e.number);
        balcurrency.add(e.currency);
      });
      return result;
    } else {
      throw Exception();
    }
  } on SocketException {
    rethrow;
  }
}



