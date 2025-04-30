import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final List pages = [
     HomePage(),
    const Mappage(),
    const Alertpage(),
    const Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          extendBody: true,
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
                    color:  Color(0xFFE8DEF8), // 78% opacity of B7AFE7
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(358),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 60), // Space under status bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "SafeCampus",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/happy_ppl.png', // Replace with your image path
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: pages[selectedIndex]),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Text("SOS"),
          ),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 5,
            color: const Color(0xFFE8DEF8),
            shape: const CircularNotchedRectangle(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 65,
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
                    const SizedBox(width: 40),
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
  final color = isSelected ? Colors.deepPurpleAccent : Colors.grey;

  return GestureDetector(
    onTap: () => context.read<NavigationCubit>().updateIndex(index),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    ),
  );
}
