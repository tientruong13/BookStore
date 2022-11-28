import 'dart:async';

import 'package:bookstore/base/base_bloc.dart';
import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/data/repo/user_repo.dart';
import 'package:bookstore/event/signup_event.dart';
import 'package:bookstore/event/signup_fail_event.dart';
import 'package:bookstore/event/signup_sucess_event.dart';
import 'package:bookstore/event/singin_event.dart';
import 'package:bookstore/shared/model/user_data.dart';
import 'package:bookstore/shared/widget/validation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';


class SignUpBloc extends BaseBloc {
  //check pass and phone, enable buttom
  final _displayNameSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  Stream<String?> get displayNameStream =>
      _displayNameSubject.stream.transform(displayNameValidation);
  StreamSink<String> get displayNameSink => _displayNameSubject.sink;

  Stream<String?> get phoneStream =>
      _phoneSubject.stream.transform(phoneValidation);
  StreamSink<String> get phoneSink => _phoneSubject.sink;

  Stream<String?> get passStream =>
      _passSubject.stream.transform(passValidation);
  StreamSink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  late UserRepo _userRepo;

  SignUpBloc({required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

// combine pass and phone => unable or enable buttom
  validateForm(){
    Rx.combineLatest3(
      _phoneSubject, 
      _passSubject, 
      _displayNameSubject,
      (phone, pass, displayName) {
        return Validation.isPhoneValid(phone) && Validation.isPassValid(pass) && Validation.isDisplayNameValid(displayName);
      }
    ).listen((enable){
        btnSink.add(enable);
      });
  } 
  // StreamTransformer input phone (String) output sink (String)
  var phoneValidation =
      StreamTransformer<String, String?>.fromHandlers(handleData: (phone, sink) {
    if (Validation.isPhoneValid(phone)) {
      sink.add(null);
      return;
    }
    sink.add('Phone invalid');
  });


  var displayNameValidation =
      StreamTransformer<String, String?>.fromHandlers(handleData: (displayName, sink) {
    if (Validation.isDisplayNameValid(displayName)) {
      sink.add(null);
      return;
    }
    sink.add('Display Name too short');
  });

  var passValidation = StreamTransformer<String, String?>.fromHandlers(
    handleData: (pass, sink) {
      if (Validation.isPassValid(pass)) {
        sink.add(null); 
        
        return;
      }
      sink.add('Password too short');
    }
  );

  @override
  void dispatchEvent(BaseEvent event) {
    switch(event.runtimeType) {


      case SignUpEvent: handleSignUp(event);
      break;
    }
  }

handleSignUp(event) {
    btnSink.add(false);
    loadingSink.add(true); // show loading

    Future.delayed(Duration(seconds: 6), () {
      SignUpEvent e = event as SignUpEvent;
      _userRepo.signUp(e.displayName, e.phone, e.pass).then(
        (userData) {
          processEventSink.add(SignUpSuccessEvent(userData));
        },
        onError: (e) {
          btnSink.add(true);
          loadingSink.add(false);
          processEventSink.add(SignUpFailEvent(e.toString()));
        },
      );
    });
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
    _displayNameSubject.close();
  }

}