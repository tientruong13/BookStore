import 'package:bookstore/module/home/home_page.dart';
import 'package:bookstore/module/signin/signin_page.dart';
import 'package:bookstore/module/signup/signup_page.dart';
import 'package:bookstore/shared/app_color.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        primarySwatch: AppColor.yellow,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => SignInPage(),
        '/home': (context) => HomePage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        // '/checkout': (context) => CheckoutPage(),
      },
      
    );
  }
}
