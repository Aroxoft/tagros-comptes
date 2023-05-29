import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Exception? error;
  final String message;

  ErrorPage({super.key, this.error})
      : message = error != null ? error.toString() : 'Error';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(message)));
  }
}
