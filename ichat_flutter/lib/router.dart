import 'package:flutter/material.dart';
import 'package:ichat_flutter/common/widgets/error.dart';
import 'package:ichat_flutter/features/auth/screens/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    default:
      return MaterialPageRoute(
        builder: (context) =>
            Scaffold(body: ErrorScreen(error: 'This page doesn\'t exist')),
      );
  }
}
