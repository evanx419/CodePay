import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guavapay/models/businessmodel/codepaymentclass.dart';
import 'package:guavapay/models/walletModel.dart';
import 'package:guavapay/screens/balancepage.dart';
import 'package:guavapay/screens/createAcct.dart';
import 'package:guavapay/screens/listAccounts.dart';
import 'package:guavapay/screens/listBusiness.dart';
import 'package:guavapay/screens/listpayment.dart';
import 'package:guavapay/screens/paymentmethod.dart';
import 'package:guavapay/screens/respond.dart';
import 'package:guavapay/screens/transactions.dart';
import 'package:guavapay/utilities/appText.dart';
import 'package:guavapay/utilities/appbar.dart';

import 'package:guavapay/utilities/sharedprefernce.dart';
import 'package:shimmer/shimmer.dart';
import '../models/businessmodel/pay.dart';
import '../models/walletfunds/balance.dart';
import 'package:intl/intl.dart';

import '../utilities/variables.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 

  Color? color;
  // final formatCurrency = NumberFormat.simpleCurrency();

  @override
  void initState() {
    

    // gettransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: mainAppBar(sessionid, context),
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://static.toiimg.com/thumb/67089274/space-travel.jpg?width=1200&height=900",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(10),
              height: 220,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      guavaText("CodePay+"),
                      Expanded(child: Container()),
                      whitesmallText(
                        "${userinfo?.data.firstName} ${userinfo?.data.lastName}",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  whitesmallText("Guava Space Ticket Payment"),
                  whitesmallText(r"$150,000/Seat"),
                  InkWell(
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black26.withOpacity(0.3),
                          border: Border.all(
                              color: const Color.fromARGB(255, 233, 235, 233),
                              width: 3),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: payText("Pay Now"),
                      ),
                    ),
                    onTap: () async {
                      await getuserpayment();
                      // postuserpayment().then((value) {
                      //   print(value);
                      // });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerPaymentMethod(
                              myWalletId,
                              "${userinfo?.data.firstName} ${userinfo?.data.lastName}"),
                        ),
                      );
                    },
                  ),
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [whitesmallText("Powered by Rapyd", size: 12)],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
                // color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
