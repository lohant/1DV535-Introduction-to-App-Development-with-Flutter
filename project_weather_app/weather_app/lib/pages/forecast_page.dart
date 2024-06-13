import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ForecastPage extends StatefulWidget {
  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  String apiKey = '02edaf5fc73870dd3e85e3da4b4579f6';
  Map<String, List> forecastDataByDay = {};
  String city = '';

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
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      fetchForecast(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchForecast(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        city = data['city']['name'];
        groupForecastByDay(data['list']);
      });
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  void groupForecastByDay(List data) {
    final Map<String, List> groupedData = {};
    for (var item in data) {
      DateTime dateTime = DateTime.parse(item['dt_txt']);
      String day = DateFormat('EEEE').format(dateTime);
      if (!groupedData.containsKey(day)) {
        groupedData[day] = [];
      }
      groupedData[day]!.add(item);
    }
    setState(() {
      forecastDataByDay = groupedData;
    });
  }

  String formatDay(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    return DateFormat('EEEE').format(dt);
  }

  String formatTime(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    return DateFormat('HH:mm').format(dt); // Use 24-hour format
  }

  String capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

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
          crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
          children: [
            SizedBox(height: 75), // Add some space from the top of the screen
            if (city.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  city,
                  style: GoogleFonts.lato(
                      fontSize: 32, 
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: forecastDataByDay.keys.length,
                itemBuilder: (context, index) {
                  String day = forecastDataByDay.keys.elementAt(index);
                  List dayForecast = forecastDataByDay[day]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      color: Colors.white.withOpacity(0.15), // Transparent card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              day,
                              style: GoogleFonts.lato(
                                  fontSize: 24, 
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ...dayForecast.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    'http://openweathermap.org/img/wn/${item['weather'][0]['icon']}@2x.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatTime(item['dt_txt']),
                                        style: GoogleFonts.lato(
                                            fontSize: 20, 
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${item['main']['temp'].toStringAsFixed(1)} °C - ${capitalize(item['weather'][0]['description'])}',
                                        style: GoogleFonts.lato(
                                            fontSize: 16, 
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
