import 'dart:convert';
import 'dart:io';
import 'package:guavapay/utilities/urls.dart';
import 'package:http/http.dart';

class Userpayment {
  Userpayment({
    required this.error,
    required this.errmsg,
    required this.data,
  });

  final bool error;
  final String errmsg;
  final List<Datum> data;

  factory Userpayment.fromRawJson(String str) =>
      Userpayment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Userpayment.fromJson(Map<String, dynamic> json) => Userpayment(
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
    required this.method,
    required this.amount,
    required this.balance,
    required this.status,
    required this.currency,
    required this.postId,
    required this.number,
  });

  final String id;
  final String mywallet;
  final String method;
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
        method: json["method"],
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
        "method": method,
        "amount": amount,
        "balance": balance,
        "status": status,
        "currency": currency,
        "postId": postId,
        "number": number,
      };
}

Future postuserpayment(
  mywallet,
  method,
  amount,
  balance,
  status,
  currency,
  number,
) async {
  try {
    var businessList = await post(
      Uri.parse(postpayment),
      body: {
        "mywallet": mywallet,
        "method": method,
        "amount": amount,
        "balance": balance,
        "status": status,
        "currency": currency,
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

Future<Userpayment> getuserpayment() async {
  try {
    var payment = await get(
      Uri.parse(getpayment),
    );
    // print(payout.body);

    if (payment.statusCode == 200) {
      var result = Userpayment.fromJson(json.decode(payment.body));

      result.data.forEach((e) {
        bizlist.add(e.mywallet);
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

Future deletepayment(myWallet) async {
  try {
    var dlt = await post(
      Uri.parse(deletetpayment),
      body: {
        "myWallet": myWallet,
      },
    );

    if (dlt.statusCode == 200) {
      return dlt.body;
    } else {
      throw Exception();
    }
  } catch (e) {
    rethrow;
  }
}
