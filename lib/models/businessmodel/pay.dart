import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../utilities/urls.dart';

class Pay {
  Pay({
    required this.error,
    required this.errmsg,
    required this.data,
  });

  final bool error;
  final String errmsg;
  final List<Datum> data;

  factory Pay.fromRawJson(String str) => Pay.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pay.fromJson(Map<String, dynamic> json) => Pay(
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
    required this.balance,
    required this.ewallet,
    required this.myWallet,
    required this.currency,
    required this.postId,
    required this.date,
    required this.number,
  });

  final String id;
  final String balance;
  final String ewallet;
  final String myWallet;
  final String currency;
  final String postId;
  final String number;
  final String date;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        balance: json["balance"],
        ewallet: json["ewallet"],
        myWallet: json["myWallet"],
        currency: json["currency"],
        postId: json["postId"],
        date: json["date"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
        "ewallet": ewallet,
        "myWallet": myWallet,
        "currency": currency,
        "postId": postId,
        "number": number,
        "date": date,
      };
}






Future uploadTransactons(
    balance, ewallet, myWallet, currency, date, postId, number) async {
  try {
    var businessList = await post(
      Uri.parse(inserttransactions),
      body: {
        "balance": balance,
        "ewallet": ewallet,
        "myWallet": myWallet,
        "currency": currency,
        "postId": postId,
        "date": date,
        "number": number,
      },
    );

    if (businessList.statusCode == 200) {
      return businessList.body;
    } else {
      throw Exception();
    }
  } catch (e) {
    rethrow;
  }
}



List<String> _bizlist = [];
List<String> _bizbal = [];
List<String> _persons = [];




Future<Pay> gettransaction() async {
  try {
    var businessList = await get(
      Uri.parse(gettransactions),
    );
    // print(businessList.body);
    if (businessList.statusCode == 200) {
      var output = Pay.fromJson(json.decode(businessList.body));
      output.data.forEach((e) {
        _bizlist.add(e.postId);
        _bizbal.add(e.balance);
        _persons.add(e.number);
      });

      return output;
    } else {
      throw Exception();
    }
  } on SocketException {
    rethrow;
  }
}



Future deleteTransactons(myWallet, postId) async {
  try {
    var businessList = await post(
      Uri.parse(deletetransactions),
      body: {
        "myWallet": myWallet,
        "postId": postId,
      },
    );

    if (businessList.statusCode == 200) {
      return businessList.body;
    } else {
      throw Exception();
    }
  } catch (e) {
    rethrow;
  }
}
