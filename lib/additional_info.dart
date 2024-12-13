import 'package:flutter/material.dart';

class AdditionalInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const AdditionalInfoCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onLongPress: () {},
          radius: 40,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.redAccent,
          child: SizedBox(
            width: 110,
            child: Column(
              children: [
                Icon(icon, size: 50),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
