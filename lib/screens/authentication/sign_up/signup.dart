import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../customized_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../../services/authentication_service.dart';

class EmailFieldValidator{
  static String? validate(String value){
    return (value.isEmpty || !RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value) ) ? S.current.SignupErrEmail : null;
  }
}

class PasswordFieldValidator{
  static String? validate(String value){
    return (value.isEmpty || value.length <6) ? S.current.SignupErrPwd : null;
  }
}

class PassConfirmFieldValidator{
  static String? validate(String value, TextEditingController pass){
    return (value != pass.text) ? S.current.SignupErrMatchPwd : null;
  }
}

class UsernameFieldValidator{
  static String? validate(String value){
    return (value.isEmpty) ? S.current.SignupEmptyUser : null;
  }
}

final formGlobalKey = GlobalKey<FormState>();

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();


  @override
  Widget build(BuildContext context) {
    final _appBar = CustomizedAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.lightGreen,size: 30),
        onPressed: () => {
          Navigator.pop(context),
        },
      ),
      title: AutoSizeText(
        S.of(context).SignupTitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
    );
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _appBarHeight - _statusBarHeight;
    Color? textColor;

    return Scaffold(
        appBar: _appBar,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          height: _height,
          width: _screenWidth,
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildEmailTextfield(context),
                SizedBox(
                  height: _height * 0.02,
                ),
                _buildUsernameTextField(context),
                SizedBox(
                  height: _height * 0.02,
                ),
                _buildPasswordTextfield(context),
                SizedBox(
                  height: _height * 0.02,
                ),
                _buildPasswordConfirmTextField(context),
                SizedBox(
                  height: _height * 0.02,
                ),
                _buildButton(context),
              ],
            ),
          ),
        )
    );
  }


  Widget _buildEmailTextfield(BuildContext context) {
    return TextFormField(
      key: const Key('email_text_input'),
      controller: _emailController,
      validator: (value)=> EmailFieldValidator.validate(value!),
      style: const TextStyle(color: Colors.lightGreen),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: S.of(context).SignupEmail,
          filled: true,
          icon: const Icon(Icons.email, color: Colors.lightGreen,),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).iconTheme.color!,
                width: 2.0
            )
        ),
        labelStyle: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400 ,
            fontFamily: 'Calibri')
      )
    );
  }

  Widget _buildPasswordTextfield(BuildContext context) {
    return TextFormField(
      key: const Key('password_text_input'),
      controller: _passwordController,
      validator: (value)=> PasswordFieldValidator.validate(value!),
      style: const TextStyle(color: Colors.lightGreen),
      decoration: InputDecoration(
          labelText: S.of(context).SignupPwd,
          filled: true,
          icon: const Icon(Icons.key, color: Colors.lightGreen),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                  color: Theme.of(context).iconTheme.color!,
                  width: 2.0
            )
          ),
          labelStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
      ),
      obscureText: true,
    );
  }

  Widget _buildPasswordConfirmTextField(BuildContext context) {
    return TextFormField(
      key: const Key('confpass_text_input'),
      controller: _passConfirmController,
      validator: (value)=> PassConfirmFieldValidator.validate(value!, _passwordController),
      style: const TextStyle(color: Colors.lightGreen),
      decoration: InputDecoration(
          labelText: S.of(context).SignupConfirmPwd,
          filled: true,
          icon: Icon(Icons.key, color: Theme.of(context).iconTheme.color,),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).iconTheme.color!,
                  width: 2.0
              )
          ),
          labelStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
      ),
      obscureText: true,
    );
  }

  Widget _buildUsernameTextField(BuildContext context) {
    return TextFormField(
      key: const Key('username_text_input'),
      controller: _usernameController,
      validator: (value)=> UsernameFieldValidator.validate(value!),
      style: const TextStyle(color: Colors.lightGreen),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          labelText: S.of(context).SignupUser,
          filled: true,
          icon: Icon(Icons.person, color: Theme.of(context).iconTheme.color!),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).iconTheme.color!,
                  width: 2.0
              )
          ),
          labelStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
      ),
    );
  }


  Widget _buildButton(BuildContext context) {
    Future<bool> done;
    return MaterialButton(
      key: const Key('sign_up_button'),
      color: Colors.lightGreen,
      textColor: Colors.white,
      child: AutoSizeText(S.of(context).SignupButton),
      onPressed: () => {
        if(formGlobalKey.currentState!.validate()){
          done = _authService.signUp(_emailController.text, _passwordController.text, _usernameController.text, context),
          done.then((value) => {
            if(value){
              Navigator.pop(context),
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    key: const Key('signup_ok_dialog'),
                    title: Text(S.of(context).SignupOk),
                    content: Text(S.of(context).SignupOkText),
                    actions: [
                      MaterialButton(
                        child: Text(S.of(context).SignupOkButton),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
              )
            }
            else{
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(S.of(context).SignupFail),
                      content: Text(S.of(context).SignupFailText),
                      actions: [
                        MaterialButton(
                          child: Text(S.of(context).SignupFailButton),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  }
              )
            }
          })
        }
      },
    );
  }


}