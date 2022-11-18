import 'package:flutter/material.dart';

class AutenticationWidget extends StatelessWidget{
  const AutenticationWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color (0xFF232131),
      body:

    //   <--- image

    Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('images/logo.png',width: 300,height: 300, alignment: Alignment.bottomCenter),
          Expanded(

          child: Column(
          children: const [
            Spacer(
            flex: 2,
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "sign in",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 90,
                  fontFamily: 'Arial'
                ),
              ),
            ),
          ),
          Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "sign out",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 90,
              ),
            ),
          ),
        ),
          ],
        ),
      ),
            ],
    ),
    ),
    );
  }
}