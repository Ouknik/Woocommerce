import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:woocomerce/screens/ButtonBar1.dart';
import 'package:woocomerce/screens/ButtonNavigatorBar.dart';
import 'package:woocomerce/screens/authentification/login/Login.dart';
import 'package:woocomerce/screens/authentification/register/Regestre.dart';
import 'package:woocomerce/screens/cart/CartScreen.dart';
import 'package:woocomerce/screens/favorite/FavoriateScreen.dart';
import 'package:woocomerce/screens/home/Home_Screen.dart';
import 'package:woocomerce/screens/profile/Profile%20Screen.dart';

import 'config.dart';
import 'data/servives/WooCommerceApi.dart';

void main() async {
  return runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Widget> loadFromFuture() async {
      await Future.delayed(Duration(seconds: 5));
      final isLogged = await WooCommerceApi().checkLogged();
      if (isLogged) {
        return Future.value(new RoutingScreen());
      } else {
        return Future.value(new RoutingScreen1());
      }
    }

    return MaterialApp(
      checkerboardOffscreenLayers: true,
      theme: Theme.of(context).copyWith(
        appBarTheme:
            Theme.of(context).appBarTheme.copyWith(brightness: Brightness.dark),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        navigateAfterFuture: loadFromFuture(),
        image: Image.asset(local_url),
        backgroundColor: Colors.blue,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
      ),
      routes: {
        HomeScreen.id: (c) => HomeScreen(),
        Login.id: (c) => Login(),
        Regestre.id: (c) => Regestre(),
        ProfileScreen.id: (c) => ProfileScreen(),
        RoutingScreen.id: (c) => RoutingScreen(),
        RoutingScreen1.id: (c) => RoutingScreen1(),
        FavoraiteScreen.id: (c) => FavoraiteScreen(),
        CartScreen.id: (c) => CartScreen(),
      },
    );
  }
}
