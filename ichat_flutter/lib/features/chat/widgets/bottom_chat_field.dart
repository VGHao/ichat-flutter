// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ichat_flutter/common/utils/utils.dart';

import 'package:ichat_flutter/features/chat/controller/chat_controller.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({
    required this.receiverUserId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (_messageController.text.isNotEmpty) {
      ref.watch(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );
    } else {
      showSnackBar(context: context, content: 'You didn\'t write anything');
    }
    setState(() {
      _messageController.text = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: SizedBox(
                width: 50,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: Colors.grey,
                  ),
                ),
              ),
              // suffixIcon: SizedBox(
              //   width: 100,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       IconButton(
              //         onPressed: () {},
              //         icon: Icon(
              //           Icons.camera_alt,
              //           color: Colors.grey,
              //         ),
              //       ),
              //       SizedBox(width: 5),
              //       IconButton(
              //         onPressed: () {},
              //         icon: Icon(
              //           Icons.attach_file,
              //           color: Colors.grey,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 5.0,
          ),
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 20,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                Icons.send,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
