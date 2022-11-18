import 'package:flutter/material.dart';

class AutenticationWidget extends StatelessWidget{
  const AutenticationWidget({super.key});


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
                      //TODO go to the home page
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
                    //TODO go to the registration page
                  },
                ),
              ),

        ],
      ),
    ),
    );
  }
}