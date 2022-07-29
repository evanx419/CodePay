import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:guavapay/models/walletfunds/transfer.dart';
import 'package:guavapay/screens/dashboard.dart';
import 'package:guavapay/screens/landing.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:flutter/material.dart';
import '../models/userbdmodel/userdb.dart';
import '../models/walletfunds/respond.dart';
import '../utilities/appText.dart';
import '../utilities/appbar.dart';
import '../utilities/variables.dart';

class walletsend extends StatefulWidget {
  walletsend({Key? key}) : super(key: key);

  @override
  State<walletsend> createState() => _walletsendState();
}

class _walletsendState extends State<walletsend> {
  final _amount = TextEditingController();
  final _eWallet = TextEditingController();
  final _pwd = TextEditingController();
  String? _selectedcurrency;
  bool _isLoading = false;
  List qr = [];
  bool _pwdcheck = false;

  _onSubmit() async {
    qr = [];
    if (_amount.text.isEmpty ||
        _eWallet.text.isEmpty ||
        _selectedcurrency!.isEmpty) {
      overlayError("Empty fields");
      return;
    }
    _state(true);

    await transferFund(
            myWalletId, _eWallet.text, _amount.text, _selectedcurrency)
        .then((value) async {
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
      overlaySuccess("Transaction Successful");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
          (route) => false);
    });

// ###############################
    _state(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherAppBar("Ewallet Id Payment", context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  inputFeild("Amount", "", _amount,
                      keyboard: TextInputType.number),
                  const SizedBox(height: 10),
                  inputFeild("eWallet", "", _eWallet),
                  const SizedBox(height: 20),
                  text("Enter Currency", color: Colors.black),
                  const SizedBox(height: 10),
                  Autocomplete(
                    optionsBuilder: (TextEditingValue value) {
                      if (value.text.isEmpty) {
                        return const Iterable<String>.empty();
                      } else {
                        return currencies
                            .where((element) =>
                                element.toLowerCase().contains(value.text))
                            .toList();
                      }
                    },
                    onSelected: (String value) async {
                      setState(
                        () {
                          _selectedcurrency = value;
                          // print(_currencyCode);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  !_isLoading
                      ? SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: pcolor, // Background color
                              onPrimary:
                                  Colors.white, // Text Color (Foreground color)
                            ), // style: const ButtonStyle(backgroundColor: Color.fromRGBO(77, 99, 8, opacity)),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_amount.text.isEmpty ||
                                        _eWallet.text.isEmpty ||
                                        _selectedcurrency!.isEmpty) {
                                      overlayError("Empty fields");
                                      return;
                                    }
                                    _auth();
                                  },
                            child: whitesmallText(
                              "Send",
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
          ],
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

                          var pos = _id.indexOf(myWalletId);
                          print(myWalletId);
                          print(pos);

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
                fillColor: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  _state(x) {
    setState(() {
      _isLoading = x;
    });
  }

  _pwdchecker(val) {
    return setState(() {
      _pwdcheck = val;
    });
  }
}
