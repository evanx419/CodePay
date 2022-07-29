import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/models/payment/lispayments.dart';
import 'package:guavapay/models/payout/payoutmethodes.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:guavapay/utilities/variables.dart';
import 'package:intl/intl.dart';
import '../models/payout/createPayout.dart';
import '../models/payout/setResponse.dart';
import '../models/userbdmodel/userdb.dart';
import '../models/walletModel.dart';
import '../models/walletfunds/respond.dart';
import '../models/walletfunds/transfer.dart';
import '../utilities/appText.dart';
import 'dashboard.dart';

class ListPayments extends StatefulWidget {
  ListPayments(this.wallet, {Key? key}) : super(key: key);
  var wallet;

  @override
  State<ListPayments> createState() => _ListPaymentsState();
}

class _ListPaymentsState extends State<ListPayments> {
  var formatCurrency = NumberFormat.simpleCurrency(name: "USD");
  List<String> _mymethods = [];
  List<String> _mycountry = [];
  List<String> _mycategories = [];
  List<List> _mysendercurrency = [];
  List _mysendercountry = [];
  List<String> _myname = [];
  String? _selectedcurrency;
  String? _selectedmethod;
  var _len;
  var _currency;
  var _country;
  var crt;
  bool _isLoading = false;
  List _mydata = [];
  bool _pwdcheck = false;
  var _methods;
  final _pwd = TextEditingController();
  final _money = TextEditingController();

