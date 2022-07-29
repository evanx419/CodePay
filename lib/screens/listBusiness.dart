import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guavapay/models/businessmodel/loadbusiness.dart';
import 'package:guavapay/screens/payBusiness.dart';
import 'package:guavapay/screens/registerBusines.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/color.dart';

import '../models/businessmodel/payoutclass.dart';
import '../utilities/appbar.dart';

class ListBusinss extends StatefulWidget {
  var _wallet;

  ListBusinss(this._wallet, {Key? key}) : super(key: key);

  @override
  State<ListBusinss> createState() => _ListBusinssState();
}

class _ListBusinssState extends State<ListBusinss> {
  @override
  void initState() {
    getuserpayout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("Business", context),
      body: FutureBuilder<BusinessClass>(
        future: getbusiness(),
        builder: (context, snaptot) {
          if (snaptot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              // itemExtent: 100.0,
              itemCount: snaptot.data!.data.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    // dense: true,
                    contentPadding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    leading: Container(
                      // height: 400,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        image: DecorationImage(
                            image: NetworkImage(snaptot.data!.data[i].img),
                            fit: BoxFit.cover),
                      ),
                    ),
                    title: smallText(snaptot.data!.data[i].name),
                    subtitle: text(
                      "${snaptot.data!.data[i].description.substring(0, 30)}...",
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: pcolor,
                    ),
                    onTap: () async {
                      bizlist = [];
                      bizbal = [];
                      persons = [];
                      balcurrency = [];
                      getuserpayout().then(
                        (value) {
                          Navigator.push(
                            context,
                            (MaterialPageRoute(
                              builder: (context) => BusinessTransactions(
                                  num.parse(snaptot.data!.data[i].id),
                                  i,
                                  widget._wallet),
                            )),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (snaptot.hasError) {
            return Container();
          } else {
            return const SpinKitCircle(
              size: 50,
              color: Color.fromARGB(255, 114, 81, 79),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegsiterBusiness(widget._wallet)),
        ),
        backgroundColor: pcolor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
