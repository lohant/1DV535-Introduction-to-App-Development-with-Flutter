import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Personal Card'),
          leading: const Icon(Icons.flutter_dash),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 250, // Specify the width
                  height: 250, // Specify the height
                  child: Image.asset(
                    'images/anton.jpg',
                    fit: BoxFit.cover, // Ensures the image fits within the circular shape
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add some spacing between the image and text
              Text(
                'Anton Holst',
                style: GoogleFonts.acme(fontSize: 30),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 20), // Add some spacing between the text and the container
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 186, 227, 255),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: GoogleFonts.acme(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'E-mail: anton.holst@email.com',
                          style: GoogleFonts.acme(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'Phone: +46 123 456 789',
                          style: GoogleFonts.acme(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_city, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'City: Stockholm',
                          style: GoogleFonts.acme(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

