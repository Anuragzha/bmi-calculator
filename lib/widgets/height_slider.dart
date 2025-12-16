import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HeightSlider extends StatelessWidget {
  final double height;
  final ValueChanged<double> onChanged;

  const HeightSlider({
    super.key,
    required this.height,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text("Height", style: labelText),
          Text(
            "${height.toInt()} cm",
            style: valueText,
          ),
          Slider(
            value: height,
            min: 100,
            max: 220,
            activeColor: accentColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
