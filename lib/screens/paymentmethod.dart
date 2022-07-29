import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guavapay/models/payment/completePayment.dart';
import 'package:guavapay/models/payment/listPaymentmethod.dart';
import 'package:guavapay/models/payment/requiredRequirement.dart';
import 'package:guavapay/screens/dashboard.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:guavapay/utilities/variables.dart';
import '../models/businessmodel/codepaymentclass.dart';
import '../models/payment/createPayment.dart';
import '../models/userbdmodel/userdb.dart';
import '../models/validationmodels/countries.dart';
import 'package:intl/intl.dart';
import '../models/walletfunds/respond.dart';
import '../models/walletfunds/transfer.dart';
import '../utilities/appText.dart';

class CustomerPaymentMethod extends StatefulWidget {
  var wallet;
  var myname;
  CustomerPaymentMethod(this.wallet, this.myname, {Key? key}) : super(key: key);

  @override
  State<CustomerPaymentMethod> createState() => _CustomerPaymentMethodState();
}

class _CustomerPaymentMethodState extends State<CustomerPaymentMethod> {
  String mytext =
      "Space tourism is another niche segment of the aviation industry that seeks to give tourists the ability to become astronauts and experience space travel for recreational, leisure, or business purposes.";

  var formatCurrency = NumberFormat.simpleCurrency(name: "USD");
  String? param1;
  String? param2;
  double _payamount = 150000;
  DateTime date = DateTime.now();
  final _number = TextEditingController();
  final _money = TextEditingController();
  final _year = TextEditingController();
  final _month = TextEditingController();
  final _pwd = TextEditingController();
  final _cvv = TextEditingController();
  var _currencyCode, _country;
  DateTime? calender;
  String? countryShort;
  bool _isLoading = false;
  bool _isSelected = false;

  bool _ismethode = false;
  List _methodname = [];
  List _methodtype = [];
  List _methodcategory = [];
  String? _selectedmethod;
  bool _pwdcheck = false;
  int _count = 1;
  int _loop = 0;
  double? _rate;
  var _total;
  int? _pos = 0;
  var _remainder = 0.0;
  int len = 1;
  String? _paymentId;

  _onSubmit() async {
    // ######################### set total to amount #########################

    setState(() {
      _total = _money.text;
    });

// ############################# if empty amount  ############################
    if (_total!.isEmpty) {
      setState(() {
        _total = _payamount.toString();
      });
    }

    _state(true);

// ######################## get balance in dollar ####################

    var _balance = (_payamount - double.parse(_total!)) / _rate!;

// ################### Check over payment #############################

    if (_balance.isNegative) {
      overlayError("Check amount");
      // print("check amount");
      _state(false);

      return null;
    }

    Map mapdata = {
      "number": _number.text,
      "expiration_month": _month.text,
      "expiration_year": _year.text,
      "cvv": _cvv.text,
      "name": widget.myname
    };

// ###################### Create payment ##############################

    !_ismethode
        ? await createPayment1(_total.toString(), _currencyCode.toString(),
                _selectedmethod.toString(), adminwallet)
            .then((v) {
// ####################### If error ###############################
            if (v["data"]["description"].toString().contains("bank transfer")) {
              setState(() {
                param1 = v["data"]["payment_method"];
                param2 = _total.toString();
              });
            }
            if (v["status"]["error_code"] != "") {
              overlayError(v["status"]["error_code"].toString());
              _state(false);
              return;
            }
            setState(() {
              _paymentId = v["data"]["id"];
            });
            // print(v);
          })
        : await createPayment2(_total.toString(), _currencyCode.toString(),
                _selectedmethod.toString(), adminwallet, mapdata)
            .then((v) {
// ####################### If error ###############################
            if (v["status"]["error_code"] != "") {
              overlayError(v["status"]["error_code"].toString());
              _state(false);
              return;
            }
            setState(() {
              _paymentId = v["data"]["id"];
            });
          });

    // print(bizlist);
    if (bizlist.contains(widget.wallet)) {
      await deletepayment(widget.wallet).then((value) async {
        // print(value);
        bizlist = [];
        bizbal = [];
        persons = [];
        balcurrency = [];
        await getuserpayment();
        _userpos();
      });
    } else {
      await postuserpayment(
              widget.wallet,
              _selectedmethod,
              _total.toString(),
              _balance.toString(),
              calender.toString(),
              _currencyCode,
              _count.toString())
          .then((value) async {
        bizlist = [];
        bizbal = [];
        persons = [];
        balcurrency = [];
        await getuserpayment().then((val) async {
          _userpos();
          if (val.data[_pos!].balance == "0.0") {
            await deletepayment(widget.wallet).then((value) async {
              bizlist = [];
              bizbal = [];
              persons = [];
              balcurrency = [];
              await getuserpayment();
              _userpos();
            });
          }
        });

        // print(value);
      });
    }
    await complate(_paymentId, param1, param2);

    // print(param1);
    // print(param2);
    // await transferFund(
    //   widget.wallet,
    //   "ewallet_41e7e61d1381f6e95c9d5e922d3ea071",
    //   _money.text,
    //   _currencyCode.toString(),
    // ).then((value) async {
    //   if (value.status.errorCode != "") {
    //     overlayError(value.status.errorCode);
    //     return;
    //   }
    //   await txRespond(value.data.id, "accept", "accepted").then((val) {
    //     if (val.status.errorCode != "") {
    //       overlayError(value.status.errorCode);
    //       return;
    //     }
    //   });

    // });
    _state(false);
  }