  _onSubmit() async {
    List _listdata = _mydata;
    await transferFund(
      "ewallet_41e7e61d1381f6e95c9d5e922d3ea071",
      widget.wallet,
      _money.text,
      crt,
    ).then((value) async {
      if (value.status.errorCode != "") {
        overlayError(value.status.errorCode);
        return;
      }
      await txRespond(value.data.id, "accept", "accepted").then((val) {
        if (val.status.errorCode != "") {
          overlayError(value.status.errorCode);
          return;
        }
      });
      overlaySuccess("Refund Successful");
      Navigator.pop(context);
    });

//     await createPayout(
//             _selectedmethod,
//             "ewallet_41e7e61d1381f6e95c9d5e922d3ea071",
//             _money.text,
//             crt,
//             _currency[0],
//             "NG",
//             "individual",
//             "company",
//             _country,
//             "${_listdata[2].toString().trim()} ${_listdata[1].toString().trim()}",
//             _listdata[0].toString().trim(),
//             _listdata[2].toString().trim(),
//             _listdata[1].toString().trim(),
//             "${_listdata[2].toString().trim()}.${_listdata[1].toString().trim()}",
//             widget.wallet,
//             _listdata[4].toString().trim(),
//             "bank")
//         .onError((error, stackTrace) => overlayError(error))
//         .then(
//       (v) async {
// // ##################### check if user already paid ###################

//         if (v["status"]["error_code"] != "") {
//           overlayError(v["status"]["error_code"].toString());
//           return;
//         }

//         await respondPayout(v["data"]["id"]).then((vl) {
//           print(vl);
//         });
//       },
//     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherAppBar("Payments", context),
      backgroundColor: Colors.white,
      body: Theme(
        data: themedata,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isLoading
                    ? const Center(
                        child: SpinKitWave(
                          size: 25,
                          color: Colors.grey,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: FutureBuilder(
                    future: getPaymentslist(widget.wallet),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        // var len = snapshot.data["data"].lenght;
                        return ListView.builder(
                          itemCount: paymentlenght,
                          itemBuilder: (context, i) {
                            var j = currencies.indexOf(snapshot.data["data"][i]
                                    ["currency_code"]
                                .toString());
                            formatCurrency = NumberFormat.simpleCurrency(
                                name: currencies[j]);
                            if (snapshot.data["data"][0] != null) {
                              return Container(
                                height: 80,
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 209, 209, 209),
                                      blurRadius: 20,
                                      offset: Offset(6, 6),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.grey[200],
                                          child: smallText(
                                              snapshot.data["data"][i]
                                                      ["currency_code"]
                                                  .toString(),
                                              color: Colors.black45),
                                        ),
                                        const SizedBox(width: 5),
                                        title(
                                            "${snapshot.data["data"][i]["id"].toString().substring(0, 15)}..."),

                                        Expanded(child: Container()),
                                        title(formatCurrency.format(snapshot
                                            .data["data"][i]["amount"])),
                                        const SizedBox(width: 5),
// #######################################################################
                                        InkWell(
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              width: 50,
                                              height: 30,
                                              color: Colors.green,
                                              child: text("Refund",
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onTap: () async {
                                            _selectedmethod = null;
                                            await rWallet(widget.wallet)
                                                .then((v) {
                                              if (v.data.type == "person") {
                                                _mydata.add(v.data.email);
                                                _mydata.add(v.data.firstName);
                                                _mydata.add(v.data.lastName);
                                                _mydata.add(v.data.type);
                                                _mydata.add("1234567");
                                              }
                                            });
                                            await getPayoutlistMethod(snapshot
                                                    .data["data"][i]
                                                        ["currency_code"]
                                                    .toString())
                                                .then(
                                              (v) {
                                                setState(() {
                                                  _mycountry = [];
                                                  _mymethods = [];
                                                  _mycategories = [];
                                                  _mysendercurrency = [];
                                                  _mysendercountry = [];
                                                  _myname = [];
                                                  _len = v["data"].length;
                                                  crt = snapshot.data["data"][i]
                                                          ["currency_code"]
                                                      .toString();
                                                });

                                                for (var i = 0;
                                                    i < v["data"].length;
                                                    i++) {
                                                  _mymethods.add(v["data"][i]
                                                      ["payout_method_type"]);
                                                  _mycountry.add(v["data"][i]
                                                      ["beneficiary_country"]);
                                                  _mycategories.add(
                                                      v["data"][i]["category"]);
                                                  _mysendercountry.add(v["data"]
                                                      [i]["sender_country"]);
                                                  _mysendercurrency.add(v[
                                                          "data"][i]
                                                      ["sender_currencies"]);
                                                  _myname.add(
                                                      v["data"][i]["name"]);
                                                }
                                              },
                                            );
                                            await _refund();
                                            // print(_mycategories);
                                            // rWallet(
                                            //     "ewallet_41e7e61d1381f6e95c9d5e922d3ea071");

                                            // _refund();
                                            // print(_mymethods);
// #####################################################################################
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                child: smallText("text", color: pcolor),
                              );
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                )

                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _refund() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 1,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  menuMaxHeight: 400,
                  value: _selectedmethod,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Payment Method",
                  ),
                  items: _mymethods.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (setValue) {
                    setState(() {
                      _selectedmethod = setValue.toString();

                      var i = _mymethods.indexOf(_selectedmethod!);

                      _country = _mycountry[i];
                      _currency = _mysendercurrency[i];

                      // print(_currency);

                      // print(_selectedmethod);
                    });
                    // getStates();
                  },
                ),
                const SizedBox(height: 10),
                inputFeild("Amount", "", _money,
                    keyboard: TextInputType.number),
                const SizedBox(height: 10),
                inputFeild("Enter Password", "", _pwd,
                    obsc: true, keyboard: TextInputType.number),
                RawMaterialButton(
                  onPressed: _pwdcheck
                      ? null
                      : () async {
                          if (_pwd.text.isEmpty) {
                            print("Enter Account Password");
                            return;
                          }
                          await getUsers().then((value) async {
                            List<String> _pwdlist = [];
                            List<String> _id = [];

                            _pwdchecker(true);

                            value.data.forEach((e) {
                              _pwdlist.add(e.pwd.trim());
                              _id.add(e.walletId.trim());
                            });

                            var pos = _id.indexOf(widget.wallet);

                            if (_pwdlist[pos] == _pwd.text) {
                              // ############# POst ###########################
                              Navigator.of(context).pop();
                              await _onSubmit();
                              _pwdchecker(false);
                            } else {
                              overlayError("Incorrect Password");
                              _pwdchecker(false);
                              return null;
                            }
                          });
                        },
                  child: smallText("Proceed", color: Colors.white),
                  fillColor: pcolor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _state(val) {
    return setState(() {
      _isLoading = val;
    });
  }

  _pwdchecker(val) {
    return setState(() {
      _pwdcheck = val;
    });
  }
}
