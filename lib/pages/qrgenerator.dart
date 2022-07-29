import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import '../models/userbdmodel/userdb.dart';
import '../screens/dashboard.dart';
import '../utilities/appText.dart';
import '../utilities/appbar.dart';
import '../utilities/bottomnav.dart';
import '../utilities/variables.dart';

class Qrreceive extends StatefulWidget {
  var wallet;

  Qrreceive(this.wallet, {Key? key}) : super(key: key);

  @override
  State<Qrreceive> createState() => _QrreceiveState();
}

class _QrreceiveState extends State<Qrreceive> {
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
    qr = ["codepay", _amount.text, _eWallet.text, _selectedcurrency];
    _state(true);
// ###############################
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherAppBar("Scan Payment QRcode", context),
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
      _isDetect = x;
    });
  }

  _pwdchecker(val) {
    return setState(() {
      _pwdcheck = val;
    });
  }
}
