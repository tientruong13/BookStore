import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/base/base_widget.dart';
import 'package:bookstore/data/remote/user_service.dart';
import 'package:bookstore/data/repo/user_repo.dart';
import 'package:bookstore/event/signup_event.dart';
import 'package:bookstore/event/signup_fail_event.dart';
import 'package:bookstore/event/signup_sucess_event.dart';
import 'package:bookstore/module/home/home_page.dart';
import 'package:bookstore/module/signup/signup_bloc.dart';
import 'package:bookstore/shared/app_color.dart';
import 'package:bookstore/shared/widget/bloc_listener.dart';
import 'package:bookstore/shared/widget/loading_task.dart';
import 'package:bookstore/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
        return PageContainer(
      title: 'Sign up',
      di: [
        Provider.value(value: UserService()
        ),
        ProxyProvider<UserService,UserRepo>(
          update: (context, userService, previous) =>
            UserRepo(userService: userService),
        )
      ],
      bloc: [],
      child: SignUpFormWidget(),

      
    );
  }
}

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
    final TextEditingController _txtDisplayNameController =
      TextEditingController();

  final TextEditingController _txtPhoneController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

  handleEvent(BaseEvent event) {
    if (event is SignUpSuccessEvent) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('/home'),
      );
      return;
    }

    if (event is SignUpFailEvent) {
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
        return Provider<SignUpBloc>(
      create: (_) => SignUpBloc(userRepo: Provider.of(context)),
      child: Consumer<SignUpBloc>(
        builder: (context, bloc, child) {
          return BlocListener<SignUpBloc>(
            listener: handleEvent,
            child: LoadingTask(
              bloc: bloc,
              child:         Container(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDisplayNameField(SignUpBloc, bloc),
              _buildPhoneField(SignUpBloc, bloc),
              _buildPasswordField(SignUpBloc, bloc),
              buildSignUpButton(SignUpBloc, bloc),
              
            ],
          
          ),
        ),
            )
          );
        }

      ),
    );
  }
Widget buildSignUpButton(SignUpBloc, bloc){
  return StreamProvider<bool>.value(
    initialData: false,
    value: bloc.btnStream,
    child: Consumer<bool>(
      builder: (context, enable, child) => 
        NormalButton(
          title: 'Sign Up',
         onPressed: enable ?() {
                bloc.event.add(SignUpEvent(
                  displayName: _txtDisplayNameController.text,
                  phone: _txtPhoneController.text, 
                  pass: _txtPassController.text,
                ),);
         }: null,
        )
      )   
  );
}
Widget _buildDisplayNameField(SignUpBloc, bloc) {
  return StreamProvider<String?>.value(
    initialData: null,
    value: bloc.displayNameStream,
    child: Consumer<String?>(
      builder: (context, msg, child) => Container(
        margin: EdgeInsets.only(bottom: 25),
        child: TextField(
          controller: _txtDisplayNameController,
          onChanged: (text) {
            bloc.displayNameSink.add(text);
            
          },
          keyboardType: TextInputType.text,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            icon: Icon(Icons.people,
              color: AppColor.blue,
            ),
            hintText: 'DisplayName',
            labelText: 'DisplayName',
            errorText: msg,
            labelStyle: TextStyle(color: AppColor.blue),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildPhoneField(SignUpBloc, bloc) {
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

Widget _buildPasswordField(SignUpBloc, bloc) {
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

}
