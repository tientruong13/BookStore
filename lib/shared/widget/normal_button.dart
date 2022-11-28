import 'package:bookstore/shared/style/btn_style.dart';
import 'package:flutter/material.dart';


import '../app_color.dart';

class NormalButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  NormalButton({required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)), 
            primary: AppColor.yellow,),
        
        
        child: Text(
          title,
          style: BtnStyle.normal(),
        ),
      ),
    );
  }
}
