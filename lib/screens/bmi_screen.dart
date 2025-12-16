import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/gender_card.dart';
import '../widgets/height_slider.dart';
import '../widgets/value_card.dart';
import '../utils/constants.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen>
    with SingleTickerProviderStateMixin {
  bool isMale = true;

  double height = 158;
  int age = 23;
  int weight = 57;

  double bmi = 0.0;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //  BMI Calculation
  void calculateBMI() {
    double heightInMeter = height / 100;
    setState(() {
      bmi = weight / (heightInMeter * heightInMeter);
    });
    _controller.forward(from: 0);
  }

  //  Reset
  void resetValues() {
    setState(() {
      isMale = true;
      height = 158;
      age = 23;
      weight = 57;
      bmi = 0.0;
    });
  }

  //  BMI Category
  String get bmiCategory {
    if (bmi == 0) return "—";
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  //  Gradient based on BMI
  List<Color> get bmiGradient {
    if (bmi == 0) {
      return [Colors.grey.shade700, Colors.grey.shade800];
    } else if (bmi < 18.5) {
      return [Colors.blue, Colors.lightBlueAccent];
    } else if (bmi < 25) {
      return [Colors.green, Colors.lightGreen];
    } else if (bmi < 30) {
      return [Colors.orange, Colors.deepOrange];
    } else {
      return [Colors.red, Colors.redAccent];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        centerTitle: true,
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetValues, // 🔁 Reset Button
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gender
            Row(
              children: [
                Expanded(
                  child: GenderCard(
                    icon: FontAwesomeIcons.mars,
                    label: "Male",
                    selected: isMale,
                    onTap: () => setState(() => isMale = true),
                  ),
                ),
                Expanded(
                  child: GenderCard(
                    icon: FontAwesomeIcons.venus,
                    label: "Female",
                    selected: !isMale,
                    onTap: () => setState(() => isMale = false),
                  ),
                ),
              ],
            ),

            // Height
            HeightSlider(
              height: height,
              onChanged: (value) {
                setState(() => height = value);
              },
            ),

            // Age & Weight
            Row(
              children: [
                Expanded(
                  child: ValueCard(
                    label: "Age",
                    value: age,
                    onAdd: () => setState(() => age++),
                    onRemove: () {
                      if (age > 1) setState(() => age--);
                    },
                  ),
                ),
                Expanded(
                  child: ValueCard(
                    label: "Weight",
                    value: weight,
                    onAdd: () => setState(() => weight++),
                    onRemove: () {
                      if (weight > 1) setState(() => weight--);
                    },
                  ),
                ),
              ],
            ),

            // Animated BMI Result
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: bmiGradient),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    const Text("BMI", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 5),
                    Text(
                      bmi == 0 ? "--" : bmi.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(bmiCategory, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),

            // Calculate Button
            GestureDetector(
              onTap: calculateBMI,
              child: Container(
                height: 55,
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Calculate BMI",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
