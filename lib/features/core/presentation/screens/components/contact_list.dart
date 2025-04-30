import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  final List<Map<String, String>> contacts;

  const ContactList({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: contacts
          .map((contact) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(contact['name'] ?? ''),
                subtitle: Text(contact['phone'] ?? ''),
              ))
          .toList(),
    );
  }
}
