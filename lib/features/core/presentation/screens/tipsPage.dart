import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Tipspage extends StatelessWidget {
  const Tipspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          
          children: [
            //title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Usefull security tips",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text("1. Lock your doors at all times, even if you're just stepping out briefly."),
            
          ],
        ),
      )
    );
  }
}