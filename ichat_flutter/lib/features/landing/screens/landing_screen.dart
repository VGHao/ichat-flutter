import 'package:flutter/material.dart';
import 'package:ichat_flutter/colors.dart';
import 'package:ichat_flutter/common/widgets/custom_button.dart';
import 'package:ichat_flutter/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  'Welcome to iChat',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: size.height / 9),
                Image.asset(
                  'assets/bg.png',
                  height: 340,
                  width: 340,
                  color: tabColor,
                ),
                SizedBox(height: size.height / 9),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Read our Privacy Policy. \n Tap "Agree and continue" to accept the Term of Service.',
                    style: TextStyle(
                      color: greyColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.75,
                  child: CustomButton(
                    text: 'AGREE AND CONTINUE',
                    onPressed: () => navigateToLoginScreen(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
