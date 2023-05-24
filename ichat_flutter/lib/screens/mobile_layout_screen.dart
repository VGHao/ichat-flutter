import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ichat_flutter/features/auth/controller/auth_controller.dart';
import 'package:ichat_flutter/features/select_contacts/screens/select_contacts_screen.dart';
import '../colors.dart';
import '../features/chat/screens/mobile_chat_screen.dart';
import '../features/chat/widgets/contacts_list.dart';
import '../models/user_model.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver {
  UserModel? currentUserData;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    requestPermission();
    initInfo();
  }

  void requestPermission() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        final String? payload = notificationResponse.payload;
        if (payload != null && payload.isNotEmpty) {
          // debugPrint('notification payload: $payload \n');
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'uid': payload,
            },
          );
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) async {
        print("................onMessage...............");
        print(
            "onMessage: ${message.notification?.title} / ${message.notification?.body}");

        BigTextStyleInformation bigTextStyleInformation =
            BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true,
        );
        AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          "ichat",
          "ihat",
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.high,
          playSound: true,
        );
        NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );
        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: message.data['uid'],
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  void getCurrentUserData() async {
    await ref.read(authControllerProvider).getUserData().then((value) {
      currentUserData = value;
    });
  }

  void signOut() {
    ref.read(authControllerProvider).signOut(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUserData();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'iChat',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(currentUserData!.profilePic),
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: 80, maxWidth: 200),
                        child: Text(
                          currentUserData!.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 2.0),
                  onTap: signOut,
                  child: const Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.red),
                      SizedBox(width: 5),
                      Text('Sign out'),
                    ],
                  ),
                ),
              ],
              position: PopupMenuPosition.under,
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
            // IconButton(
            //   icon: const Icon(Icons.more_vert, color: Colors.grey),
            //   onPressed: () {},
            // ),
          ],
        ),
        body: const Column(
          children: [
            Expanded(
              child: ContactsList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactsScreen.routeName);
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
