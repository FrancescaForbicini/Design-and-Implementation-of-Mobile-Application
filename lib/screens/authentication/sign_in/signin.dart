import 'package:auto_size_text/auto_size_text.dart';
import 'package:dima_project/screens/spotifyAuth_screen.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
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
      title: AutoSizeText(
        S.of(context).SigninTitle,
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
            _buildEmailTextField(context),
            SizedBox(
              height: _height * 0.05,
            ),

            _buildPasswordTextField(context),
            SizedBox(
              height: _height * 0.05,
            ),
            _buildButton(context),
          ],
        ),
      ),
    );
  }


  Widget _buildEmailTextField(BuildContext context) {
    return TextFormField(
        controller: _emailController,
        validator: (value)=> EmailFieldValidator.validate(value!),
        style: const TextStyle(color: Colors.lightGreen),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: S.of(context).SigninEmail,
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

  Widget _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      validator: (value)=> PasswordFieldValidator.validate(value!),
      style: const TextStyle(color: Colors.lightGreen),
      decoration: InputDecoration(
          labelText: S.of(context).SigninPwd,
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


  Widget _buildButton(BuildContext context) {
    Future<bool> done;
    return MaterialButton(
        color: Colors.lightGreen,
        textColor: Colors.white,
        child: AutoSizeText(S.of(context).SigninButton),
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
                      title: Text(S.of(context).SigninErr),
                      content: Text(S.of(context).SigninErrText),
                      actions: [
                        MaterialButton(
                          child: Text(S.of(context).SigninErrButton),
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