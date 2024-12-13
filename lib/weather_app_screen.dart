import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double? temp;
  int? humidity;
  Future getCurrentWeather() async {
    try {
      final result = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=Mumbai,india&units=metric&APPID=96aa9c69916d89baa8bbacb04eff01e9"),
      );

      var jsonResponse = jsonDecode(result.body); // Decoding the JSON response
      setState(
        () {
          temp = jsonResponse['list'][0]['main']
              ['temp']; // Set the temperature in the state
          humidity = jsonResponse['list'][0]['main']['humidity'];
        },
      );
      if (result.statusCode != 200) {
        throw "Something went wrong";
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: const Color.fromARGB(255, 50, 121, 121),
        toolbarHeight: 80,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
        title: const Text(
          "Weather Screen",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // main card
              SizedBox(
                width: double.infinity,
                height: 210,
                child: Card.filled(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.black45,
                  elevation: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            '${temp?.toStringAsFixed(1)}° C', // Safely display temp if not null
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.cloud, size: 70),
                          SizedBox(height: 20),
                          Text(
                            "Rain",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //weather forecast cars
              Row(
                children: [
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        debugPrint("Hello");
                      },
                      highlightColor: const Color.fromARGB(255, 38, 37, 34),
                      child: const Icon(Icons.arrow_right)),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HourlyForecastCard(
                      time: "6:00",
                      icon: Icons.sunny,
                      temp: "18° C",
                    ),
                    HourlyForecastCard(
                      time: "9:00",
                      icon: Icons.sunny,
                      temp: "18° C",
                    ),
                    HourlyForecastCard(
                      time: "12:00",
                      icon: Icons.cloud,
                      temp: "20° C",
                    ),
                    HourlyForecastCard(
                      time: "15:00",
                      icon: Icons.sunny_snowing,
                      temp: "22° C",
                    ),
                    HourlyForecastCard(
                      time: "18:00",
                      icon: Icons.cloud,
                      temp: "25° C",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              //additional information
              const Row(
                children: [
                  Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoCard(
                      icon: Icons.water_drop,
                      title: "Humidity",
                      value: '${humidity?.toStringAsFixed(1)}'),
                  AdditionalInfoCard(
                      icon: Icons.air, title: "Wind Speed", value: "7.5"),
                  AdditionalInfoCard(
                      icon: Icons.beach_access,
                      title: "Pressure",
                      value: "1000"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
