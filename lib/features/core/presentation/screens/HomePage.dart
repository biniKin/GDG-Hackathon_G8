import 'package:flutter/material.dart';
import 'package:safe_campus/features/core/presentation/screens/components/contact_form_bottom_sheet.dart';
import 'package:safe_campus/features/core/presentation/screens/components/contact_list.dart';
import 'package:safe_campus/features/core/presentation/screens/components/report_incident_bottom_sheet.dart';
import 'package:safe_campus/features/core/presentation/screens/components/recent_activity_expanded.dart';
import 'package:safe_campus/features/core/presentation/screens/components/share_route_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> recentActivities = [];
  List<Map<String, String>> trustedContacts = [];

  bool showAllContacts = false;
  bool showAllActivities = false;

  void _showReportIncidentBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReportIncidentBottomSheet(
        onSubmit: (title, description) {
          Navigator.of(context).pop({
            'title': title,
            'description': description,
          });
        },
      ),
    );

    if (result != null) {
      setState(() {
        recentActivities.add(result);
      });
    }
  }

  void _showShareRouteBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ShareRouteBottomSheet(),
    );
  }

  void _showContactFormBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ContactFormBottomSheet(
        onSave: (name, phone) {
          Navigator.of(context).pop({
            'name': name,
            'phone': phone,
          });
        },
      ),
    );

    if (result != null) {
      setState(() {
        trustedContacts.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        children: [
          // Share and Report buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF1EBFF), Color(0xFFEDEBFF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(2, 4),
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: _showShareRouteBottomSheet,
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.share, size: 40),
                        SizedBox(height: 8),
                        Text("Share my routes", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF1EBFF), Color(0xFFEDEBFF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(2, 4),
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: _showReportIncidentBottomSheet,
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.assignment, size: 40),
                        SizedBox(height: 8),
                        Text("Report incidents", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Trusted Contacts Section
          GestureDetector(
            onTap: () => setState(() => showAllContacts = !showAllContacts),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Trusted contacts",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text("people who can see your location during emergencies",
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 20),

                  if (showAllContacts)
                    ContactList(contacts: trustedContacts),

                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: screenWidth * 0.6,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF1EBFF), Color(0xFFEDEBFF)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(2, 4),
                          )
                        ],
                      ),
                      child: TextButton.icon(
                        onPressed: _showContactFormBottomSheet,
                        icon: const Icon(Icons.manage_accounts, color: Colors.black),
                        label: const Text("Manage contacts",
                            style: TextStyle(color: Colors.black)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Recent Activities Section
          GestureDetector(
            onTap: () => setState(() => showAllActivities = !showAllActivities),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Recent Activities",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text("your recent safety actions",
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 20),

                  if (showAllActivities)
                    RecentActivityExpanded(activities: recentActivities)
                  else if (recentActivities.isEmpty)
                    Center(
                      child: Column(
                        children: const [
                          Icon(Icons.history, size: 36, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("No data has found",
                              style: TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
