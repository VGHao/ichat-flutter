import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ichat_flutter/common/widgets/error.dart';
import 'package:ichat_flutter/common/widgets/loader.dart';
import 'package:ichat_flutter/features/select_contacts/controller/select_contacts_controller.dart';

import '../../../colors.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({super.key});

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactProvider).when(
            data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () => selectContact(ref, contact, context),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ListTile(
                          leading: contact.photo == null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: MemoryImage(contact.photo!),
                                  radius: 30,
                                ),
                          title: Text(
                            contact.displayName,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: dividerColor,
                      thickness: 1,
                      height: 0.0,
                    ),
                  ],
                );
              },
            ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => Loader(),
          ),
    );
  }
}
