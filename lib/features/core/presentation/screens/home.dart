import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_campus/features/core/presentation/bloc/NavigationCubit.dart';
import 'package:safe_campus/features/core/presentation/screens/HomePage.dart';
import 'package:safe_campus/features/core/presentation/screens/alertPage.dart';
import 'package:safe_campus/features/core/presentation/screens/mapPage.dart';
import 'package:safe_campus/features/core/presentation/screens/profilePage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int index = 0;

  final List pages = [HomePage(), Mappage(), Alertpage(), Profilepage()];

  void openDialogeBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Confirm your request",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            //content
            content: SizedBox(
              height: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //image
                  Image(image: AssetImage('assets/images/alert1.png')),
                  //text
                  Text(
                    "The alert will be send to security persons and trusted contacts with your location and personal information. Make sure you made the right request before sending alert!",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
            ),
            //action
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancle"),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))
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
          //appBar: AppBar(title: Text("SafeCampus"), automaticallyImplyLeading: false,),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: openDialogeBox,
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
            child: Text("SOS"),
          ),
          body: pages[selectedIndex],
          bottomNavigationBar: BottomAppBar(
            notchMargin: 5,
            color: Color.fromARGB(255, 223, 222, 236),
            height: 70,
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(
                  context,
                  icon: Icons.home,
                  label: "Home",
                  index: 0,
                  selected: selectedIndex,
                ),
                navItem(
                  context,
                  icon: Icons.map,
                  label: "Map",
                  index: 1,
                  selected: selectedIndex,
                ),
                SizedBox(width: 40),
                navItem(
                  context,
                  icon: Icons.notifications,
                  label: "Alerts",
                  index: 2,
                  selected: selectedIndex,
                ),
                navItem(
                  context,
                  icon: Icons.person,
                  label: "Profile",
                  index: 3,
                  selected: selectedIndex,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget navItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  required int index,
  required int selected,
}) {
  final isSelected = selected == index;
  final color = isSelected ? Color(0xFF65558F) : const Color.fromARGB(255, 124, 124, 124);

  return InkWell(
    onTap: () => context.read<NavigationCubit>().updateIndex(index),

    child: Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: color),
          SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    ),
  );
}
