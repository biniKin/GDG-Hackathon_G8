import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetyMap extends StatefulWidget {
  final VoidCallback onReportIncident;
  final VoidCallback onShareRoute;
  final VoidCallback onUserCurrentLocation;

  const SafetyMap({
    super.key,
    required this.onReportIncident,
    required this.onShareRoute,
    required this.onUserCurrentLocation,
  });

  @override
  State<SafetyMap> createState() => SafetyMapState();
}

class SafetyMapState extends State<SafetyMap> with AutomaticKeepAliveClientMixin {
  final MapController _mapController = MapController();
  final Location _location = Location();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _incidentDescriptionController = TextEditingController();
  bool isLoading = true;
  LatLng? _currentLocation;
  LatLng? _destination;
  List<LatLng> _route = [];
  List<Map<String, dynamic>> _incidentReports = [
    {'location': LatLng(37.7749, -122.4194), 'description': 'Suspicious activity'},
    {'location': LatLng(37.7849, -122.4294), 'description': 'Low visibility area'},
  ];
  String? _shareToken;
  final uuid = Uuid();
  XFile? _selectedMedia;
  bool _isActive = false;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _checkForNearbyIncidents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newIsActive = DefaultTabController.of(context).index == 0; // SafetyMap is at index 0
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
    if (!await _checkTheRequestPermission()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (_isActive) {
      _startLocationUpdates();
    }
  }

  void _startLocationUpdates() {
    if (_locationSubscription != null) return; // Already listening
    _locationSubscription = _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
          isLoading = false;
        });
        _checkForNearbyIncidents();
      }
    });
  }

  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void _toggleTracking() {
    setState(() {
      _isActive = !_isActive;
    });
    if (_isActive) {
      _startLocationUpdates();
    } else {
      _stopLocationUpdates();
    }
  }

  Future<void> fetchCoordinatesPoint(String location) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?q=$location&format=json&addressdetails=1&limit=1");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        setState(() {
          _destination = LatLng(lat, lon);
        });
        await fetchRoute();
      } else {
        errorMessage("Location not found");
      }
    } else {
      errorMessage("Error fetching coordinates");
    }
  }

  Future<void> fetchRoute() async {
    if (_currentLocation == null || _destination == null) {
      errorMessage("Current location or destination not available");
      return;
    }
    final url = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/${_currentLocation!.longitude},${_currentLocation!.latitude};${_destination!.longitude},${_destination!.latitude}?overview=full&geometries=polyline");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final geometry = data['routes'][0]['geometry'];
      _decodePolyline(geometry);
    } else {
      errorMessage("Error fetching route");
    }
  }

  void _decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(encodedPolyline);
    setState(() {
      _route = decodedPoints.map((point) => LatLng(point.latitude, point.longitude)).toList();
    });
  }

  Future<bool> _checkTheRequestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  void userCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    } else {
      errorMessage("Unable to get current location");
    }
  }

  void errorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void shareRoute() {
    if (_route.isNotEmpty && _currentLocation != null) {
      setState(() {
        _shareToken = uuid.v4();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Share Route"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Share this token with a friend to track your route:"),
              SizedBox(height: 8),
              SelectableText(_shareToken ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Your current location and route will be shared in real-time."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      );
    } else {
      errorMessage("No route to share");
    }
  }

  void reportIncident() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Report Incident", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                controller: _incidentDescriptionController,
                decoration: InputDecoration(
                  labelText: "Describe the incident",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final pickedFile = await picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        setState(() {
                          _selectedMedia = pickedFile;
                        });
                      }
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text("Photo"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final pickedFile = await picker.pickVideo(source: ImageSource.camera);
                      if (pickedFile != null) {
                        setState(() {
                          _selectedMedia = pickedFile;
                        });
                      }
                    },
                    icon: Icon(Icons.videocam),
                    label: Text("Video"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (_selectedMedia != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Media selected: ${_selectedMedia!.name}",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  if (_incidentDescriptionController.text.isNotEmpty && _currentLocation != null) {
                    setState(() {
                      _incidentReports.add({
                        'location': _currentLocation,
                        'description': _incidentDescriptionController.text,
                        'media': _selectedMedia?.path,
                      });
                    });
                    _incidentDescriptionController.clear();
                    setState(() {
                      _selectedMedia = null;
                    });
                    Navigator.pop(context);
                    errorMessage("Incident reported anonymously");
                    _checkForNearbyIncidents();
                  } else {
                    errorMessage("Please provide a description and ensure location is available");
                  }
                },
                child: Text("Submit Report"),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _checkForNearbyIncidents() {
    if (_currentLocation == null) return;
    const double alertRadius = 0.5; // 500 meters
    final distance = Distance();
    for (var incident in _incidentReports) {
      final incidentLocation = incident['location'] as LatLng?;
      if (incidentLocation == null) continue;
      final distanceKm = distance(_currentLocation!, incidentLocation) / 1000;
      if (distanceKm <= alertRadius) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Warning: ${incident['description']} nearby!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _stopLocationUpdates();
    _locationController.dispose();
    _incidentDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : _currentLocation == null
            ? const Center(child: Text('Unable to get current location'))
            : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation!,
                      initialZoom: 15,
                      minZoom: 0,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.example.safecampus',
                      ),
                      CurrentLocationLayer(
                        style: LocationMarkerStyle(
                          marker: DefaultLocationMarker(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          markerSize: Size(40, 40),
                          markerDirection: MarkerDirection.heading,
                        ),
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _route,
                            strokeWidth: 4.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: _incidentReports
                            .map((incident) => Marker(
                                  point: incident['location'] as LatLng,
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: "Enter destination",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => fetchCoordinatesPoint(_locationController.text),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: FloatingActionButton.extended(
                      onPressed: _toggleTracking,
                      backgroundColor: _isActive ? Colors.red : Colors.green,
                      label: Text(
                        _isActive ? 'Stop Tracking' : 'Start Tracking',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                      ),
                      icon: Icon(
                        _isActive ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
  }
}