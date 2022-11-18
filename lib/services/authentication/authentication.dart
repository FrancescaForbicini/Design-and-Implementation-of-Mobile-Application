import 'package:flutter/material.dart';

class AutenticationWidget extends StatelessWidget{
  const AutenticationWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
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
    ),
    );
  }
}