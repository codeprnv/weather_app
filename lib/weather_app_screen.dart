import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
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
  // List<String> dateText = [];
  // String currentDate = Jiffy.now().format(pattern: "yyyy-MM-dd").toString();
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final cityName = 'Navi Mumbai'.toLowerCase();
      final countryName = 'india'.toLowerCase();
      final apiKey = '96aa9c69916d89baa8bbacb04eff01e9';
      final result = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,$countryName&units=metric&APPID=$apiKey"),
      );

      if (result.statusCode == 200) {
        final jsonResponse = jsonDecode(result.body);
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
          IconButton(
              onPressed: () {
                setState(() {
                  debugPrint('Set State called ');
                });
              },
              icon: const Icon(Icons.refresh)),
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
            final data = snapshot.data!;
            final cityName = data['city']['name'];
            final countryName = data['city']['country'];
            final currentWeatherData = data['list'][0];
            final temp = currentWeatherData['main']['temp'];
            final humidity = currentWeatherData['main']['humidity'];
            final pressure = currentWeatherData['main']['pressure'];
            final wind = currentWeatherData['wind']['speed'];
            final iconDescription = currentWeatherData['weather'][0]['main'];
            final weatherDescription =
                currentWeatherData['weather'][0]['description'];
            List<String>? dates = [];
            List<String> time = [];
            for (int i = 0; i <= 5; i++) {
              dates.add(data['list'][i]['dt_txt']);
              time.add(dates[i].substring(11, 16));
            }
            // debugPrint(time.toString());
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
                              SizedBox(height: 15),
                              Text(
                                '${temp?.toStringAsFixed(1)}° C', // Safely display temp if not null
                                // '${snapshot.data['list'][0]['main']['temp'].toStringAsFixed(1)}° C',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "$cityName,$countryName",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                iconDescription == 'Clear'
                                    ? Icons.sunny
                                    : Icons.cloud,
                                size: 45,
                              ),
                              // Image.network(
                              //   "https://openweathermap.org/img/wn/$iconCode@2x.png",
                              //   width: 60,
                              //   height: 60,
                              //   fit: BoxFit.cover,
                              // ),
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
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlyTime =
                            DateTime.parse(hourlyForecast['dt_txt']);
                        final formattedTime =
                            '${DateFormat.Md().format(hourlyTime)} ${DateFormat.jm().format(hourlyTime)}';
                        final hourlyIcon =
                            hourlyForecast['weather'][0]['main'] == 'Clear'
                                ? Icons.sunny
                                : Icons.cloud;
                        final temp = hourlyForecast['main']['temp'].toString();
                        return HourlyForecastCard(
                            time: formattedTime, icon: hourlyIcon, temp: temp);
                      },
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
