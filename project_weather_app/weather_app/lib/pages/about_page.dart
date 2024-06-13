import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Color.fromARGB(255, 215, 219, 221)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align children at the start (top) of the column
          crossAxisAlignment: CrossAxisAlignment.center, // Center the text horizontally within the column
          children: [
            SizedBox(height: 150), // Add some space from the top of the screen
            Text(
              'Project Weather',
              style: GoogleFonts.lato(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Center the text within its container
            ),
            SizedBox(height: 15), // Add some space between the texts
            Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'This app was developed by Anton Holst during the course "Introduction to App Development with Flutter" (1DV535) at Linnaeus University.',
              style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center, // Center the text within its container
            ),
            ),
            SizedBox(height: 100), // Add some space between the texts
            Text(
              '</>',
              style: GoogleFonts.lato(fontSize: 70, color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
