import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/shared/model/product.dart';


class AddToCartEvent extends BaseEvent {
  Product product;

  AddToCartEvent(this.product);
}
