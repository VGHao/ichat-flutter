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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome to iChat',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/bg.png',
                // height: size.height * 0.5,
                width: size.width * 0.8,
                color: tabColor,
              ),
              const Spacer(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Read our Privacy Policy. \n Tap "Agree and continue" to accept the Term of Service.',
                      style: TextStyle(
                        color: greyColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: size.width * 0.75,
                      child: CustomButton(
                        text: 'AGREE AND CONTINUE',
                        onPressed: () => navigateToLoginScreen(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
