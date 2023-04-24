import 'package:flutter/material.dart';

showErrorDialog(context, String message) {
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        content: Text("$message", style: TextStyle(fontFamily: 'SemiBold', color: Color(0xff461257)),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            child: Text("Ok", style: TextStyle(color: Color(0xff461257)),)
          )
        ],
      );
    }
  );
}