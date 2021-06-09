import 'package:flutter/material.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/screens/home/homeWidgets/SectionsTitles.dart';
import 'package:woocomerce/utili/Style.dart';

import '../config.dart';
import 'authentification/login/Login.dart';
import 'cart/CartScreen.dart';
import 'favorite/FavoriateScreen.dart';
import 'home/Home_Screen.dart';
import 'profile/Profile Screen.dart';
import 'store/StoreScreen.dart';

class RoutingScreen1 extends StatefulWidget {
  static final id = "RoutingScreen1";

  @override
  _RoutingScreen1State createState() => _RoutingScreen1State();

  const RoutingScreen1();
}

class _RoutingScreen1State extends State<RoutingScreen1> {
  int bottomSelectedIndex = 0;
  var pageController;

  void OnPageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void OnbottomTapped(int index) {
    if ((bottomSelectedIndex - index.abs() == 1)) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      pageController.jumpToPage(index);
    }
  }

  init() async {
    var IsUserLoggedIn = await WooCommerceApi().checkLogged();
    print("User Logged in :$IsUserLoggedIn");
    if (IsUserLoggedIn == true) {}
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final pageView = PageView(
        controller: pageController,
        children: [
          HomeScreen(),
          StoreScreen(),
          Login(),
        ],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: OnPageChanged);

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(12)),
          isExtended: true,
          backgroundColor: ContanairColors,
          // mini: true,
          child: Image.network(SigneImageUrl),
          onPressed: () {},
        ),
        bottomNavigationBar: Container(
          color: SectionTitleColors,
          child: BottomNavigationBar(
            //showUnselectedLabels: true,

            selectedLabelStyle: sproductNamBlack,
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), title: Text('Home')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.store), title: Text('Store')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.login_outlined), title: Text('Login')),
            ],
            onTap: OnbottomTapped,
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.black,
            currentIndex: bottomSelectedIndex,
          ),
        ),
        body: pageView,
      ),
    );
  }
}
