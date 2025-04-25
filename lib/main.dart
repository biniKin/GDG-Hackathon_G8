import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/core/presentation/bloc/NavigationCubit.dart';
import 'package:safe_campus/features/core/presentation/screens/home.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => NavigationCubit(),
    child: Container(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
