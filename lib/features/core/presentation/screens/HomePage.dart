import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/core/presentation/bloc/NavigationCubit.dart';
import 'package:safe_campus/features/core/presentation/screens/components/report_incident_bottom_sheet.dart';
import 'package:safe_campus/features/core/presentation/screens/components/share_route_bottom_sheet.dart';
import 'package:safe_campus/features/core/presentation/screens/components/contact_form_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showContacts = false;
  bool showActivities = false;

  List<Map<String, String>> contacts = [];
  List<Map<String, String>> recentActivities = [];

  void openReportIncidentSheet() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ReportIncidentBottomSheet(
        onSubmit: (name, description) {
          return {'name': name, 'description': description};
        },
      ),
    );

    if (result != null) {
      setState(() {
        recentActivities.add(result);
      });
    }
  }

  void openShareRouteSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ShareRouteBottomSheet(),
    );
  }

  void openManageContactsSheet() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ContactFormBottomSheet(
        onSave: (name, phone) {
          Navigator.of(context).pop({'name': name, 'phone': phone});
        },
      ),
    );

    if (result != null) {
      setState(() {
        contacts.add(result);
      });
    }
  }

  void openSOSDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Confirm your request",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        content: SizedBox(
          height: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/alert1.png'),
              Text(
                "The alert will be sent to security and trusted contacts with your location and info. Confirm before sending!",
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Trigger actual alert logic
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Send Alert",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          extendBody: true,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: openSOSDialog,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Text("SOS"),
          ),
          body: Stack(
            children: [
              // Quarter-circle background
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 220,
                  height: 125,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8DEF8),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(358),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SafeCampus",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/happy_ppl.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      ElevatedButton(
                        onPressed: openShareRouteSheet,
                        child: const Text("Share My Route"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: openReportIncidentSheet,
                        child: const Text("Report Incidents"),
                      ),
                      const SizedBox(height: 24),

                      // Trusted Contacts
                      GestureDetector(
                        onTap: () => setState(() => showContacts = !showContacts),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Trusted Contacts"),
                              Icon(showContacts ? Icons.expand_less : Icons.expand_more),
                            ],
                          ),
                        ),
                      ),
                      if (showContacts) ...[
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: openManageContactsSheet,
                          child: const Text("Manage Contacts"),
                        ),
                        const SizedBox(height: 10),
                        ...contacts.map((c) => ListTile(
                              title: Text(c['name'] ?? ''),
                              subtitle: Text(c['phone'] ?? ''),
                            )),
                      ],

                      const SizedBox(height: 24),

                      // Recent Activities
                      GestureDetector(
                        onTap: () => setState(() => showActivities = !showActivities),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Recent Activities"),
                              Icon(showActivities ? Icons.expand_less : Icons.expand_more),
                            ],
                          ),
                        ),
                      ),
                      if (showActivities) ...[
                        const SizedBox(height: 10),
                        ...recentActivities.map((act) => ListTile(
                              title: Text(act['name'] ?? ''),
                              subtitle: Text(act['description'] ?? ''),
                            )),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
