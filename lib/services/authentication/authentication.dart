import 'package:dima_project/services/authentication/sign_in/signin.dart';
import 'package:dima_project/services/authentication/sign_up/signup.dart';
import 'package:flutter/material.dart';

class AutenticationScreen extends StatelessWidget{
  const AutenticationScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color (0xFF101010),
      body:

    //   <--- image

    Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              Image.asset('images/logo.png',width: 400,height: 400, alignment: Alignment.bottomCenter),
              Container(
                margin: EdgeInsets.all(30),
                child: TextButton(
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 40.0,fontFamily: 'Hind', color: Colors.lightGreen),
                  ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                ),
              ),
              Container(
                margin: EdgeInsets.all(30),
                child: TextButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 40.0,fontFamily: 'Hind', color: Colors.lightGreen),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                ),
              ),

        ],
      ),
    ),
    );
  }
}