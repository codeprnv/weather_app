import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecastCard({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint(time);
      },
      splashColor: const Color.fromARGB(255, 47, 43, 43),
      borderRadius: BorderRadius.circular(20),
      child: Card(
        shadowColor: Colors.black45,
        elevation: 100,
        child: Container(
          width: 110,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              Text(
                time,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, size: 50),
              Text(
                temp,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
