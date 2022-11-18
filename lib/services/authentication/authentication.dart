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
              Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'ciao',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 110
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}