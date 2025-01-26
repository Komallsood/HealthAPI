import 'package:flutter/material.dart';
import 'Vitals.dart';
import 'Diet.dart';
import 'Exercise.dart';
import 'WomenHealth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildCard(
                context,
                'Vitals',
                'assets/images/vital.png',
                const Color(0xFF4ECDC4),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Vitals()),
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                context,
                'Diet',
                'assets/images/diet.png',
                const Color(0xFF4ECDC4),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Diet()),
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                context,
                'Exercise',
                'assets/images/exercise.png',
                const Color(0xFF9C8FD9),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Exercise()),
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                context,
                "Women's Health",
                'assets/images/women.png',
                const Color(0xFFFF8B94),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WomenHealth()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String imagePath,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                color.withOpacity(0.7),
                color.withOpacity(0.4),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
