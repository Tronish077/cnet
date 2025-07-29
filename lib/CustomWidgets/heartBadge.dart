import 'package:flutter/material.dart';

Widget favBadge(text){
  return Stack(
    children: [
      IconButton(onPressed: (){},
          icon: Icon(Icons.bookmark_add_outlined)),
      Positioned(
        top:7,
        left: 5,
        child:
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16)
          ),
          child:
          Center(
            child: Text(
                "$text",
              style: TextStyle(
                  fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
        ),
      )
    ],
  );
}