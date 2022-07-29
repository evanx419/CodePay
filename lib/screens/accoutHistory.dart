import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guavapay/models/walletfunds/accountHistoryclass.dart';
import 'package:guavapay/utilities/appbar.dart';
import 'package:guavapay/utilities/variables.dart';
import 'package:shimmer/shimmer.dart';
import '../utilities/appText.dart';

class ListHistory extends StatefulWidget {
  var title;

  ListHistory(this.title, {Key? key}) : super(key: key);

  @override
  State<ListHistory> createState() => _ListHistoryState();
}

class _ListHistoryState extends State<ListHistory> {
  Color? color;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: otherAppBar("${widget.title} History", context),
      body: Theme(
        data: themedata,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: history!.data.transactions.length,
                    itemBuilder: (context, index) {
                      var item = history!.data.transactions;
                      var amount = item[index].amount;
                      // var status = item[index].;

                      if (item[index].amount.isNegative) {
                        color = Colors.red;
                      } else {
                        color = Colors.green;
                      }

                      if (item.isNotEmpty) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 214, 213, 213),
                            child: item[index].amount.isNegative
                                ? text(
                                    "DR",
                                  )
                                : text(
                                    "CR",
                                  ),
                          ),
                          title: title("${item[index].id.substring(0, 25)}"),
                          trailing: Container(
                            child: text(amount.abs().toString(),
                                color: Colors.white),
                            color: color!,
                            padding: const EdgeInsets.all(5),
                          ),
                        );
                      } else {
                        return Center(
                          child: whitesmallText("No Transaction History",
                              color: Colors.black),
                        );
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
