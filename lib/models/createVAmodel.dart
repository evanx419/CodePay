import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../utilities/signature.dart';



class Account {
    Account({
        required this.status,
        required this.data,
    });

    final Status status;
    final Data data;

    factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Account.fromJson(Map<String, dynamic> json) => Account(
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
    final String description;
    final dynamic fundingInstructions;
    final String currency;
    final List<dynamic> transactions;

    

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
        transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
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
        "transactions": List<dynamic>.from(transactions.map((x) => x)),
    };
}

class BankAccount {
    BankAccount({
        required this.beneficiaryName,
        required this.address,
        required this.countryIso,
        required this.bank,
        required this.zip,
        required this.country,
        required this.accountNumber,
        required this.bic,

        // required this.bsbCode,

    });

    String? beneficiaryName;
    String? address;
    String? countryIso;
    String? bank;
    String? zip;
    String? country;
    String? accountNumber;
    String? bic;
    // final String bsbCode;

    factory BankAccount.fromRawJson(String str) => BankAccount.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        beneficiaryName: json["beneficiary_name"],
        address: json["address"],
        countryIso: json["country_iso"],
        bank: json["bank"],
        zip: json["zip"],
        country: json["country"],
        accountNumber: json["account_number"],
        bic: json["bic"],

    );

    Map<String, dynamic> toJson() => {
        "beneficiary_name": beneficiaryName,
        "address": address,
        "country_iso": countryIso,
        "bank": bank,
        "zip": zip,
        "country": country,
        "account_number": accountNumber,
        "bic": bic,
    };
}

class Metadata {
    Metadata({
        required this.merchantDefined,
    });

    final bool merchantDefined;

    factory Metadata.fromRawJson(String str) => Metadata.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
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







// #################### create virtual accounts
Future<Account> createvAccount(
    String curr, String coun, String desp, String wallet, String id) async {
  String urL = "https://sandboxapi.rapyd.net/v1/issuing/bankaccounts";
  var myBody = jsonEncode({
    "currency": curr,
    "country": coun,
    "description": desp,
    "ewallet": wallet,
    "merchant_reference_id": id,
    "metadata": {"merchant_defined": true}
  });

  await RequestInit()
      .getSignature("/v1/issuing/bankaccounts", "post", bodyData: myBody);

  try {
    var createAcc = await post(
      Uri.parse(urL),
      headers: header,
      body: myBody,
    );

    // print(createAcc.body);
    if (createAcc.statusCode == 200) {
      var result = Account.fromJson(json.decode(createAcc.body));

      return result;
    } else {
      throw Exception(createAcc.statusCode);
    }
  } on SocketException {
    // throw Exception(e.toString());
    rethrow;
  }

  // print(result);
}






































// class Account {
//     Account({
//         required this.status,
//         required this.data,
//     });

//     final Status status;
//     final Data data;

//     factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Account.fromJson(Map<String, dynamic> json) => Account(
//         status: Status.fromJson(json["status"]),
//         data: Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status.toJson(),
//         "data": data.toJson(),
//     };
// }

// class Data {
//     Data({
//         required this.id,
//         required this.merchantReferenceId,
//         required this.ewallet,
//         required this.bankAccount,
//         required this.metadata,
//         required this.status,
//         required this.description,
//         required this.fundingInstructions,
//         required this.currency,
//         required this.transactions,
//     });

    // final String id;
    // final String merchantReferenceId;
    // final String ewallet;
    // final BankAccount bankAccount;
    // final Metadata metadata;
    // final String status;
    // final String description;
    // final dynamic fundingInstructions;
    // final String currency;
    // final List<dynamic> transactions;

//     factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         merchantReferenceId: json["merchant_reference_id"],
//         ewallet: json["ewallet"],
//         bankAccount: BankAccount.fromJson(json["bank_account"]),
//         metadata: Metadata.fromJson(json["metadata"]),
//         status: json["status"],
//         description: json["description"],
//         fundingInstructions: json["funding_instructions"],
//         currency: json["currency"],
//         transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "merchant_reference_id": merchantReferenceId,
//         "ewallet": ewallet,
//         "bank_account": bankAccount.toJson(),
//         "metadata": metadata.toJson(),
//         "status": status,
//         "description": description,
//         "funding_instructions": fundingInstructions,
//         "currency": currency,
//         "transactions": List<dynamic>.from(transactions.map((x) => x)),
//     };
// }

// class BankAccount {
//     BankAccount({
        // required this.beneficiaryName,
        // required this.address,
        // required this.countryIso,
        // required this.bank,
        // required this.country,
        // required this.bsbCode,
        // required this.bic,
//     });

