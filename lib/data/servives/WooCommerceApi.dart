import 'dart:developer';

import 'package:woocomerce/utili/Constants.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/models/order.dart';
import 'package:woocommerce/models/order_payload.dart';
import 'package:woocommerce/woocommerce.dart';
import 'package:woocomerce/config.dart';

class WooCommerceApi {
  static WooCommerce prodMode = WooCommerce(
    baseUrl: "$url",
    consumerKey: "$consumerKey",
    consumerSecret: "$consumerSecret",
    isDebug: false,
  );

  //products****************************************************

  Future<List<WooProduct>> getProductsRealDamain() async {
    final myProducts = await prodMode.getProducts();
    return myProducts;
  }

  //***********************************************************

  /// Search Screen  ================================================================================
  Future<List<WooProduct>> getProductBySearch(String query) async {
    final myProducts = await prodMode.getProducts(
        status: "publish", perPage: 10, page: 1, search: "$query");
    print("WooCommerceApi === getProducts1 : ${myProducts.length}");
    return myProducts;
  }

  /// Home Screen  ================================================================================
  Future<List<WooProduct>> getAllProducts(String catId) async {
    final myProducts = await prodMode.getProducts(
      status: "publish",
      perPage: 10,
      page: 1,
      category: "$catId",
    );
    print("WooCommerceApi === getProducts1 : ${myProducts.length}");
    return myProducts;
  }

  Future<List<WooProductCategory>> getAllCategories() async {
    final myProducts =
        await prodMode.getProductCategories(perPage: 10, hideEmpty: true);
    print("WooCommerceApi === getAllCategories : ${myProducts.length}");
    return myProducts;
  }

  /// SignUp screen ================================================================================
  Future<bool> createCustumer(WooCustomer customer) async {
    final user = await prodMode.createCustomer(customer);
    return user;
  }

  /// login screen  ================================================================================
  Future<dynamic> loginUser(String username1, String password1) async {
    var user = await prodMode.loginCustomer(
        username: "${username1}", password: "${password1}");
    return user;
  }

  Future<bool> checkLogged() async {
    log("checkLogged Called:");
    final logged = await prodMode.isCustomerLoggedIn();
    if (logged == true) {
      log("logged  Value : $logged !!");

      return true;
    } else {
      log("User Not logged in !!");
      return false;
    }
  }

  /// Profile Screen  ================================================================================
  Future<WooCustomer> getCustumerInfo() async {
    print("getCustumerInfo :");

    final userId = await prodMode.fetchLoggedInUserId();
    final myProducts = await prodMode.getCustomerById(id: userId);
    return myProducts;
  }

  Future<List<WooOrder>> getUserOrders() async {
    print("getUserOrders :");

    final customerId = await getCustumerInfo();
    print("customerId in getUserOrders: ${customerId.id} ");

    // final myProducts = await prodMode.getOrders(customer: customerId.id);
    var a = [
      'processing',
      'on-hold',
      'pending', // default
      'refunded',
      'cancelled',
      'completed',
      'failed',
      'trash',
      'any',
    ];
    final myProducts = await prodMode.getOrders();
    // final myProducts = await ApiRequest().(customer: 1);

    print("getUserOrders : ${myProducts.length} ");
    return myProducts;
  }

  Future<List<WooCoupon>> getCoupons() async {
    final myProducts = await prodMode.getCoupons();
    print("getCoupons : ${myProducts.length}");
    return myProducts;
  }

  /// Payment Screen  ================================================================================
  Future<List<WooShippingMethod>> getShippingMethods() async {
    final myProducts = await prodMode.getShippingMethods();
    print("getShippingMethods : ${myProducts.length}");
    return myProducts;
  }

  Future<WooOrder> createOrder(WooOrderPayload orderPayload) async {
    final myProducts = await prodMode.createOrder(orderPayload);

    print("createOrder : ${myProducts}");
    return myProducts;
  }
}
