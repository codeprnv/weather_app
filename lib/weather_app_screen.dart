import 'dart:convert';
import 'dart:ui';
// import 'package:jiffy/jiffy.dart';
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
  late Future<Map<String, dynamic>> _weatherFuture;
  double? temp;
  int? humidity;
  int? pressure;
  double? wind;
  String? weatherDescription;
  String? iconCode;
  // List<String> dateText = [];
  // String currentDate = Jiffy.now().format(pattern: "yyyy-MM-dd").toString();
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final result = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=Mumbai,india&units=metric&APPID=96aa9c69916d89baa8bbacb04eff01e9"),
      );

      if (result.statusCode == 200) {
        final jsonResponse = jsonDecode(result.body);

        // Update the UI after decoding
        setState(
          () {
            temp = jsonResponse['list'][0]['main']['temp'];
            humidity = jsonResponse['list'][0]['main']['humidity'];
            pressure = jsonResponse['list'][0]['main']['pressure'];
            wind = jsonResponse['list'][0]['wind']['speed'];
            weatherDescription =
                jsonResponse['list'][0]['weather'][0]['description'];
            iconCode = jsonResponse['list'][0]['weather'][0]['icon'];
          },
        );

        return jsonResponse; // Return the response for other uses
      } else {
        final errorResponse = jsonDecode(result.body);
        throw Exception(errorResponse['message']);
      }
    } catch (e) {
      throw Exception("Error fetching weather data: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _weatherFuture = getCurrentWeather();
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
      body: FutureBuilder(
        future: _weatherFuture,
        builder: (context, snapshot) {
          debugPrint(snapshot.connectionState.toString());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Container(
              margin: EdgeInsets.all(20),
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[400],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return Padding(
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
                                // '${snapshot.data['list'][0]['main']['temp'].toStringAsFixed(1)}° C',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Icon(
                              //   Icons.sunny,
                              //   size: 50,
                              // ),
                              Image.network(
                                "https://openweathermap.org/img/wn/$iconCode@2x.png",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "${weatherDescription?.toString()}",
                                style: TextStyle(
                                  fontSize: 24,
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
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
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
                          value: '${humidity?.toString()}'),
                      // value: '${snapshot.data['list'][0]['main']['humidity'].toStringAsFixed(2)}'),
                      AdditionalInfoCard(
                          icon: Icons.air,
                          title: "Wind Speed",
                          value: '${wind?.toStringAsFixed(2)}'),
                      AdditionalInfoCard(
                          icon: Icons.beach_access,
                          title: "Pressure",
                          value: "${pressure?.toString()}"),
                    ],
                  )
                ],
              ),
            );
          } else {
            // Add a return statement or a throw statement here
            return const SizedBox(); // or throw Exception('Unknown error');
          }
          // body: Center(
        },
      ),
      // ),
    );
  }
}
