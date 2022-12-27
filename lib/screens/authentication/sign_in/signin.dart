import 'package:auto_size_text/auto_size_text.dart';
import 'package:dima_project/screens/spotifyAuth_screen.dart';
import 'package:flutter/material.dart';

import '../../../services/authentication_service.dart';
import '../sign_up/signup.dart';


class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      backgroundColor: Color (0xFF101010),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.lightGreen,size: 30),
        onPressed: () => {
          Navigator.pop(context),
        },
      ),
      title: const AutoSizeText(
        'Sign In',
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
      backgroundColor: const Color (0xFF101010),
      body: Container(
        height: _height,
        width: _screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildEmailTextField(),
            SizedBox(
              height: _height * 0.05,
            ),

            _buildPasswordTextField(),
            SizedBox(
              height: _height * 0.05,
            ),
            _buildButton(context),
          ],
        ),
      ),
    );
  }


  Widget _buildEmailTextField() {
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

  Widget _buildPasswordTextField() {
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


  Widget _buildButton(BuildContext context) {
    Future<bool> done;
    return MaterialButton(
        color: Colors.lightGreen,
        textColor: Colors.white,
        child: const AutoSizeText('SIGN IN'),
        onPressed: () => {
          done = _authService.signIn(_emailController.text, _passwordController.text),
          done.then((value) => {
            if (value){
              Navigator.pop(context),
              Navigator.push(context, MaterialPageRoute(builder: (context) => SpotifyScreen()),)
            }
            else{
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Error"),
                      content: const Text("Invalid email or password"),
                      actions: [
                        MaterialButton(
                          child: const Text("Ok"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            },
                        )
                      ],
                    );
                  }
              )
            }
          }
          ),
        }
    );
  }


}