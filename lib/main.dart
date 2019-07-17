import 'package:flutter/material.dart';
import 'pages/loginpage/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const APP_TITLE = 'Wasabee';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(title: APP_TITLE),
      debugShowCheckedModeBanner: false,
    );
  }
}
