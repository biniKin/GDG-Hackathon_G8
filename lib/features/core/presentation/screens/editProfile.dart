import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  File? _image;

  final picker = ImagePicker();

  Future<void> getImage() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      // Request permission if it's not granted
      var permissionStatus = await Permission.photos.request();
      if (!permissionStatus.isGranted) {
        // Handle the case when the user denies permission
        Fluttertoast.showToast(
          msg: "Permission denied",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          fontSize: 16.0,
        );
        //openAppSettings();
      }
    }

    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        setState(() {});
      } else {
        return;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error occured",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF9F5DC9),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(0.5),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child:
                          _image == null
                              ? Icon(
                                Icons.person_outline,
                                size: 160,
                                color: Color(0xFF716B6B),
                              )
                              : null,
                    ),
                  ),
                  Positioned(
                    top: 165,
                    left: 150,
                    right: 10,
                    bottom: -5,
                    child: InkWell(
                      onTap: getImage,
                      splashColor: const Color.fromARGB(255, 186, 143, 143),
                      highlightColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(
                            color: const Color.fromRGBO(117, 117, 117, 1),
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.edit, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
               
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Student ID',
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {},
              
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Color(0xFF65558F),
              ),
              child: Text('Save', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );

    //save button
  }
}
