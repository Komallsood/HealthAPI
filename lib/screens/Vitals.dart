import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';

class Vitals extends StatefulWidget {
  const Vitals({Key? key}) : super(key: key);

  @override
  State<Vitals> createState() => _VitalsState();
}

class _VitalsState extends State<Vitals> {
  @override
  void initState() {
    super.initState();
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    final healthProvider =
        Provider.of<HealthDataProvider>(context, listen: false);
    await healthProvider.requestPermissions();
    await healthProvider.fetchHealthData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<HealthDataProvider>(
        builder: (context, healthProvider, child) {
          return Stack(
            children: [
              // Curved background
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                  color: Color(0xFF4ECDC4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              // Content
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Back button and time
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              "19:02",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Activity summary and vitals grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            _buildActivitySummary(healthProvider),
                            const SizedBox(height: 24),
                            _buildVitalsGrid(healthProvider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivitySummary(HealthDataProvider healthProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricColumn(
                  '🔥',
                  '${healthProvider.dailyCalories}',
                  'KCAL',
                ),
                _buildMetricColumn(
                  '🚶',
                  '${healthProvider.steps}',
                  'STEPS',
                ),
                _buildMetricColumn(
                  '🍽️',
                  '${(healthProvider.dailyCalories * 1.2).round()}',
                  'KCAL IN',
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4ECDC4),
                    width: 6,
                  ),
                ),
              ),
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 6,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange,
                    width: 6,
                  ),
                ),
              ),
              const Icon(
                Icons.favorite,
                color: Color(0xFF4ECDC4),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String emoji, String value, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsGrid(HealthDataProvider healthProvider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildVitalCard(
          'Blood Pressure',
          healthProvider.getBloodPressureText(),
          'mmHg',
        ),
        _buildVitalCard(
          'Heart Rate',
          healthProvider.getHeartRateText(),
          'BPM',
        ),
        _buildVitalCard(
          'SpO2',
          healthProvider.getSpO2Text(),
          '%',
        ),
        _buildVitalCard(
          'Stress Level',
          healthProvider.stressLevel,
          '',
          isStressCard: true,
        ),
      ],
    );
  }

  Widget _buildVitalCard(
    String title,
    String value,
    String unit, {
    bool isStressCard = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isStressCard)
              Text(
                unit,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
