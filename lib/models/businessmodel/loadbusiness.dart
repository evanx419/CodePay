import 'dart:convert';
import 'dart:io';
import 'package:guavapay/utilities/urls.dart';
import 'package:http/http.dart';

class BusinessClass {
  BusinessClass({
    required this.error,
    required this.errmsg,
    required this.data,
  });




    final bool error;
    final String errmsg;
    final List<Datum> data;

    factory BusinessClass.fromRawJson(String str) => BusinessClass.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BusinessClass.fromJson(Map<String, dynamic> json) => BusinessClass(
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
        required this.name,
        required this.description,
        required this.amount,
        required this.payoutcurrency,
        required this.date,
        required this.phone,
        required this.img,
        required this.wallet,
        required this.status,
    });

    final String id;
    final String name;
    final String description;
    final String amount;
    final String payoutcurrency;
    final String date;
    String? phone;
    final String img;
    final String wallet;
    final String status;

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        amount: json["amount"],
        payoutcurrency: json["payoutcurrency"],
        date: json["date"],
        phone: json["phone"],
        img: json["img"],
        wallet: json["wallet"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "amount": amount,
        "phone": phone,
        "payoutcurrency": payoutcurrency,
        "date": date,
        "img": img,
        "wallet": wallet,
        "status": status,
    };
}







Future uploadBuiness(name, description, amount,phone, payoutcurrency, date, img, wallet, status) async {
  try {
    var businessList = await post(
      Uri.parse(postbusiness),
      body: {
        "name": name,
        "description": description,
        "amount": amount,
        "phone": phone,
        "payoutcurrency": payoutcurrency,
        "date": date,
        "img": img,
        "wallet": wallet,
        "status": status,
      },
    );

    // print(businessList.body);
    if (businessList.statusCode == 200) {
      return businessList.body;
    } else {
      throw Exception();
    }
  } on SocketException {
    rethrow;
  }
}





Stream<BusinessClass> streamBusiness() =>
    Stream.periodic(const Duration(seconds: 4)).asyncMap(
      (event) => getbusiness(),
    );


BusinessClass? business;

Future<BusinessClass> getbusiness() async {
  try {
    var businessList = await get(
      Uri.parse(fetchbusiness),
    );

    if (businessList.statusCode == 200) {
      var output = BusinessClass.fromJson(json.decode(businessList.body));

      business = output;
      return output;
    } else {
      throw Exception();
    }
  } on SocketException {
    rethrow;
  }
}
