import 'package:bookstore/shared/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PageContainer extends StatelessWidget {
  final String? title;
  final Widget? child;

  final List<Widget>? actions;
  final List<SingleChildWidget> bloc;
  final List<SingleChildWidget> di;
  

  PageContainer({this.title, required this.bloc, required this.di, this.actions,this.child});

  @override
  Widget build(BuildContext context) {
      return MultiProvider(
      providers: [
        ...di,
        ...bloc,
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title!, 
            style: TextStyle(color: AppColor.blue),
          ), centerTitle: true,
          actions: actions,
        ), 
        body: child,
      ),
    );
  }
}

class NavigatorProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[],
      ),
    );
  }
}
