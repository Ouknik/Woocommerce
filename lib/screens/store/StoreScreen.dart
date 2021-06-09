import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/screens/authentification/login/Login.dart';
import 'package:woocomerce/screens/cart/CartScreen.dart';
import 'package:woocomerce/screens/favorite/FavoriateScreen.dart';
import 'package:woocomerce/screens/home/Home_Screen.dart';
import 'package:woocomerce/screens/profile/Profile%20Screen.dart';

import 'package:woocomerce/screens/store/storeWidgets/wCategories.dart';

import 'package:woocomerce/screens/store/storeWidgets/wProductRow.dart';
import 'package:woocomerce/utili/Style.dart';

import '../../config.dart';

class StoreScreen extends StatefulWidget {
  static final id = "StoreScreen";

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

//hna tantistiw wach login 3ad tandkhl l ProfileScren
  Future<Widget> loadFromFuture() async {
    // await Future.delayed(Duration(seconds: 5));
    final isLogged = await WooCommerceApi().checkLogged();
    if (isLogged) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ProfileScreen();
      }));
    } else {
      Fluttertoast.showToast(
          msg: "you ned to login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  Future<Widget> loadFromFuture2() async {
    // await Future.delayed(Duration(seconds: 5));
    final isLogged = await WooCommerceApi().checkLogged();
    if (isLogged) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return CartScreen();
      }));
    } else {
      Fluttertoast.showToast(
          msg: "you ned to login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: SectionTitleColors,
          title: Text("MyStor"),
        ),
        drawer: Drawer(
          child: Scaffold(
            backgroundColor: BacgroundColors,
            body: ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountEmail: Text(''),
                  accountName: Text(MyStor),
                  arrowColor: Colors.red,
                  currentAccountPicture: Image.asset(logo),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return HomeScreen();
                      }));
                    },
                    child: ListTile(
                      title: Text('Home Page',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.home),
                    )),
                InkWell(
                    onTap: () {
                      loadFromFuture();
                    },
                    child: ListTile(
                      title: Text('My Account',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.person),
                    )),
                InkWell(
                    onTap: () {
                      loadFromFuture2();
                    },
                    child: ListTile(
                      title: Text('Shipping Cart',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.shopping_cart),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return CartScreen();
                      }));
                    },
                    child: ListTile(
                      title: Text('The Store',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.store),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FavoraiteScreen();
                      }));
                    },
                    child: ListTile(
                      title: Text('Favourites',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.favorite),
                    )),
                InkWell(
                    onTap: () async {
                      var test = await WooCommerceApi.prodMode.logUserOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                    },
                    child: ListTile(
                      title: Text('LogOut',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.logout),
                    )),
                Divider(),
                InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Settings',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.settings),
                    )),
                InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('About',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.help, color: Colors.blue),
                    )),
              ],
            ),
          ),
        ),
        body: Container(
          color: BacgroundColors,
          child: Container(
            color: BacgroundColors,
            child: Column(
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Expanded(
                      child: Container(
                        color: SectionTitleColors,
                        child: wCategories(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: wProductRow(),
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
