import 'dart:convert';
import 'dart:async';
import 'package:bookstore/data/remote/user_service.dart';
import 'package:bookstore/data/spref/spref.dart';
import 'package:bookstore/shared/constant.dart';
import 'package:bookstore/shared/model/user_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';


class UserRepo {
  UserService _userService;

  UserRepo({required UserService userService}) : _userService = userService;

  Future<UserData>signIn(String phone, String pass) async {
    var c = Completer<UserData>();

    try {
    var response = await _userService.signIn(phone, pass);
    var userData = UserData.formJson(response.data['data']);
    if (userData !=null) {
      SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token!);
      c.complete(userData);
    }
    } on DioError catch (e) {
      print(e.response?.data);
      c.completeError('Dang nhap that bai');
    }
    catch(e) {
        c.completeError(e);
    }
    return c.future;
  }


    Future<UserData> signUp(String displayName, String phone, String pass) async {
    var c = Completer<UserData>();
    try {
      var response = await _userService.signUp(displayName, phone, pass);
      var userData = UserData.formJson(response.data['data']);
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token!);
        c.complete(userData);
      }
      } on DioError catch (e) {
      print(e.response?.data);
      c.completeError('Đăng ký thất bại');
    }
    catch(e) {
        c.completeError(e);
    }
    return c.future;
  }
}
