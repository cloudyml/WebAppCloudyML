import 'dart:math';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final IconData icon;
  final double degrees;
  final VoidCallback onPressed;
  final String label;

  CircularButton(
      {required this.icon, required this.degrees, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          
         // width: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(label,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.purple),),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
    border: Border.all(
      color: Colors.purple,
      width: 2.0, // Adjust the width as needed
    ),
  ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Icon(icon,size:40),
          style: ElevatedButton.styleFrom(
            primary: Colors.purple,
            onPrimary: Colors.white,
            shape: CircleBorder(),
            padding: EdgeInsets.all(16.0),
          ),
        ),
      ],
    );
  }
}