// ################################################## virtual
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        smallText("Virtual Accounts", color: Colors.black),
                        Expanded(child: Container()),
                        // smallText("Add "),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.black),
                          onPressed: ()async => Navigator.push(
                            context,
                            (MaterialPageRoute(
                              builder: (context) => ListAccounts(myWalletId),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 90,
                    width: double.infinity,
// ########################################list business
                    child: StreamBuilder<Balaceclass>(
                      stream: streamBalanace(myWalletId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.data.isNotEmpty) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: snapshot.data!.data.length,
                              itemBuilder: (context, index) {
                                var formatCurrency =
                                    NumberFormat.simpleCurrency(
                                        name: snapshot
                                            .data!.data[index].currency);
                                return InkWell(
                                  child: Container(
                                    height: 70,
                                    width: 130,
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 201, 201, 201),
                                          blurRadius: 20,
                                          offset: Offset(2, 9),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                              255, 177, 191, 230),
                                          radius: 23,
                                          child: smallText(
                                              snapshot
                                                  .data!.data[index].currency,
                                              color: Colors.white),
                                        ),
                                        FittedBox(
                                          child: smallText(
                                              formatCurrency.format(snapshot
                                                  .data!.data[index].balance)),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BalancePage(
                                          snapshot.data!.data[index].balance,
                                          snapshot.data!.data[index]
                                              .receivedBalance,
                                          snapshot
                                              .data!.data[index].onHoldBalance,
                                          snapshot
                                              .data!.data[index].reserveBalance,
                                          snapshot.data!.data[index].currency,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            return Center(
                                child: Column(
                              children: [
                                title("No Account Found"),
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: title("Add Acconunt",
                                        color: Colors.blue),
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    (MaterialPageRoute(
                                      builder: (context) =>
                                          CreateUserAccout(myWalletId),
                                    )),
                                  ),
                                ),
                              ],
                            ));
                          }
                        } else {
                          return Shimmer.fromColors(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: 5,
                                itemBuilder: (context, i) {
                                  return Container(
                                    height: 90,
                                    width: 130,
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(2),
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    child: Column(
                                      children: [
                                        FittedBox(
                                          child: smallText("      "),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            baseColor: const Color.fromARGB(255, 231, 231, 231),
                            highlightColor:
                                const Color.fromARGB(255, 247, 246, 244),
                          );
                        }
                      },
                    ),
                  ),
                  Divider(),
                  const SizedBox(height: 10),

                  Center(
                    child: Wrap(
                      children: <Widget>[
                        Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width /
                              2.2, //entire container height
                          // padding:
                          //     const EdgeInsets.only(left: 45, right: 45, top: 10),
                          // color: Colors.white,

                          child: Center(
                              child: Column(
                            children: [
                              InkWell(
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8XHB1gAOYda1hEDRtx5l0PuxVpJwfaHkT5g&usqp=CAU",
                                      height: 150,
                                    ),
                                    guavaText(
                                      "Register Business",
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                // onHover: (){},
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ListBusinss(myWalletId),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                        Container(
                          height: 180, //entire container height
                          width: MediaQuery.of(context).size.width / 2.2,
                          // padding:
                          //     const EdgeInsets.only(left: 45, right: 45, top: 10),
                          // color: Colors.white,

                          child: Center(
                            child: Column(
                              children: [
                                InkWell(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUk4dtcXRE9XK3QxsIj5ZjxFYCenfSVIAc2A&usqp=CAU",
                                        height: 150,
                                      ),
                                      guavaText(
                                        "Transactions",
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  // onHover: (){},
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Transactionspage(myWalletId)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width /
                              2.2, //entire container height
                          // padding:
                          //     const EdgeInsets.only(left: 45, right: 45, top: 10),
                          // color: Colors.white,

                          child: Center(
                              child: Column(
                            children: [
                              InkWell(
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTE-3lbN0YKCM5wbV6rAosbpGD8OreaFXwsg&usqp=CAU",
                                      height: 150,
                                    ),
                                    guavaText(
                                      "Payments",
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                // onHover: (){},
                                onTap: () async => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListPayments(myWalletId)),
                                ),
                              ),
                            ],
                          )),
                        ),
                        Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width /
                              2.2, //entire container height
                          // color: Colors.white,

                          child: Center(
                              child: Column(
                            children: [
                              InkWell(
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://assets.materialup.com/uploads/636d474d-2780-43d3-aa2c-b4aa9696c906/preview.jpg",
                                      height: 150,
                                    ),
                                    guavaText(
                                      "Responsed",
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                // onHover: (){},
                                onTap: () async => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Respond()),
                                ),
                              ),
                            ],
                          )),
                        ),
                        // Container(
                        //   height: 180, //entire container height
                        //   width: MediaQuery.of(context).size.width / 2.2,
                        //   // padding:
                        //   //     const EdgeInsets.only(left: 45, right: 45, top: 10),
                        //   color: Colors.white,

                        // child: Center(
                        //   child: Column(
                        //     children: [
                        //       InkWell(
                        //           child: Column(
                        //             children: [
                        //               Image.network(
                        //                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNcojVgxybW5oRkiQ_BZxMJRRsAuTTElo9IQ&usqp=CAU",
                        //                 height: 150,
                        //               ),
                        //               guavaText(
                        //                 "Wallet contacts",
                        //                 size: 15,
                        //                 color: Colors.black,
                        //               ),
                        //             ],
                        //           ),
                        //           // onHover: (){},
                        //           onTap: () => {}),
                        //     ],
                        //   ),
                        // ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
