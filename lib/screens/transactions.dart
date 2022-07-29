// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guavapay/models/walletfunds/respond.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/variables.dart';
import 'package:shimmer/shimmer.dart';
import '../models/walletfunds/listTransactions.dart';
import '../utilities/appText.dart';

class Transactionspage extends StatefulWidget {
  Transactionspage(this.wallet, {Key? key}) : super(key: key);
  var wallet;

  @override
  State<Transactionspage> createState() => _TransactionspageState();
}

class _TransactionspageState extends State<Transactionspage> {
  var val = "PEN";
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // print();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherAppBar("Transactions", context),
      backgroundColor: Colors.white,
      body: Theme(
        data: themedata,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: guavaText("Pendding", size: 12),
                      ),
                      onTap: () => setState(() => val = "PEN"),
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: guavaText("Cancelled", size: 12),
                      ),
                      onTap: () => setState(() => val = "CAN"),
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: guavaText("Declined", size: 12),
                      ),
                      onTap: () => setState(() => val = "DEC"),
                    ),
                    InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: guavaText("Closed", size: 12),
                        ),
                        onTap: () => setState(() => val = "CLO"))
                  ],
                ),
                const SizedBox(height: 10),

                Expanded(
                    child: FutureBuilder<TransactionsClass>(
                  future: walletTransactions(widget.wallet),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        // physics: NeverScrollableScrollPhysics,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.data.length,
                        itemBuilder: (context, index) {
                          var items = snapshot.data!.data;
                          if (items[index].status.contains(val)) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    const Color.fromARGB(255, 216, 216, 216),
                                child: smallText(items[index].currency),
                              ),
                              title: items[index].status.contains("CLO")
                                  ? title(
                                      items[index].id,
                                    )
                                  : title(
                                      items[index].destinationEwalletId,
                                    ),
                              subtitle: text(
                                items[index].createdAt.toString(),
                                color: const Color.fromARGB(255, 206, 206, 206),
                              ), // look into this

                              trailing: items[index].status.contains("PEN")
                                  ? MaterialButton(
                                      minWidth: 2,
                                      onPressed: () async => await txRespond(
                                          items[index].id,
                                          "cancel",
                                          "cancelled"),
                                      child: smallText("X", color: Colors.red),
                                    )
                                  : null,
                            );
                          } else {
                            return Center();
                          }
                        },
                      );
                    } else {
                      return Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 216, 214, 214),
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
                                      const Color.fromARGB(255, 29, 21, 21),
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


// smallText(items[index].status),

// PopupMenuButton(
//                                       icon: const Icon(
//                                         Icons.grid_view_outlined,
//                                         color: Colors.black,
//                                         size: 30,
//                                       ),
//                                       itemBuilder: (context) => [
//                                         PopupMenuItem(
//                                           child: text("Accet"),
//                                           value: 1,
//                                         ),
//                                         PopupMenuItem(
//                                           child: text(""),
//                                           value: 2,
//                                         ),
//                                       ],
//                                     )