import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class LiveTracker extends StatefulWidget {
  const LiveTracker({super.key});

  @override
  State<LiveTracker> createState() => _LiveTrackerState();
}

class _LiveTrackerState extends State<LiveTracker> with AutomaticKeepAliveClientMixin {
  final Location _location = Location();
  final uuid = Uuid();
  LocationData? _currentLocation;
  bool _isLoading = true;
  String? _shareToken;
  bool _isActive = false;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newIsActive = DefaultTabController.of(context).index == 1; // LiveTracker is now at index 1
    if (_isActive != newIsActive) {
      setState(() {
        _isActive = newIsActive;
      });
      if (_isActive) {
        _startLocationUpdates();
      } else {
        _stopLocationUpdates();
      }
    }
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check and request location service
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    // Check and request location permission
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    // Start listening if the tab is active
    if (_isActive) {
      _startLocationUpdates();
    }
  }

  void _startLocationUpdates() {
    if (_locationSubscription != null) return; // Already listening
    _locationSubscription = _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
        _isLoading = false;
      });
    });
  }

  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void _shareRoute() {
    if (_currentLocation == null) {
      _showSnackBar("Unable to share location: Current location not available");
      return;
    }

    setState(() {
      _shareToken = uuid.v4();
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Share Your Location"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Share this token with a friend to track your walk in real-time:"),
            const SizedBox(height: 8),
            SelectableText(
              _shareToken ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Your current location will be shared in real-time."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );

    // Simulate sending token to backend for real-time tracking
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _stopLocationUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Live Tracker",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_currentLocation == null)
            const Center(child: Text("Unable to get current location"))
          else ...[
            Text(
              "Current Location:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              "Latitude: ${_currentLocation!.latitude}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Longitude: ${_currentLocation!.longitude}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (_shareToken != null) ...[
              Text(
                "Shared Token: $_shareToken",
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _shareRoute,
              icon: const Icon(Icons.share),
              label: const Text("Share My Walk"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}