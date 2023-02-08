// ignore_for_file: prefer_const_constructors

import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  const CustomButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.isLoading,});

  @override
  Widget build(BuildContext context) {
    return Container(
      // login btn
      child: Container(
        width: 300,
        height: 48,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: GlobalVariable.secondaryColor,
                offset: Offset(0, 1),
                blurRadius: 10.0),
            BoxShadow(
                color: GlobalVariable.secondaryColor,
                offset: Offset(1, 0),
                blurRadius: 10.0)
          ],
          borderRadius: BorderRadius.circular(10.0),
          color: GlobalVariable.secondaryColor,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: GlobalVariable.secondaryColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              onTap;
            },
            splashColor: Colors.white,
            splashFactory: InkSplash.splashFactory,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          text.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
