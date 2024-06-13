import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  String apiKey = '02edaf5fc73870dd3e85e3da4b4579f6';
  String weatherDescription = '';
  String temperature = '';
  String iconUrl = '';
  String date = '';
  String time = '';
  String city = '';
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location services are disabled.';
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Location permissions are denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Location permissions are permanently denied';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      fetchCurrentWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to get location: $e';
      });
    }
  }

  Future<void> fetchCurrentWeather(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final now = DateTime.now();
        setState(() {
          weatherDescription = data['weather'][0]['description'];
          temperature = data['main']['temp'].toDouble().toStringAsFixed(1) + ' °C';
          iconUrl = 'http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@4x.png';
          time = DateFormat('HH:mm').format(now);
          date = DateFormat('EEEE, d MMMM').format(now);
          city = data['name'];
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load weather data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load weather data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Color.fromARGB(255, 215, 219, 221)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              if (city.isNotEmpty) ...[
                Text(
                  city,
                  style: GoogleFonts.lato(fontSize: 36, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Current location',
                      style: GoogleFonts.lato(fontSize: 12, color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
              if (iconUrl.isNotEmpty)
                Image.network(iconUrl, width: 200, height: 200),
              if (temperature.isNotEmpty)
                Text(
                  temperature,
                  style: GoogleFonts.lato(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 50),
              if (time.isNotEmpty)
                Text(
                  time,
                  style: GoogleFonts.lato(fontSize: 28, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 25),
              if (weatherDescription.isNotEmpty)
                Text(
                  weatherDescription,
                  style: GoogleFonts.lato(fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
