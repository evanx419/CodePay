// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:guavapay/screens/recieveFunds.dart';
// import 'package:guavapay/screens/sendFund.dart';
// import 'package:guavapay/utilities/variables.dart';

// import '../screens/dashboard.dart';

// class BottomNav extends StatefulWidget {
//   var wallet;

//   BottomNav(this.wallet, {Key? key}) : super(key: key);

//   @override
//   State<BottomNav> createState() => _BottomNavState();
// }

// class _BottomNavState extends State<BottomNav> {
//   void _onItemTapped(int index) {
//     setState(() {
//       selectedIndex = index;
//     });

//     switch (selectedIndex) {
//       case 0:
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => Dashboard()),
//             (route) => false);
//         break;
//       case 1:
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => SendFund(widget.wallet)));
//         break;
//       case 2:
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => RecieveFund(widget.wallet)));
//         break;
//       default:
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         canvasColor: Colors.white,
//       ),
//       child: BottomNavigationBar(
//         elevation: 5,
//         currentIndex: selectedIndex,
//         iconSize: 30,
//         unselectedItemColor: const Color.fromARGB(255, 202, 198, 198),
//         selectedItemColor: Color(0xff22277a),
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(
//                 FontAwesomeIcons.house,
//                 size: 20,
//               ),
//               label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 FontAwesomeIcons.upload,
//                 size: 20,
//               ),
//               label: "Send"),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 FontAwesomeIcons.download,
//                 size: 20,
//               ),
//               label: "Receive"),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 FontAwesomeIcons.peopleGroup,
//                 size: 20,
//               ),
//               label: "Meet-Up"),
//         ],
//       ),
//     );
//   }
// }
