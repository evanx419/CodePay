import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

import '../utilities/appText.dart';
import '../utilities/appbar.dart';

import '../utilities/variables.dart';

class RecieveFund extends StatefulWidget {
  RecieveFund({Key? key}) : super(key: key);

  @override
  State<RecieveFund> createState() => _RecieveFundState();
}

class _RecieveFundState extends State<RecieveFund> {
  final _amount = TextEditingController();
  final _pwd = TextEditingController();
  final _eWallet = TextEditingController();
  String? _selectedcurrency;
  bool _isLoading = false;
  bool _isDetect = false;
  bool _pwdcheck = false;
  List qr = [];

  _onSubmit() async {
    qr = [];

    _isLoading = true;
    setState(() {
      qr = ["codepay", _amount.text, _eWallet.text, _selectedcurrency];
    });

    print(qr);
    _state(true);
// ###############################
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: pageAppBar("Scan Payment QRcode", context),
          // bottomNavigationBar: BottomNav(widget.wallet),
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
                                  onPrimary: Colors
                                      .white, // Text Color (Foreground color)
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        if (_amount.text.isEmpty ||
                                            _eWallet.text.isEmpty ||
                                            _selectedcurrency!.isEmpty) {
                                          overlayError("Empty fields");
                                          return;
                                        }
                                        _onSubmit();
                                      },
                                child: whitesmallText(
                                  "Generate QrCode",
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
                _isDetect
                    ? Center(
                        child: QrImage(
                          data: qr.toString(),
                          version: QrVersions.auto,
                          size: 300.0,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        onWillPop: () async {
          setState(() {
            currentIndex = 0;
          });
          return false;
        });
  }

  _state(x) {
    setState(() {
      _isDetect = x;
    });
  }
}
