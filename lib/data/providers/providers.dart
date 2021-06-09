import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/screens/cart/model/CartItem.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/woocommerce.dart';

/// Home Screen Data =======================================================
final productsProvider = FutureProvider.autoDispose
    .family<List<WooProduct>, String>((ref, catID) async {
  ref.maintainState = true;

  final products = await WooCommerceApi().getAllProducts(catID);
  return products;
});

final productsCategoriesProvider =
    FutureProvider.autoDispose<List<WooProductCategory>>((ref) async {
  ref.maintainState = true;

  final productsCategories = await WooCommerceApi().getAllCategories();
  return productsCategories;
});

final favoriteChangeNotifierProvider =
    ChangeNotifierProvider<FavoriteNotifier>((ref) => FavoriteNotifier());

final productsChangeNotifierProvider =
    ChangeNotifierProvider<ProductsNotifier>((ref) => ProductsNotifier());

class FavoriteNotifier extends ChangeNotifier {
  List<WooProduct> _favoriteList = [];

  List<WooProduct> get favoriteList => _favoriteList;

  void addToFav(WooProduct product) {
    print("Added");
    _favoriteList.add(product);
    notifyListeners();
  }

  void removeFromFav(WooProduct product) {
    print("Removed");

    _favoriteList.remove(product);
    notifyListeners();
  }
}

class ProductsNotifier extends ChangeNotifier {
  String _catId = "15";
  int _selectedIndex = 0;

  int _selectedImage = 0;
  int _quantity = 1;

  String get catId => _catId;

  set catId(String value) {
    _catId = value;
  }

  int changeSelectedIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
    return _selectedIndex;
  }

  int changeSelectedImage(int newIndex) {
    _selectedImage = newIndex;
    notifyListeners();
    return _selectedImage;
  }

  void addQuantity() {
    notifyListeners();
  }

  void subQuantity() {
    if (_quantity > 1) {
      _quantity--;
    }

    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
  }

  int get selectedImage => _selectedImage;

  set selectedImage(int value) {
    _selectedImage = value;
  }

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }
}

final cartChangeNotifierProvider = ChangeNotifierProvider<CartNotifier>((ref) {
  return CartNotifier();
});

class CartNotifier extends ChangeNotifier {
  List<CartItem> _cartList = [];

  List<CartItem> get cartList => _cartList;

  var isExist = false;
  var _total;

  get total => _total;

  set total(value) {
    _total = value;
  }

  // https://stackoverflow.com/questions/66321199/how-do-avoid-markneedsbuilder-error-using-flutter-riverpod-and-texteditingcont
  double getTotalprice() {
    _total = 0.0;
    for (var cartItem in _cartList) {
      if (cartItem.product.price.isNotEmpty)
        _total += double.parse(cartItem.product.price) * cartItem.quantity;
      // notifyListeners();

    }
    return _total;
  }

  void addToCart({WooProduct wooProduct, int pQuantity}) async {
    CartItem cartItem = CartItem(wooProduct, pQuantity);

    final checkItem = _cartList.firstWhere(
        (element) => element.product.id == cartItem.product.id,
        orElse: () => null);
    if (checkItem != null) {
      isExist = true;
    } else {
      _cartList.add(cartItem);

      notifyListeners();
      isExist = false;
    }
  }

  void clearCart() async {
    print("CartNotifier clearCart ");

    _cartList.clear();
    print(_cartList.length);
    notifyListeners();
  }
}

/// Profile Screen Data =======================================================

final usersProvider = FutureProvider.autoDispose<WooCustomer>((ref) async {
  ref.maintainState = false;
  final customer = await WooCommerceApi().getCustumerInfo();
  return customer;
});

final ordersProvider = FutureProvider.autoDispose<List<WooOrder>>((ref) async {
  ref.maintainState = true;
  final products = await WooCommerceApi().getUserOrders();
  return products;
});
final shippingMethodsProvider =
    FutureProvider.autoDispose<List<WooShippingMethod>>((ref) async {
  ref.maintainState = true;
  final products = await WooCommerceApi().getShippingMethods();
  return products;
});
