import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/models/userbdmodel/userdb.dart';
import 'package:guavapay/utilities/color.dart';
import '../models/businessmodel/loadbusiness.dart';
import '../models/walletfunds/respond.dart';
import '../models/walletfunds/transfer.dart';
import '../utilities/appText.dart';
import '../utilities/appbar.dart';
import '../utilities/variables.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessTransactions extends StatefulWidget {
  var id, path;
  var _wallet;

  BusinessTransactions(this.path, this.id, this._wallet, {Key? key})
      : super(key: key);

  @override
  State<BusinessTransactions> createState() => _BusinessTransactionsState();
}

class _BusinessTransactionsState extends State<BusinessTransactions> {
  final _money = TextEditingController();
  final _pwd = TextEditingController();

  var formatCurrency = NumberFormat.simpleCurrency(name: "USD");

  bool _isLoading = false;

  bool _pwdcheck = false;
  String? _selectedcurrency;
  var _total;
  var _id;
  String? walletid;

  String? _status;

// @@@@@@@@@@@@@@@@@@@@@@@@@@@ On submit @@@@@@@@@@@@@@@@@@@@@@

  _onSubmit() async {
    // print(_pos);

    DateTime _now = DateTime.now();
    String _date = _now.toString();

// ######################### set total to amount #########################

    _state(true);

// #############   WHERE THE MAGIC HAPPENS    ######################

    await transferFund(widget._wallet, adminwallet,
            double.parse(_total!).floor().toString(), _selectedcurrency)
        .then((admin) async {
      print(admin.status.errorCode);

      await txRespond(admin.data.id, "accept", "accepted").then(
        (res) async {
// ####
          await transferFund(
                  adminwallet,
                  walletid,
                  (double.parse(_total!).floor() * 0.95).toString(),
                  _selectedcurrency)
              .then((Clienttx) async {
            if (_status == "true") {
              await txRespond(Clienttx.data.id, "accept", "accepted").then(
                (value) {
                  print(value);
                },
              );
            }

            overlaySuccess("Payment Successful!!!!!!!!!!!!");
          });
        },
      );
    });

    _state(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("Business Details", context),
      body: SingleChildScrollView(
        child: Theme(
          data: themedata,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<BusinessClass>(
              future: getbusiness(),
              builder: (context, x) {
                if (x.hasData) {
                  var _items = x.data!.data[widget.id];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_items.img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      payText("Business Name:  ${_items.name}",
                          color: Colors.black, size: 14),
                      const Divider(),

                      const SizedBox(height: 10),
                      payText("Take-off  Date:  ${_items.date}",
                          color: Colors.black, size: 14),
                      const Divider(),

                      const SizedBox(height: 10),
                      payText("Amount:  ${_items.amount}",
                          color: Colors.black, size: 13),
                      const Divider(),

                      const SizedBox(height: 10),
                      payText("currency:  ${_items.payoutcurrency}",
                          color: Colors.black, size: 13),
                      const Divider(),

                      const SizedBox(height: 10),
                      payText("eWallet Id:  ${_items.wallet}",
                          color: Colors.black, size: 13),
                      const Divider(),
                      const SizedBox(height: 10),
                      payText("Description:  ${_items.description}",
                          color: Colors.black, size: 14),
                      const Divider(),

                      const SizedBox(height: 10),

// ####################### CHECK IF ITS THE USER'S POST #################################

                      !(widget._wallet == _items.wallet)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: !_isLoading
                                      ? SizedBox(
                                          height: 60,
                                          child: MaterialButton(
                                            color: pcolor,
                                            splashColor: Colors.white,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            onPressed: () async {
                                              setState(() {
                                                walletid = _items.wallet;
                                                _selectedcurrency =
                                                    _items.payoutcurrency;
                                                _total = _items.amount;
                                                _status = _items.status;
                                              });
                                              await _auth();
                                            },
                                            child: whitesmallText("Pay Now"),
                                          ),
                                        )
                                      : const SpinKitWave(
                                          color: Colors.grey,
                                          size: 35,
                                        ),
                                ),
                                SizedBox(
                                    child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  height: 60,
                                  child: MaterialButton(
                                    color: pcolor,
                                    splashColor: Colors.white,
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () async => await launchUrl(
                                        Uri.parse("tel:${_items.phone}")),
                                    child: whitesmallText("Call"),
                                  ),
                                )),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    child: SizedBox(
                                      height: 60,
                                      child: MaterialButton(
                                        color: pcolor,
                                        splashColor: Colors.white,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        onPressed: () async => await launchUrl(
                                            Uri.parse(
                                                "mailto:guavacodeplus@gmail.com?subject=codePay Customer query&body= query on ${_items.name} with eWallet of ${_items.wallet}")),
                                        child: whitesmallText("Query"),
                                      ),
                                    ))
                              ],
                            )
                          : Container(),
                    ],
                  );
                } else {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Color.fromARGB(255, 114, 81, 79),
                    ),
                  );
                }
              },
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

                          var pos = _id.indexOf(widget._wallet);

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
