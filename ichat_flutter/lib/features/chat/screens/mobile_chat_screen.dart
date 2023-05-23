import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ichat_flutter/common/widgets/loader.dart';
import 'package:ichat_flutter/features/auth/controller/auth_controller.dart';
import 'package:ichat_flutter/models/user_model.dart';
import '../../../colors.dart';
import '../widgets/chat_list.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loader();
              }
              print(snapshot.data!.uid + " " + snapshot.data!.name);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!.profilePic),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.0),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: snapshot.data!.isOnline
                                  ? Colors.green
                                  : Colors.grey,
                              radius: 5,
                            ),
                            SizedBox(width: 10),
                            Text(
                              snapshot.data!.isOnline ? 'online' : 'offline',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: snapshot.data!.isOnline
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(receiverUserId: uid),
          ),
          BottomChatField(receiverUserId: uid),
        ],
      ),
    );
  }
}
