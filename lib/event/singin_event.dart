import 'package:bookstore/base/base_event.dart';
import 'package:flutter/widgets.dart';


class SignInEvent extends BaseEvent {
  String phone;
  String pass;

  SignInEvent({required this.phone, required this.pass});
}
