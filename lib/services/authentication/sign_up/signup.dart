import 'package:dima_project/services/authentication/authentication.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color (0xFF101010),

      body:
      Flex(
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
    );
  }


  Widget _buildEmailTextfield() {
    return TextFormField(
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AutenticationScreen()),
          ),
          // TODO da qualche parte bisognerà fare Navigator.pop
        });
  }


}