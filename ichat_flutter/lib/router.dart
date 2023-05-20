import 'package:flutter/material.dart';
import 'package:ichat_flutter/common/widgets/error.dart';
import 'package:ichat_flutter/features/auth/screens/login_screen.dart';
import 'package:ichat_flutter/features/auth/screens/otp_screen.dart';
import 'package:ichat_flutter/features/select_contacts/screens/select_contacts_screen.dart';

import 'features/auth/screens/user_information_screen.dart';
import 'screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => UserInformationScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) =>
            Scaffold(body: ErrorScreen(error: 'This page doesn\'t exist')),
      );
  }
}
