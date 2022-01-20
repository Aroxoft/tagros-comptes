import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestNative extends StatefulWidget {
  static const String routeName = "/testNative";

  @override
  _TestNativeState createState() => _TestNativeState();
}

class _TestNativeState extends State<TestNative> {
  static const platform = MethodChannel('com.aroxoft.tagros.points/info');
  String _message = "No messages yet...";
  @override
  void initState() {
    super.initState();
    _getMessage().then((String? message) => setState(() {
          _message = message ?? "No messages!";
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_message),
    );
  }

  Future<String?> _getMessage() async {
    String? message;
    try {
      message = await platform.invokeMethod("getMessage");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return message;
  }
}