  complate(payment, par1, par2) async {
    param1 == null
        ? await completePayment(payment).then((value) {
            overlaySuccess("Payment Successful!!!!");
            _state(false);
            Navigator.of(context).pop();
          })
        : await completePayment2(_paymentId, param1, param2).then((value) {
            overlaySuccess("Payment Successful!!!!");
            _state(false);
            Navigator.of(context).pop();
          });
  }

  @override
  void initState() {
    super.initState();
    _userpos();

    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    if (_loop < 1) {
      if (bizlist.contains(widget.wallet.toString())) {
        _remainder = double.parse(bizbal[_pos!]);
        _payamount = double.parse(_remainder.abs().toString());
        // print(_
      }

      var i = currencies.indexOf("USD");
      // var j = currencies.indexOf(_.trim());

      _rate = conversion[i];

      _payamount /= _rate!.toDouble();

      _rate = 1;
      _loop = 1;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("Payment Method", context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/main.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),

                const SizedBox(height: 10),
                payText("Take-off  Date: 08/08/2023 ",
                    color: Colors.black, size: 14),
                const Divider(),

                const SizedBox(height: 10),
                payText(r"Amount:  $150,000", color: Colors.black, size: 13),
                const Divider(),

                const SizedBox(height: 10),
                payText("Description:  $mytext", color: Colors.black, size: 14),
                const Divider(),
                smallText("Country"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Autocomplete(
                          optionsBuilder: (TextEditingValue value) {
                        if (value.text.isEmpty) {
                          return const Iterable<String>.empty();
                        } else {
                          return countryName
                              .where((element) =>
                                  element.toLowerCase().contains(value.text))
                              .toList();
                        }
                      }, onSelected: (String value) async {
                        setState(
                          () {
                            var i = countryName.indexOf(value);
                            _isSelected = true;
                            _country = countryiso[i];
                          },
                        );
                      }),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 245, 248),
                        border: Border.all(color: pcolor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: MaterialButton(
                        onPressed: () async {
                          calender = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: date,
                            lastDate: DateTime(2023),
                          );
                          if (calender == null) return;
                          setState(() {
                            date = calender!;
                          });
                          // print(date.toString());
                        },
                        child: Row(
                          children: [
                            calender == null
                                ? title("pick date", color: pcolor)
                                : title(date.toString().substring(0, 11),
                                    color: pcolor),
                            Icon(
                              Icons.calendar_month_outlined,
                              color: pcolor,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                len < 1
                    ? text("Currency and Country combination is not supported.",
                        color: Colors.red)
                    : Container(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    whitesmallText("Number seats:", color: Colors.black),
                    SizedBox(child: Container()),
                    !bizlist.contains(widget.wallet.toString())
                        ? IconButton(
                            onPressed: () async {
                              setState(() {
                                if (_count != 1) {
                                  _payamount /= _count;
                                  _count -= 1;
                                }
                              });
                            },
                            icon:
                                const Icon((FontAwesomeIcons.minus), size: 20))
                        : Container(),
                    !bizlist.contains(widget.wallet.toString())
                        ? listtext(_count.toString())
                        : listtext(persons[_pos!]),
                    !bizlist.contains(widget.wallet.toString())
                        ? IconButton(
                            onPressed: () async {
                              setState(() {
                                _count += 1;
                                _payamount *= _count;
                              });
                            },
                            icon: const Icon(
                              (FontAwesomeIcons.plus),
                              size: 20,
                            ),
                          )
                        : Container(),
                  ],
                ),

                _isSelected
                    ? smallText("Select Currency & Payment Method")
                    : Container(),
                const SizedBox(height: 10),
                _isSelected
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.3,
                            child: Autocomplete(
                              optionsBuilder: (TextEditingValue value) {
                                if (value.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                } else {
                                  return currencies
                                      .where((element) => element
                                          .toLowerCase()
                                          .contains(value.text))
                                      .toList();
                                }
                              },
                              onSelected: (String value) async {
                                setState(
                                  () {
                                    _payamount = _payamount / _rate!.toDouble();

                                    _currencyCode = value;

                                    var i = currencies.indexOf(
                                        _currencyCode.toString().trim());
                                    _rate = conversion[i];

                                    formatCurrency =
                                        NumberFormat.simpleCurrency(
                                            name: _currencyCode);

                                    _payamount = _payamount * _rate!.toDouble();
                                  },
                                );

                                await getPaymentlistMethod(
                                        _country, _currencyCode)
                                    .then((v) {
                                  _selectedmethod = null;
                                  setState(() {
                                    _methodname = [];
                                    _methodtype = [];
                                    _methodcategory = [];
                                    len = v["data"].length;
                                  });

                                  for (var i = 0; i < v["data"].length; i++) {
                                    // print();
                                    _methodname.add(v["data"][i]["name"]);
                                    _methodtype.add(v["data"][i]["type"]);
                                    _methodcategory
                                        .add(v["data"][i]["category"]);
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              menuMaxHeight: 400,
                              value: _selectedmethod,
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: "Payment Method",
                              ),
                              items: _methodtype.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (setValue) async {
                                setState(() {
                                  _selectedmethod = setValue.toString();
                                });
                                await getPaymentRequirement(_selectedmethod)
                                    .then((v) {
                                  List field = v["data"]["fields"];
                                  if (field.isNotEmpty) {
                                    setState(() {
                                      _ismethode = true;
                                    });
                                    return;
                                  }

                                  setState(() {
                                    _ismethode = false;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _pos == 0
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: inputFeild(
                              "Amount",
                              "",
                              _money,
                              keyboard: TextInputType.number,
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    whitesmallText(formatCurrency.format(_payamount.floor()),
                        color: Colors.black),
                  ],
                ),
                const SizedBox(height: 10),

// ################# Optional field ###############################

                _ismethode
                    ? Column(
                        children: [
                          inputFeild("Card number", "", _number,
                              keyboard: TextInputType.number),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: inputFeild(
                                    "Expiration month", "", _month,
                                    keyboard: TextInputType.number),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: inputFeild("Expiration year", "", _year,
                                    keyboard: TextInputType.number),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          inputFeild("cvv", "", _cvv,
                              keyboard: TextInputType.number),
                          const SizedBox(height: 10),
                        ],
                      )
                    : Container(),

// ################# Optional field ###############################

                const SizedBox(height: 10),
                !_isLoading
                    ? SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                                const Color(0xff22277a), // Background color
                            onPrimary:
                                Colors.white, // Text Color (Foreground color)
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_country == null ||
                                      _selectedmethod == null) {
                                    overlayError("Empty fields");
                                    return;
                                  }

                                  await _auth();
                                },
                          child: whitesmallText(
                            "Submit",
                          ),
                        ),
                      )
                    : const SpinKitWave(
                        color: Colors.grey,
                        size: 35,
                      ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _auth() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              inputFeild("Enter Password", "", _pwd,
                  obsc: true, keyboard: TextInputType.number),
              RawMaterialButton(
                onPressed: _pwdcheck
                    ? null
                    : () async {
                        if (_pwd.text.isEmpty) {
                          overlayError("Enter Account Password");
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
                fillColor: const Color(0xff22277a),
              )
            ],
          ),
        ),
      ),
    );
  }

  _userpos() {
    if (bizlist.contains(widget.wallet.toString())) {
      setState(() {
        print(bizlist);
        _pos = bizlist.indexOf(widget.wallet.toString());
      });
    }
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
