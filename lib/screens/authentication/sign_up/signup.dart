import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
    final _appBar = AppBar(
      backgroundColor: Color (0xFF101010),
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

    return Scaffold(
        appBar: _appBar,
        backgroundColor: Color (0xFF101010),
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
                  height: _height * 0.05,
                ),
                _buildUsernameTextField(context),
                SizedBox(
                  height: _height * 0.05,
                ),
                _buildPasswordTextfield(context),
                SizedBox(
                  height: _height * 0.05,
                ),
                _buildPasswordConfirmTextField(context),
                SizedBox(
                  height: _height * 0.05,
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
        controller: _emailController,
        validator: (value)=> EmailFieldValidator.validate(value!),
        style: const TextStyle(color: Colors.lightGreen),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: S.of(context).SignupEmail,
            filled: true,
            icon: const Icon(Icons.email, color: Colors.lightGreen,),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
        )
    );
  }

  Widget _buildPasswordTextfield(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      validator: (value)=> PasswordFieldValidator.validate(value!),
      style: const TextStyle(color: Colors.lightGreen),
      decoration: InputDecoration(
          labelText: S.of(context).SignupPwd,
          filled: true,
          icon: const Icon(Icons.key, color: Colors.lightGreen),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
            )
          ),
          labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
      ),
      obscureText: true,
    );
  }

  Widget _buildPasswordConfirmTextField(BuildContext context) {
    return TextFormField(
      controller: _passConfirmController,
      validator: (value)=> PassConfirmFieldValidator.validate(value!, _passwordController),
      style: const TextStyle(color: Colors.lightGreen),
      decoration: InputDecoration(
          labelText: S.of(context).SignupConfirmPwd,
          filled: true,
          icon: const Icon(Icons.key, color: Colors.lightGreen,),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
      ),
      obscureText: true,
    );
  }

  Widget _buildUsernameTextField(BuildContext context) {
    return TextFormField(
      controller: _usernameController,
      validator: (value)=> UsernameFieldValidator.validate(value!),
      style: const TextStyle(color: Colors.lightGreen),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          labelText: S.of(context).SignupUser,
          filled: true,
          icon: const Icon(Icons.person, color: Colors.lightGreen),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
      ),
    );
  }


  Widget _buildButton(BuildContext context) {
    return MaterialButton(
        color: Colors.lightGreen,
        textColor: Colors.white,
        child: AutoSizeText(S.of(context).SignupButton),
        onPressed: () => {
          if(formGlobalKey.currentState!.validate()){
            _authService.signUp(_emailController.text, _passwordController.text, _usernameController.text, context)
          }
        },
    );
  }


}