import 'package:woocommerce/models/products.dart';


class CartItem {
  WooProduct product;
  int _quantity;

  CartItem(this.product, this._quantity);

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }
}
