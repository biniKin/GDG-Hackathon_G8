import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/core/presentation/screens/HomePage.dart';
import 'package:safe_campus/features/core/presentation/screens/safetyMap.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _safetyMapKey = GlobalKey<SafetyMapState>();

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
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          bottom: TabBar(
            labelStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: "Live Tracker"),
              Tab(text: "Safety Map"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.report),
              onPressed: () {
                DefaultTabController.of(context).index = 1; // Switch to SafetyMap tab
                _safetyMapKey.currentState?.reportIncident();
              },
              tooltip: "Report Incident",
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                DefaultTabController.of(context).index = 1; // Switch to SafetyMap tab
                _safetyMapKey.currentState?.shareRoute();
              },
              tooltip: "Share Route",
            ),
          ],
        ),
        body: TabBarView(
          children: [
            const Center(child: Text('Live Tracker (Coming Soon)')),
            SafetyMap(
              key: _safetyMapKey,
              onReportIncident: () => _safetyMapKey.currentState?.reportIncident(),
              onShareRoute: () => _safetyMapKey.currentState?.shareRoute(),
              onUserCurrentLocation: () => _safetyMapKey.currentState?.userCurrentLocation(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            DefaultTabController.of(context).index = 1; // Switch to SafetyMap tab
            _safetyMapKey.currentState?.userCurrentLocation();
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.my_location, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}