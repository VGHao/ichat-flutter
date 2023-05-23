import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ichat_flutter/features/auth/controller/auth_controller.dart';
import 'package:ichat_flutter/features/select_contacts/screens/select_contacts_screen.dart';
import '../colors.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(currentUserData!.profilePic),
                        radius: 25,
                      ),
                      SizedBox(width: 10),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: 80, maxWidth: 200),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  onTap: signOut,
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.red),
                      SizedBox(width: 5),
                      Text('Sign out'),
                    ],
                  ),
                ),
              ],
              position: PopupMenuPosition.under,
              icon: Icon(Icons.more_vert, color: Colors.grey),
            ),
            // IconButton(
            //   icon: const Icon(Icons.more_vert, color: Colors.grey),
            //   onPressed: () {},
            // ),
          ],
        ),
        body: Column(
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
