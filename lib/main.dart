import 'package:flutter/material.dart';
import 'package:sut_sos/login/auth.dart';
import 'package:sut_sos/login/auth_provider.dart';
import 'package:sut_sos/login/root_page.dart';
import 'login/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        home: RootPage(),
      ),
    );
  }
}
