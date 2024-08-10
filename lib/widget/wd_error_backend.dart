import 'package:flutter/material.dart';

class ExceptionWidget {
  Exception? e;
  BuildContext context;
  ExceptionWidget({
    required this.e,
    required this.context,
  });
  void mostrarException() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Text("Exception: ${e.toString()}"),
          ),
        );
      },
    );
  }
}
