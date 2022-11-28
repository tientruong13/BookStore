import 'package:bookstore/base/base_event.dart';
import 'package:flutter/widgets.dart';

class SignUpEvent extends BaseEvent {
  String displayName;
  String phone;
  String pass;

  SignUpEvent({
    required this.displayName,
    required this.phone,
    required this.pass,
  });
}
