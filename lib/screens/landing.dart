import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guavapay/screens/dashboard.dart';
import 'package:guavapay/screens/meetup.dart';
import 'package:guavapay/screens/recieveFunds.dart';
import 'package:guavapay/screens/sendFund.dart';
import '../models/businessmodel/pay.dart';
import '../utilities/notification.dart';
import 'dart:math';

import '../utilities/variables.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late List<Widget> _pages;
  late Widget _dashboard;
  late Widget _sendfund;
  late Widget _receivefund;
  late Widget _meetup;
  
  var myWalletId = "";
  Random random = new Random();

// #############
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(minutes: 1),
      ((timer) {
        myNotification().showNotification(
          0,
          "Space Tip:",
          hint[random.nextInt(8)],
          '',
        );
      }),
    );
    gettransaction();
    _dashboard = Dashboard();
    _sendfund = SendFund(myWalletId);
    _meetup = Meetup();
    _receivefund = RecieveFund();

    _pages = [_dashboard, _sendfund, _receivefund, _meetup];

    // currentIndex 
  }

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        currentIndex: currentIndex,
        iconSize: 30,
        unselectedItemColor: const Color.fromARGB(255, 202, 198, 198),
        selectedItemColor: const Color(0xff22277a),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          changeTab(index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.house,
                size: 20,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.upload,
                size: 20,
              ),
              label: "Send"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.download,
                size: 20,
              ),
              label: "Receive"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.peopleGroup,
                size: 20,
              ),
              label: "Meet-Up"),
        ],
      ),
    );
  }
}
