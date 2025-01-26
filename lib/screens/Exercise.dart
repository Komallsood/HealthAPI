import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';

class Exercise extends StatelessWidget {
  const Exercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ExerciseOverviewPage();
  }
}

class ExerciseOverviewPage extends StatelessWidget {
  const ExerciseOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final healthProvider = Provider.of<HealthDataProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF9C8FD9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Back button and Today text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 40), // For balance
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Header with steps and calories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricCard(
                        '${healthProvider.todaySteps}',
                        'steps',
                        '🦶',
                      ),
                      _buildMetricCard(
                        '${healthProvider.todayCaloriesBurned}',
                        'calories',
                        '🔥',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Weekly chart
                  SizedBox(
                    height: 150,
                    child: _buildWeeklyChart(healthProvider.weeklyExerciseData),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Exercise activities
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: healthProvider.availableExercises.length,
                itemBuilder: (context, index) {
                  final exercise = healthProvider.availableExercises[index];
                  return _buildExerciseCard(
                    context,
                    exercise['name'],
                    exercise['icon'],
                    exercise['defaultDuration'],
                    exercise['caloriesPerMinute'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String value, String label, String emoji) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(emoji, style: const TextStyle(fontSize: 24)),
            ],
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(List<int> weekData) {
    final maxValue = weekData.reduce((curr, next) => curr > next ? curr : next);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        final value = weekData[index].toDouble();
        final height = maxValue > 0 ? (value / maxValue) * 100 : 0.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getDayLabel(index),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getDayLabel(int index) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  Widget _buildExerciseCard(BuildContext context, String name, String icon,
      int defaultDuration, int caloriesPerMinute) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () => _showDurationPicker(
          context,
          name,
          defaultDuration,
          caloriesPerMinute,
        ),
        leading: Text(
          icon,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(name),
        subtitle: Text('$caloriesPerMinute kcal/min'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  void _showDurationPicker(BuildContext context, String name,
      int defaultDuration, int caloriesPerMinute) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ExerciseDurationPicker(
        name: name,
        defaultDuration: defaultDuration,
        caloriesPerMinute: caloriesPerMinute,
      ),
    );
  }
}

class ExerciseDurationPicker extends StatefulWidget {
  final String name;
  final int defaultDuration;
  final int caloriesPerMinute;

  const ExerciseDurationPicker({
    Key? key,
    required this.name,
    required this.defaultDuration,
    required this.caloriesPerMinute,
  }) : super(key: key);

  @override
  State<ExerciseDurationPicker> createState() => _ExerciseDurationPickerState();
}

class _ExerciseDurationPickerState extends State<ExerciseDurationPicker> {
  late int selectedDuration;

  @override
  void initState() {
    super.initState();
    selectedDuration = widget.defaultDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Today',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select how many calories you can burn',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDurationOption(10),
              _buildDurationOption(20),
              _buildDurationOption(30),
              _buildDurationOption(40),
              _buildDurationOption(50),
              _buildDurationOption(60),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${selectedDuration * widget.caloriesPerMinute} Calories',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final provider =
                    Provider.of<HealthDataProvider>(context, listen: false);
                provider.addExerciseActivity(widget.name, selectedDuration);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C8FD9),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOption(int duration) {
    final isSelected = duration == selectedDuration;
    return GestureDetector(
      onTap: () => setState(() => selectedDuration = duration),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9C8FD9) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$duration',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
