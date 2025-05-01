import 'package:flutter/material.dart';

class ContactFormBottomSheet extends StatefulWidget {
  final Function(String, String) onSave;

  const ContactFormBottomSheet({super.key, required this.onSave});

  @override
  State<ContactFormBottomSheet> createState() => _ContactFormBottomSheetState();
}

class _ContactFormBottomSheetState extends State<ContactFormBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Contact", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: "Phone"),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSave(
                nameController.text.trim(),
                phoneController.text.trim(),
              );
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}
