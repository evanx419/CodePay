import 'dart:io';

import 'package:http/http.dart';
import '../utilities/signature.dart';
import 'dart:convert';

class WalletClass {
  WalletClass({
    required this.status,
    required this.data,
  });

  final Status status;
  final Data data;

  factory WalletClass.fromRawJson(String str) =>
      WalletClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WalletClass.fromJson(Map<String, dynamic> json) => WalletClass(
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
    required this.phoneNumber,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.status,
    required this.accounts,
    required this.verificationStatus,
    required this.type,
    required this.metadata,
    required this.ewalletReferenceId,
    required this.category,
    required this.contacts,
  });

  final dynamic phoneNumber;
  final dynamic email;
  final String firstName;
  final String lastName;
  final String id;
  final String status;
  final List<dynamic> accounts;
  final String verificationStatus;
  final String type;
  final DatumMetadata metadata;
  final String ewalletReferenceId;
  final dynamic category;
  final Contacts contacts;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        phoneNumber: json["phone_number"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        id: json["id"],
        status: json["status"],
        accounts: List<dynamic>.from(json["accounts"].map((x) => x)),
        verificationStatus: json["verification_status"],
        type: json["type"],
        metadata: DatumMetadata.fromJson(json["metadata"]),
        ewalletReferenceId: json["ewallet_reference_id"],
        category: json["category"],
        contacts: Contacts.fromJson(json["contacts"]),
      );

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "id": id,
        "status": status,
        "accounts": List<dynamic>.from(accounts.map((x) => x)),
        "verification_status": verificationStatus,
        "type": type,
        "metadata": metadata.toJson(),
        "ewallet_reference_id": ewalletReferenceId,
        "category": category,
        "contacts": contacts.toJson(),
      };
}

class Contacts {
  Contacts({
    required this.data,
    required this.hasMore,
    required this.totalCount,
    required this.url,
  });

  final List<Datum> data;
  final bool hasMore;
  final int totalCount;
  final String url;

