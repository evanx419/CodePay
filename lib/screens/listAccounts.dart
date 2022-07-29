// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guavapay/models/getVAmodel.dart';
import 'package:guavapay/models/walletfunds/accountHistoryclass.dart';
import 'package:guavapay/pages/fund.dart';
import 'package:guavapay/screens/accoutHistory.dart';
import 'package:guavapay/screens/createAcct.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/color.dart';
import 'package:guavapay/utilities/variables.dart';
import 'package:shimmer/shimmer.dart';
import '../utilities/appText.dart';


class ListAccounts extends StatefulWidget {
  ListAccounts(this.wallet, {Key? key}) : super(key: key);
  var wallet;

  @override
  State<ListAccounts> createState() => _ListAccountsState();
}

class _ListAccountsState extends State<ListAccounts> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // print();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherAppBar("Virtual Accounts", context),
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
                      ))
                    : Container(),
                Expanded(
                    child: StreamBuilder<VirtualAccounts>(
                  stream: getVAacct(widget.wallet),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.data.bankAccounts.length,
                        itemBuilder: (context, index) {
                          var items = snapshot.data!.data.bankAccounts;
                          // print(items[index].issuingId);
                          if (snapshot.data!.data.bankAccounts.isNotEmpty) {
                            return Container(
                              height: 80,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 20,
                                    offset: const Offset(6, 6),
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
                                        child: smallText(items[index].currency,
                                            color: Colors.black45),
                                      ),
                                      const SizedBox(width: 5),
                                      title(
                                          "${items[index].issuingId.substring(0, 20)}..."),

                                      Expanded(child: Container()),
// #######################################################################
                                      Container(
                                        width: 30,
                                        height: 30,
                                        color: Colors.green,
                                        child: IconButton(
                                          icon: const Icon(
                                            FontAwesomeIcons.download,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          onPressed: _isLoading
                                              ? null
                                              : () => showDialog(
                                                    context: context,
                                                    builder: (_) => FundDialog(
                                                        "${items[index].issuingId}",
                                                        "${items[index].currency}"),
                                                  ),
                                        ),
                                      ),

                                      const SizedBox(width: 5),
// #####################################################################################
                                      Container(
                                        width: 30,
                                        height: 30,
                                        color: Colors.blue,
                                        child: IconButton(
                                          icon: const Icon(
                                            FontAwesomeIcons
                                                .arrowRightArrowLeft,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          onPressed: _isLoading
                                              ? null
                                              : () async {
                                                  _state(true);
                                                  // print(index);
                                                  await accountTransactions(
                                                          items[index]
                                                              .issuingId)
                                                      .then((value) {
                                                    Navigator.push(
                                                      context,
                                                      (MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListHistory(
                                                          items[index].currency,
                                                        ),
                                                      )),
                                                    );
                                                  });
                                                  _state(false);
                                                },
                                        ),
                                      ),
// #############################################
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: smallText("No account Found!",
                                  color: Colors.black),
                            );
                          }
                        },
                      );
                    } else {
                      return Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 243, 243, 243),
                        highlightColor:
                            const Color.fromARGB(255, 247, 246, 244),
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(15),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 175, 175, 175),
                                  child: Container(
                                    color: Colors.white,
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                title: Container(),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                )),

                // const SizedBox(height: 20),
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: pcolor,
                      onPrimary: Colors.white, // Text Color (Foreground color)
                    ), // style: const ButtonStyle(backgroundColor: Color.fromRGBO(77, 99, 8, opacity)),
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.push(
                              context,
                              (MaterialPageRoute(
                                builder: (context) =>
                                    CreateUserAccout(widget.wallet),
                              )),
                            ),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.circlePlus),
                        const SizedBox(width: 30),
                        whitesmallText("Add Account"),
                      ],
                    ),
                  ),
                ),
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
}

void _showToast(context, text) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(SnackBar(
    content: Text(text),
    //   action: SnackBarAction(
    //       label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    // ),
  ));
}
