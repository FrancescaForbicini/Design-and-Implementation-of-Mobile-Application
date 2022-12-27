import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../services/authentication_service.dart';

class EmailFieldValidator{
  static String? validate(String value){
    return (value.isEmpty || !RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value) ) ? 'Invalid Email' : null;
  }
}

class PasswordFieldValidator{
  static String? validate(String value){
    return (value.isEmpty || value.length <6) ? 'Password can\'t be empty or shorter than 6 characters' : null;
  }
}

class PassConfirmFieldValidator{
  static String? validate(String value, TextEditingController pass){
    return (value != pass.text) ? 'The passwords do not match' : null;
  }
}

class UsernameFieldValidator{
  static String? validate(String value){
    return (value.isEmpty) ? 'Username can\'t be empty' : null;
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
      title: const AutoSizeText(
        'Sign Up',
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
                _buildEmailTextfield(),
                SizedBox(
                  height: _height * 0.05,
                ),
                _buildUsernameTextField(),
                SizedBox(
                  height: _height * 0.05,
                ),
                _buildPasswordTextfield(),
                SizedBox(
                  height: _height * 0.05,
                ),
                _buildPasswordConfirmTextField(),
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


  Widget _buildEmailTextfield() {
    return TextFormField(
        controller: _emailController,
        validator: (value)=> EmailFieldValidator.validate(value!),
        style: const TextStyle(color: Colors.lightGreen),
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
            labelText: 'Email',
            filled: true,
            icon: Icon(Icons.email, color: Colors.lightGreen,),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
        )
    );
  }

  Widget _buildPasswordTextfield() {
    return TextFormField(
      controller: _passwordController,
      validator: (value)=> PasswordFieldValidator.validate(value!),
      style: const TextStyle(color: Colors.lightGreen),
      decoration: const InputDecoration(
          labelText: 'Password',
          filled: true,
          icon: Icon(Icons.key, color: Colors.lightGreen),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
            )
          ),
          labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
      ),
      obscureText: true,
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      controller: _passConfirmController,
      validator: (value)=> PassConfirmFieldValidator.validate(value!, _passwordController),
      style: const TextStyle(color: Colors.lightGreen),
      decoration: const InputDecoration(
          labelText: 'Confirm Password',
          filled: true,
          icon: Icon(Icons.key, color: Colors.lightGreen,),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400 ,
              fontFamily: 'Calibri')
      ),
      obscureText: true,
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      controller: _usernameController,
      validator: (value)=> UsernameFieldValidator.validate(value!),
      style: const TextStyle(color: Colors.lightGreen),
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
          labelText: 'Username',
          filled: true,
          icon: Icon(Icons.person, color: Colors.lightGreen),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: TextStyle(
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
        child: AutoSizeText('SIGN UP'),
        onPressed: () => {
          if(formGlobalKey.currentState!.validate()){
            _authService.signUp(_emailController.text, _passwordController.text, _usernameController.text, context)
          }
        },
    );
  }


}