    // final String beneficiaryName;
    // final String address;
    // final String countryIso;
    // final String bank;
    // final String country;
    // final String bsbCode;
    // final String bic;

//     factory BankAccount.fromRawJson(String str) => BankAccount.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
//         beneficiaryName: json["beneficiary_name"],
//         address: json["address"],
//         countryIso: json["country_iso"],
//         bank: json["bank"],
//         country: json["country"],
//         bsbCode: json["bsb_code"],
//         bic: json["bic"],
//     );

//     Map<String, dynamic> toJson() => {
//         "beneficiary_name": beneficiaryName,
//         "address": address,
//         "country_iso": countryIso,
//         "bank": bank,
//         "country": country,
//         "bsb_code": bsbCode,
//         "bic": bic,
//     };
// }

// class Metadata {
//     Metadata({
//         required this.merchantDefined,
//     });

//     final bool merchantDefined;

//     factory Metadata.fromRawJson(String str) => Metadata.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
//         merchantDefined: json["merchant_defined"],
//     );

//     Map<String, dynamic> toJson() => {
//         "merchant_defined": merchantDefined,
//     };
// }

// class Status {
//     Status({
//         required this.errorCode,
//         required this.status,
//         required this.message,
//         required this.responseCode,
//         required this.operationId,
//     });

//     final String errorCode;
//     final String status;
//     final String message;
//     final String responseCode;
//     final String operationId;

//     factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Status.fromJson(Map<String, dynamic> json) => Status(
//         errorCode: json["error_code"],
//         status: json["status"],
//         message: json["message"],
//         responseCode: json["response_code"],
//         operationId: json["operation_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "error_code": errorCode,
//         "status": status,
//         "message": message,
//         "response_code": responseCode,
//         "operation_id": operationId,
//     };
// }

















// class Currencies {
//     Currencies({
//         required this.status,
//         required this.data,
//     });

//     final Status status;
//     final Data data;


//     String toRawJson() => json.encode(toJson());

//     factory Currencies.fromJson(Map<String, dynamic> json) => Currencies(
//         status: Status.fromJson(json["status"]),
//         data: Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status.toJson(),
//         "data": data.toJson(),
//     };
// }

// class Data {
//     Data({
//         required this.country,
//         required this.supportedCurrencies,
//         required this.accountIdType,
//         required this.acceptSwift,
//         required this.refundable,
//         required this.remitterDetails,
//         required this.localBankCodeType,
//     });

//     final String country;
//     final List<String> supportedCurrencies;
//     final String accountIdType;
//     final bool acceptSwift;
//     final bool refundable;
//     final bool remitterDetails;
//     final String localBankCodeType;

//     String toRawJson() => json.encode(toJson());

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         country: json["country"],
//         supportedCurrencies: List<String>.from(json["supported_currencies"].map((x) => x)),
//         accountIdType: json["account_id_type"],
//         acceptSwift: json["accept_swift"],
//         refundable: json["refundable"],
//         remitterDetails: json["remitter_details"],
//         localBankCodeType: json["local_bank_code_type"],
//     );

//     Map<String, dynamic> toJson() => {
//         "country": country,
//         "supported_currencies": List<dynamic>.from(supportedCurrencies.map((x) => x)),
//         "account_id_type": accountIdType,
//         "accept_swift": acceptSwift,
//         "refundable": refundable,
//         "remitter_details": remitterDetails,
//         "local_bank_code_type": localBankCodeType,
//     };
// }

// class Status {
//     Status({
//         required this.errorCode,
//         required this.status,
//         required this.message,
//         required this.responseCode,
//         required this.operationId,
//     });

//     final String errorCode;
//     final String status;
//     final String message;
//     final String responseCode;
//     final String operationId;

//     factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Status.fromJson(Map<String, dynamic> json) => Status(
//         errorCode: json["error_code"],
//         status: json["status"],
//         message: json["message"],
//         responseCode: json["response_code"],
//         operationId: json["operation_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "error_code": errorCode,
//         "status": status,
//         "message": message,
//         "response_code": responseCode,
//         "operation_id": operationId,
//     };
// }


// List<String> currencyList = [];

// Future<Currencies> getCurrencies(coutvalue, crtvalue) async {
//   RequestInit().getSignature("/v1/issuing/bankaccounts/capabilities/country=$coutvalue&currency=$crtvalue", "get");

//   try {
//     var crt = await get(
//         Uri.parse("https://sandboxapi.rapyd.net/v1/issuing/bankaccounts/capabilities/country=$coutvalue&currency=$crtvalue"),
//         headers: header);

// print(crt.body);
//     // if (crt.statusCode == 200) {
//     //   var result = Currencies.fromJson(json.decode(crt.body));

//     //   currencyList = result.data.supportedCurrencies;
      
//     //   // print(result.data[1].);
//     //   return result;
//     // } else {
//     //   throw Exception(crt.statusCode);
//     // }
//     return Currencies.fromJson(json.decode(crt.body));;
//   } catch (e) {
//     throw Exception(e);
//   }

//   // print(result);
// }



