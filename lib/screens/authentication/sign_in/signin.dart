import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/spotifyAuth_screen.dart';
import 'package:flutter/material.dart';

import '../../../services/authentication_service.dart';
import '../sign_up/signup.dart';


class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color (0xFF101010),
      body: Flex(
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
          _buildButton(context),
        ],
      ),
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
        child: Text('SIGN IN'),
        onPressed: () => {
          _authService.signIn(_emailController.text, _passwordController.text),
          Navigator.pop(context),
          Navigator.push(context, MaterialPageRoute(builder: (context) => SpotifyScreen()),)
        }
    );
  }


}