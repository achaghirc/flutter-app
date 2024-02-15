import 'package:flutter/material.dart';



class CustomSnackBarWidget {

  late String message;
  late String status;

  CustomSnackBarWidget({
    required this.message,
    required this.status
  });

  CustomSnackBarWidget.openSnackBar(BuildContext context, String status, String message) {  
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Align(
        alignment: Alignment.topCenter,
        child: Text(message)
      ),
      backgroundColor: status == 'Error' ? Colors.red : Colors.greenAccent,
      duration: const Duration(milliseconds: 3000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}