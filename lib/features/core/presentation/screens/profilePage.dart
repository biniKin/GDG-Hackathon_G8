import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/core/presentation/screens/editProfile.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  bool isPressedAlert = false;
  bool isPressedVibration = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.,
          children: [
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 239, 241),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF65558F),
                        shape: BoxShape.circle

                      ),
                      padding: EdgeInsets.all(0.7),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                      
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      ),
                    ),
                  ),
                  //SizedBox(width: 3,),
                  SizedBox(
                    width: 200,
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Abel Mesfin",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ETS 0304/16',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),
            Divider(),
            SizedBox(height: 7),
            SizedBox(
              height: 95,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Account settings",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7C7C7C),
                      ),
                    ),
                  ),
                  displayContainer(
                    context,
                    onPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Editprofile()),
                      );
                    },
                    firsticon: Icons.person,
                    label: 'Edit Profile',
                    lasticon: Icons.arrow_forward,
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),
            Divider(),
            SizedBox(height: 7),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Manage Notifications",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7C7C7C),
                      ),
                    ),
                  ),
                  displayContainer2(
                    context,
                    onPress: () {
                      setState(() {
                        isPressedAlert = !isPressedAlert;
                      });
                    },
                    label: "Sound alerts",
                    lasticon:
                        isPressedAlert
                            ? Icons.toggle_on_outlined
                            : Icons.toggle_off_outlined,
                  ),
                  displayContainer2(
                    context,
                    onPress: () {
                      setState(() {
                        isPressedVibration = !isPressedVibration;
                      });
                    },
                    label: "Vibrations",
                    lasticon:
                        isPressedVibration
                            ? Icons.toggle_on_outlined
                            : Icons.toggle_off_outlined,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 275,
              height: 50,

              decoration: BoxDecoration(
                color: Color.fromARGB(255, 239, 239, 241),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 0.5, color: Colors.red),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 239, 239, 241),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'sign out',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.logout, color: Colors.black),
                  ],
                ),
              ),
            ),
            //SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget displayContainer(
  BuildContext context, {
  required IconData? firsticon,
  required String label,
  required IconData lasticon,
  required VoidCallback onPress,
}) {
  return Container(
    width: double.infinity,
    height: 60,
    padding: EdgeInsets.only(left: 15, right: 15),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 240, 239, 241),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(firsticon, size: 30),
            SizedBox(width: 20),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        IconButton(onPressed: onPress, icon: Icon(lasticon, size: 30)),
      ],
    ),
  );
}

Widget displayContainer2(
  BuildContext context, {

  required String label,
  required VoidCallback onPress,
  required IconData lasticon,
}) {
  return Container(
    width: double.infinity,
    height: 60,
    padding: EdgeInsets.only(left: 15, right: 15),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 240, 239, 241),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        IconButton(onPressed: onPress, icon: Icon(lasticon, size: 40)),
      ],
    ),
  );
}
