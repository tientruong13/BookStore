import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/base/base_widget.dart';
import 'package:bookstore/data/remote/user_service.dart';
import 'package:bookstore/data/repo/user_repo.dart';
import 'package:bookstore/event/signin_fail_event.dart';
import 'package:bookstore/event/signin_sucess_event.dart';
import 'package:bookstore/event/singin_event.dart';
import 'package:bookstore/module/signin/signin_bloc.dart';
import 'package:bookstore/shared/app_color.dart';
import 'package:bookstore/shared/widget/bloc_listener.dart';
import 'package:bookstore/shared/widget/loading_task.dart';
import 'package:bookstore/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Sign In',
      di: [
        Provider.value(value: UserService()
        ),
        ProxyProvider<UserService,UserRepo>(
          update: (context, userService, previous) =>
            UserRepo(userService: userService),
        )
      ],
      bloc: [],
      child: SignInFormWidget(),

      
    );
  }
}

class SignInFormWidget extends StatefulWidget {

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  TextEditingController _txtPhoneController = TextEditingController();

  TextEditingController _txtPassController = TextEditingController();

    handleEvent(BaseEvent event) {
    if (event is SignInSuccessEvent) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    if (event is SignInFailEvent) {
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(userRepo: Provider.of(context)),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, child) {
          return BlocListener<SignInBloc>(
            listener: handleEvent,
            child: LoadingTask(
               bloc: bloc,
               child:Container(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPhoneField(SignInBloc, bloc),
              _buildPasswordField(SignInBloc, bloc),
              buildSignInButton(SignInBloc, bloc),
              _buildFooter(context)
            ],
          
          ),
        ),
               
               )
          );
        }

      ),
    );
  }

Widget buildSignInButton(SignInBloc, bloc){
  return StreamProvider<bool>.value(
    initialData: false,
    value: bloc.btnStream,
    child: Consumer<bool>(
      builder: (context, enable, child) => 
        NormalButton(
          title: 'Sign in',
         onPressed: enable ?() {
                bloc.event.add(SignInEvent(
                  phone: _txtPhoneController.text, 
                  pass: _txtPassController.text,
                ),);
         }: null,
        )
      )   
  );
}

  Widget _buildPhoneField(SignInBloc, bloc) {
  return StreamProvider<String?>.value(
    initialData:null,
    value: bloc.phoneStream,
    child: Consumer<String?>(
      builder: (context, msg, child) =>  Container(
        margin: EdgeInsets.only(bottom: 15),
        child: TextField(
          controller: _txtPhoneController,
          onChanged: (text) {
            bloc.phoneSink.add(text);
            
          },
          keyboardType: TextInputType.phone,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            icon: Icon(Icons.phone,
              color: AppColor.blue,
            ),
            hintText: 'phone',
            errorText: msg,
            labelText: 'phone',
            labelStyle: TextStyle(color: AppColor.blue),
          ),
        ),
      ),
    ),
  );
}

Widget _buildPasswordField(SignInBloc, bloc) {
  return StreamProvider<String?>.value(
    initialData: null,
    value: bloc.passStream,
    child: Consumer<String?>(
      builder: (context, msg, child) => Container(
        margin: EdgeInsets.only(bottom: 25),
        child: TextField(
          controller: _txtPassController,
          onChanged: (text) {
            bloc.passSink.add(text);
            
          },
          obscureText: true,
          keyboardType: TextInputType.text,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            icon: Icon(Icons.lock,
              color: AppColor.blue,
            ),
            hintText: 'Password',
            labelText: 'Password',
            errorText: msg,
            labelStyle: TextStyle(color: AppColor.blue),
          ),
        ),
      ),
    ),
  );
}

Widget _buildFooter(context){
  return Container(
    margin: EdgeInsets.only(top: 30),
    padding: EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-up');
              },

              child: Text(
                'Sign Up',
                style: TextStyle(color: AppColor.blue, fontSize: 17),
              )
            ),
          );
}
}






