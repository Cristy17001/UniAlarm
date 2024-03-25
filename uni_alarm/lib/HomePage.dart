import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:uni_alarm/Services/weather_service.dart';
import 'package:uni_alarm/constants.dart';
import 'package:uni_alarm/models/weather.dart';
import 'dart:async';
import 'constants.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WeatherService weatherService = WeatherService();
  String name = username;
  bool mode = false;
  late DateTime now = DateTime.now();
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  Weather? weather;

  @override
  void initState() {
    super.initState();
    // Update the time every second
    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          now = DateTime.now();
        });
      });
    }
    check_automatic_theme();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      Weather fetchedWeather = await weatherService.getWeatherData();
      setState(() {
        weather = fetchedWeather;
      });
    } catch (error) {
      print('Error loading weather: $error');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('MMMM dd, yyyy').format(now);
    String time = DateFormat('hh:mm a').format(now);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          // Welcome Title
          Container(
            margin: const EdgeInsets.only(top: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome ",
                    style: TextStyle(
                        color: isDark ? darkText : lightText, fontSize: 48)),
                Text(
                  username,
                  style: TextStyle(
                      color: isDark ? darkHighlights : lightHighlights,
                      fontSize: 48),
                )
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.only(top: 40),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isDark ? darkDetails : lightDetails,
                ),
                borderRadius: BorderRadius.circular(20.0)),
            color: isDark ? darkMainCards : lightMainCards,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  children: [
                    Text(date,
                        style: TextStyle(
                            color: isDark ? darkText : lightText,
                            fontSize: 40)),
                    Text(time,
                        style: TextStyle(
                            color: isDark ? darkText : lightText,
                            fontSize: 40,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.20),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: WeatherDisplay(weather: weather),
          ),
        ],
      ),
    );
  }
}


class WeatherDisplay extends StatelessWidget {
  final Weather? weather;

  const WeatherDisplay({Key? key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weather == null) {
      return Text("No weather data available");
    } else {
      final temperature = weather!.temp_c;
      final city = weather!.city;
      final country = weather!.country;
      final condition = weather!.condition;
      final imagePath = weather!.icon;


      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isDark ? darkMainCards : lightMainCards.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image widget on the right
            Image.asset(
              imagePath,
              width: MediaQuery.of(context).size.width * 0.2,
            ),
            // Vertical Divider
            // Temperature, City, Country, and Condition information
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  temperature.toString()+" ºC",
                  style: TextStyle(
                    color: isDark?darkText:lightText,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  city,
                  style: TextStyle(
                    color: isDark?darkText:lightText,
                    fontSize: 15,
                  ),
                ),
                Text(
                  country,
                  style: TextStyle(
                    color: isDark?darkText:lightText,
                    fontSize: 15,
                  ),
                ),
                Text(
                  condition,
                  style: TextStyle(
                    color: isDark?darkText:lightText,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