  factory Contacts.fromRawJson(String str) =>
      Contacts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Contacts.fromJson(Map<String, dynamic> json) => Contacts(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasMore: json["has_more"],
        totalCount: json["total_count"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "has_more": hasMore,
        "total_count": totalCount,
        "url": url,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.secondLastName,
    required this.gender,
    required this.maritalStatus,
    required this.houseType,
    required this.contactType,
    required this.phoneNumber,
    required this.email,
    required this.identificationType,
    required this.identificationNumber,
    required this.issuedCardData,
    required this.dateOfBirth,
    required this.country,
    required this.nationality,
    required this.address,
    required this.ewallet,
    required this.createdAt,
    required this.metadata,
    required this.businessDetails,
    required this.complianceProfile,
    required this.verificationStatus,
    required this.sendNotifications,
    required this.mothersName,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String middleName;
  final String secondLastName;
  final String gender;
  final String maritalStatus;
  final String houseType;
  final String contactType;
  final String phoneNumber;
  final String email;
  final String identificationType;
  final String identificationNumber;
  final IssuedCardData issuedCardData;
  final DateTime dateOfBirth;
  final String country;
  final String nationality;
  final Address address;
  final String ewallet;
  final int createdAt;
  final DatumMetadata metadata;
  final dynamic businessDetails;
  final int complianceProfile;
  final String verificationStatus;
  final bool sendNotifications;
  final String mothersName;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"],
        secondLastName: json["second_last_name"],
        gender: json["gender"],
        maritalStatus: json["marital_status"],
        houseType: json["house_type"],
        contactType: json["contact_type"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        identificationType: json["identification_type"],
        identificationNumber: json["identification_number"],
        issuedCardData: IssuedCardData.fromJson(json["issued_card_data"]),
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        country: json["country"],
        nationality: json["nationality"],
        address: Address.fromJson(json["address"]),
        ewallet: json["ewallet"],
        createdAt: json["created_at"],
        metadata: DatumMetadata.fromJson(json["metadata"]),
        businessDetails: json["business_details"],
        complianceProfile: json["compliance_profile"],
        verificationStatus: json["verification_status"],
        sendNotifications: json["send_notifications"],
        mothersName: json["mothers_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName,
        "second_last_name": secondLastName,
        "gender": gender,
        "marital_status": maritalStatus,
        "house_type": houseType,
        "contact_type": contactType,
        "phone_number": phoneNumber,
        "email": email,
        "identification_type": identificationType,
        "identification_number": identificationNumber,
        "issued_card_data": issuedCardData.toJson(),
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "country": country,
        "nationality": nationality,
        "address": address.toJson(),
        "ewallet": ewallet,
        "created_at": createdAt,
        "metadata": metadata.toJson(),
        "business_details": businessDetails,
        "compliance_profile": complianceProfile,
        "verification_status": verificationStatus,
        "send_notifications": sendNotifications,
        "mothers_name": mothersName,
      };
}

class Address {
  Address({
    required this.id,
    required this.name,
    required this.line1,
    required this.line2,
    required this.line3,
    required this.city,
    required this.state,
    required this.country,
    required this.zip,
    required this.phoneNumber,
    required this.metadata,
    required this.canton,
    required this.district,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String line1;
  final String line2;
  final String line3;
  final String city;
  final String state;
  final String country;
  final String zip;
  final String phoneNumber;
  final AddressMetadata metadata;
  final String canton;
  final String district;
  final int createdAt;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        name: json["name"],
        line1: json["line_1"],
        line2: json["line_2"],
        line3: json["line_3"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        zip: json["zip"],
        phoneNumber: json["phone_number"],
        metadata: AddressMetadata.fromJson(json["metadata"]),
        canton: json["canton"],
        district: json["district"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "line_1": line1,
        "line_2": line2,
        "line_3": line3,
        "city": city,
        "state": state,
        "country": country,
        "zip": zip,
        "phone_number": phoneNumber,
        "metadata": metadata.toJson(),
        "canton": canton,
        "district": district,
        "created_at": createdAt,
      };
}

class AddressMetadata {
  AddressMetadata();

  factory AddressMetadata.fromRawJson(String str) =>
      AddressMetadata.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressMetadata.fromJson(Map<String, dynamic> json) =>
      AddressMetadata();

  Map<String, dynamic> toJson() => {};
}

class IssuedCardData {
  IssuedCardData({
    required this.preferredName,
    required this.transactionPermissions,
    required this.roleInCompany,
  });

  final String preferredName;
  final String transactionPermissions;
  final String roleInCompany;

  factory IssuedCardData.fromRawJson(String str) =>
      IssuedCardData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IssuedCardData.fromJson(Map<String, dynamic> json) => IssuedCardData(
        preferredName: json["preferred_name"],
        transactionPermissions: json["transaction_permissions"],
        roleInCompany: json["role_in_company"],
      );

  Map<String, dynamic> toJson() => {
        "preferred_name": preferredName,
        "transaction_permissions": transactionPermissions,
        "role_in_company": roleInCompany,
      };
}

class DatumMetadata {
  DatumMetadata({
    required this.merchantDefined,
  });

  final bool merchantDefined;

  factory DatumMetadata.fromRawJson(String str) =>
      DatumMetadata.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumMetadata.fromJson(Map<String, dynamic> json) => DatumMetadata(
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

WalletClass? userinfo;

Future<WalletClass> rWallet(String wallet) async {
  await RequestInit().getSignature('/v1/user/$wallet', "get");

  try {
    var docList = await get(
      Uri.parse("https://sandboxapi.rapyd.net/v1/user/$wallet"),
      headers: header,
    );
    // print(docList.body);

    if (docList.statusCode == 200) {
      // print(json.decode(docList.body));
      var _result = WalletClass.fromJson(json.decode(docList.body));
      print(_result.data.category);
      // print(documentName);

      userinfo = _result;
      return _result;
    } else {
      throw Exception();
    }
  } on SocketException {
    // print(e);
    rethrow;
  }
}

Future<WalletClass> cWallet(
    fname,
    lname,
    refid,
    type,
    phone,
    email,
    mother,
    line,
    city,
    state,
    country,
    zip,
    dob,
    nation,
    idname,
    idNo,
    contacttype) async {
  String url = "https://sandboxapi.rapyd.net/v1/user";

  // print(email);
  // print(email.runtimeType);

  var myBody = jsonEncode(
    {
      "first_name": fname,
      "last_name": lname,
      "email": email,
      "phone_number": phone,
      "ewallet_reference_id": refid,
      "metadata": {"merchant_defined": true},
      "type": type,
      "contact": {
        "phone_number": phone,
        "email": email,
        "first_name": fname,
        "last_name": lname,
        "mothers_name": mother,
        "contact_type": contacttype,
        "address": {
          "name": "$fname $lname",
          "line_1": line,
          "city": city,
          "state": state,
          "country": country,
          "zip": zip,
          "phone_number": phone,
          "metadata": {},
        },
        "date_of_birth": dob,
        "country": country,
        "identification_type": idname,
        "identification_number": idNo,
        "nationality": nation,
        "metadata": {"merchant_defined": true}
      }
    },
  );

  await RequestInit().getSignature("/v1/user", "post", bodyData: myBody);
  try {
    var resp = await post(
      Uri.parse(url),
      headers: header,
      body: myBody,
    );

    if (resp.statusCode == 200) {
      return WalletClass.fromJson(json.decode(resp.body));
    } else {
      print(resp.body);
      throw Exception(resp);
    }
  } on SocketException {
    rethrow;
  }
}

Future<WalletClass> creatbCompanyWallet(
    fname,
    lname,
    refid,
    type,
    phone,
    email,
    mother,
    line,
    city,
    state,
    country,
    zip,
    dob,
    nation,
    idname,
    idNo,
    contacttype) async {
  String url = "https://sandboxapi.rapyd.net/v1/user";

  var myBody = jsonEncode(
    {
      "first_name": fname,
      "last_name": lname,
      "ewallet_reference_id": refid,
      "metadata": {"merchant_defined": true},
      "type": type,
      "contact": {
        "phone_number": phone,
        "email": email,
        "first_name": fname,
        "last_name": lname,
        "mothers_name": mother,
        "contact_type": contacttype,
        "address": {
          "name": "$fname $lname",
          "line_1": line,
          "city": city,
          "state": state,
          "country": country,
          "zip": zip,
          "phone_number": phone,
          "metadata": {},
        },
        "date_of_birth": dob,
        "country": country,
        "identification_type": idname,
        "identification_number": idNo,
        "nationality": nation,
        "metadata": {"merchant_defined": true}
      }
    },
  );

  await RequestInit().getSignature("/v1/user", "post", bodyData: myBody);
  try {
    var resp = await post(
      Uri.parse(url),
      headers: header,
      body: myBody,
    );

    if (resp.statusCode == 200) {
      return WalletClass.fromJson(json.decode(resp.body));
    } else {
      print(resp.body);
      throw Exception(resp);
    }
  } on SocketException {
    rethrow;
  }
}
