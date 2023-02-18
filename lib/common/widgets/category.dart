// ignore_for_file: prefer_const_constructors

import 'package:cafein_nodejs/constants/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCategory extends StatelessWidget {
  final String name;
  final String imgPath;
  final VoidCallback onTap;
  const CustomCategory({
    super.key,
    required this.name,
    required this.onTap,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        // slowbar tab
        padding: const EdgeInsets.all(5),
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: GlobalVariable.containerColor,
                    offset: Offset(0, 4),
                    blurRadius: 10.0),
                BoxShadow(
                    color: GlobalVariable.containerColor,
                    offset: Offset(4, 0),
                    blurRadius: 10.0)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              )),
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  color: GlobalVariable.secondaryColor,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
