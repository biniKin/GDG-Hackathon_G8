import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_campus/features/core/data/models/register_data.dart';
import 'package:safe_campus/features/core/data/models/user_model.dart';
import 'package:safe_campus/features/core/data/repositories/auth_repo.dart';
import 'package:safe_campus/features/core/presentation/providers/auth/auth_bloc.dart';
import 'package:safe_campus/features/core/presentation/providers/auth/auth_event.dart';
import 'package:safe_campus/features/core/presentation/providers/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _studentIdController = TextEditingController();

  final _passwordController = TextEditingController();

  //AuthRepo authRepo = AuthRepo();

  //register
  //Future<UserModel> register() async {
  //  try {
  //    RegisterData data = RegisterData(
  //      fullname: _fullNameController.text.trim(),
  //      email: _emailController.text.trim(),
  //      password: _passwordController.text.trim(),
  //      studentId: _studentIdController.text.trim(),
  //    );
  //    return await authRepo.registerUser(data);
  //  } catch (e) {
  //    throw Exception('Error on registeration $e');
  //  }
  //}

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final studentId = _studentIdController.text.trim();
      final password = _passwordController.text.trim();

      // Dispatch RegisterRequested event
      BlocProvider.of<AuthBloc>(
        context,
      ).add(RegisterRequested(fullName, email, studentId, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            Fluttertoast.showToast(msg: "Processing Data");
          } else if(state is Authenticated){
            Navigator.pushReplacementNamed(context, '/home');
            Fluttertoast.showToast(msg: "Registration Successful!");
          } else if (state is AuthError) {
            Fluttertoast.showToast(msg: "${state.error}");
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 192, 186, 222),
                Color.fromARGB(255, 223, 222, 236),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome to SafeCampus!',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _studentIdController,
                        decoration: const InputDecoration(
                          labelText: 'Student ID',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your student ID";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Color(0xFF65558F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have account?'),
                          TextButton(
                            onPressed:
                                () => Navigator.pushNamed(context, '/signin'),
                            child: const Text('Sign In'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
