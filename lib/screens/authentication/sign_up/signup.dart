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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color (0xFF101010),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.lightGreen,size: 30),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          title: Text('Sign Up', textAlign: TextAlign.center,style: new TextStyle(fontSize: 30),),
        ),
        backgroundColor: Color (0xFF101010),
      body: Form(
        key: formGlobalKey,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildEmailTextfield(),
            SizedBox(
              height: 25.0,
            ),
            _buildUsernameTextField(),
            SizedBox(
              height: 25.0,
            ),

            _buildPasswordTextfield(),
            SizedBox(
              height: 25.0,
            ),
            _buildPasswordConfirmTextField(),
            SizedBox(
              height: 25.0,
            ),
            _buildButton(context),
          ],
        ),
      )
    );
  }


  Widget _buildEmailTextfield() {
    return TextFormField(
        controller: _emailController,
        validator: (value)=> EmailFieldValidator.validate(value!),
        style: TextStyle(color: Colors.lightGreen),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: 'Email', filled: true,
            icon: Icon(Icons.email, color: Colors.lightGreen,),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: new TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.w400 , fontFamily: 'Calibri'))
    );
  }

  Widget _buildPasswordTextfield() {
    return TextFormField(
      controller: _passwordController,
      validator: (value)=> PasswordFieldValidator.validate(value!),
      style: TextStyle(color: Colors.lightGreen),
      decoration: InputDecoration(labelText: 'Password', filled: true,
          icon: Icon(Icons.key, color: Colors.lightGreen),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
            )
          ),
          labelStyle: new TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.w400 , fontFamily: 'Calibri')
      ),
      obscureText: true,
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      controller: _passConfirmController,
      validator: (value)=> PassConfirmFieldValidator.validate(value!, _passwordController),
      style: TextStyle(color: Colors.lightGreen),
      decoration: InputDecoration(labelText: 'Confirm Password', filled: true,
          icon: Icon(Icons.key, color: Colors.lightGreen,),
          enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: new TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.w400 , fontFamily: 'Calibri')
      ),
      obscureText: true,
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      controller: _usernameController,
      validator: (value)=> UsernameFieldValidator.validate(value!),
      style: TextStyle(color: Colors.lightGreen),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(labelText: 'Username', filled: true,
          icon: Icon(Icons.person, color: Colors.lightGreen),
          enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0
              )
          ),
          labelStyle: new TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.w400 , fontFamily: 'Calibri')
      ),
    );
  }


  Widget _buildButton(BuildContext context) {
    return MaterialButton(
        color: Colors.lightGreen,
        textColor: Colors.white,
        child: Text('SIGN UP'),
        onPressed: () => {
          if(formGlobalKey.currentState!.validate()){
            _authService.signUp(_emailController.text, _passwordController.text, _usernameController.text, context)
          }
        },
    );
  }


}