import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/core/presentation/screens/liveTracker.dart';
import 'package:safe_campus/features/core/presentation/screens/safetyMap.dart';

class Mappage extends StatelessWidget {
  const Mappage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Map",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          bottom: TabBar(
             labelStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            tabs: [Tab(text: "Live Tracker"), Tab(text: "Safety Map")],
          ),
        ),
        body: Expanded(
          child: TabBarView(
            children: [
              Livetracker(),
              SafetyMap(),
            ]
          ),
        ),
      ),
    );
  }
}
