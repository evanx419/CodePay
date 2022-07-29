import 'dart:convert';
import 'dart:io';

import 'package:guavapay/utilities/urls.dart';
import 'package:http/http.dart';

class Users {
  Users({
    required this.error,
    required this.errmsg,
    required this.data,
  });

  final bool error;
  final String errmsg;
  final List<Datum> data;

  factory Users.fromRawJson(String str) => Users.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Users.fromJson(Map<String, dynamic> json) => Users(
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
    required this.email,
    required this.walletId,
    required this.refId,
    required this.imgUrl,
    required this.pwd,
  });

  final String id;
  final String email;
  final String walletId;
  final String refId;
  final String imgUrl;
  final String pwd;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        email: json["email"],
        walletId: json["wallet_id"],
        refId: json["ref_id"],
        imgUrl: json["imgUrl"],
        pwd: json["pwd"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "wallet_id": walletId,
        "ref_id": refId,
        "imgUrl": imgUrl,
        "pwd": pwd,
      };
}

List<String> profilePix = [];
List<String> userswallet = [];

Future<Users> getUsers() async {
  List pix = [];
  List wallet = [];
  try {
    var userList = await get(
      Uri.parse(fetchusers),
    );
// print(userList.body);
    if (userList.statusCode == 200) {
      var ur = Users.fromJson(json.decode(userList.body));

      ur.data.forEach((e) {
        pix.add(e.imgUrl);
        wallet.add(e.walletId);
      });

      profilePix = pix.cast<String>();
      userswallet = wallet.cast<String>();

      return ur;
    } else {
      throw Exception();
    }
  } on SocketException {
    rethrow;
  }
}

Future postUsers(email, wallet, ref, img, pwd) async {
  try {
    var userList = await post(
      Uri.parse(insertusers),
      body: {
        "email": email,
        "wallet_id": wallet,
        "ref_id": ref,
        "imgUrl": img,
        "pwd": pwd,
      },
    );

    if (userList.statusCode == 200) {
      return userList.body;
    } else {
      throw Exception();
    }
  } catch (e) {
    rethrow;
  }
}

Future updateUsers(wallet, img) async {
  try {
    var update = await post(
      Uri.parse(updateusers),
      body: {
        "wallet_id": wallet.toString(),
        "status": "successful",
        "imgUrl": img.toString(),
      },
    );

    if (update.statusCode == 200) {
      print(update.body);
      return update.body;
    } else {
      throw Exception();
    }
  } catch (e) {
    rethrow;
  }
}
