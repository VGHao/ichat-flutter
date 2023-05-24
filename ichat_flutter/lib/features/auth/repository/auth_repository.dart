import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ichat_flutter/common/repositories/common_firebase_storage_repository.dart';
import 'package:ichat_flutter/common/utils/utils.dart';
import 'package:ichat_flutter/features/auth/screens/login_screen.dart';
import 'package:ichat_flutter/features/auth/screens/user_information_screen.dart';
import 'package:ichat_flutter/models/user_model.dart';
import 'package:ichat_flutter/screens/mobile_layout_screen.dart';
import '../screens/otp_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await auth.signInWithCredential(credential).then(
                  (value) => Navigator.pushNamedAndRemoveUntil(context,
                      UserInformationScreen.routeName, (route) => false),
                );
          } on FirebaseAuthException catch (e) {
            showSnackBar(context: context, content: e.toString());
          }
        },
        verificationFailed: (e) {
          showSnackBar(context: context, content: e.toString());
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required String imageLink,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = imageLink;
      String? notifyToken;

      await FirebaseMessaging.instance.getToken().then((value) {
        notifyToken = value;
        // print('My token is $notifyToken');
      });

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      var user = UserModel(
        uid: uid,
        name: name,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        notifyToken: notifyToken,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap()).then(
            (value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MobileLayoutScreen(),
              ),
              (route) => false,
            ),
          );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void signOut({required BuildContext context}) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'notifyToken': ''});
    await auth.signOut().then((_) {
      // auth.currentUser!.delete();
      // Restart.restartApp();
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update(
      {
        'isOnline': isOnline,
      },
    );
  }
}
