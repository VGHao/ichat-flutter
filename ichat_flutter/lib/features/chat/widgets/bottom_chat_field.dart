// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ichat_flutter/common/utils/utils.dart';

import 'package:ichat_flutter/features/chat/controller/chat_controller.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  void sendTextMessage() async {
    if (_messageController.text.isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
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

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onTap: () {
                  setState(() {
                    isShowEmojiContainer = false;
                    showKeyboard();
                  });
                },
                focusNode: focusNode,
                controller: _messageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 50,
                    child: IconButton(
                      onPressed: toggleEmojiKeyboardContainer,
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  hintText: 'Type a message...',
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
              child: GestureDetector(
                onTap: sendTextMessage,
                child: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20,
                  child: Icon(
                    Icons.send,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 250,
                child: EmojiPicker(
                  textEditingController: _messageController,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
