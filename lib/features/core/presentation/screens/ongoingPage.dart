import 'package:flutter/material.dart';
import 'package:safe_campus/features/core/presentation/widgets/ongoingContainer.dart';

class Ongoingpage extends StatelessWidget {
  const Ongoingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        
        children: [
          Ongoingcontainer(image: null, name: "biniyam", detailes: "1 minute ago"),
          Ongoingcontainer(image: null, name: "biniyam", detailes: "10 minute ago"),
          Ongoingcontainer(image: null, name: "biniyam", detailes: "1 hour ago"),
        ],
      )
    );
  }
}