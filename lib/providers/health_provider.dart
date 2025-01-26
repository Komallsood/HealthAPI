import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class FoodItem {
  final String name;
  final int quantity;
  final String unit;
  final int calories;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
  });

  // Create a copy of the food item with a new quantity
  FoodItem copyWith({int? quantity}) {
    return FoodItem(
      name: name,
      quantity: quantity ?? this.quantity,
      unit: unit,
      calories: calories,
    );
  }
}

class MealData {
  final String name;
  final List<FoodItem> items;
  final int recommendedCalories;

  int get totalCalories {
    return items.fold(0, (sum, item) => sum + (item.calories * item.quantity));
  }

  MealData({
    required this.name,
    required this.items,
    required this.recommendedCalories,
  });
}

class ExerciseActivity {
  final String name;
  final String icon;
  final int calories;
  final int duration; // in minutes
  final DateTime date;

  ExerciseActivity({
    required this.name,
    required this.icon,
    required this.calories,
    required this.duration,
    required this.date,
  });
}

class PeriodSymptom {
  final String name;
  final double intensity; // 0 to 1
  final String icon;

  PeriodSymptom({
    required this.name,
    required this.intensity,
    required this.icon,
  });
}

class CycleDay {
  final DateTime date;
  final List<PeriodSymptom> symptoms;
  final String? flow;
  final String? mood;
  final String? notes;
  final bool hasPeriod;
  final bool isIntimate;
  final String? intimateNotes;

  CycleDay({
    required this.date,
    this.symptoms = const [],
    this.flow,
    this.mood,
    this.notes,
    this.hasPeriod = false,
    this.isIntimate = false,
    this.intimateNotes,
  });
}

class HealthDataProvider with ChangeNotifier {
  final _health = Health();
  final _random = Random();

  HealthDataProvider() {
    _initializeDemoData();
    _initializeWomensHealthData();
  }

  // Health metrics
  int currentWeight = 59;
  int get dailyCalories =>
      meals.values.fold(0, (sum, meal) => sum + meal.totalCalories);
  int get totalRecommendedCalories =>
      meals.values.fold(0, (sum, meal) => sum + meal.recommendedCalories);
  int steps = 0;
  double bloodPressureSystolic = 0;
  double bloodPressureDiastolic = 0;
  int heartRate = 0;
  double spO2 = 0;
  String stressLevel = 'Relaxed';

  // Diet related data
  Map<String, MealData> meals = {
    'Breakfast': MealData(
      name: 'Breakfast',
      items: [],
      recommendedCalories: 437,
    ),
    'Morning Snack': MealData(
      name: 'Morning Snack',
      items: [],
      recommendedCalories: 247,
    ),
    'Lunch': MealData(
      name: 'Lunch',
      items: [],
      recommendedCalories: 547,
    ),
    'Evening Snack': MealData(
      name: 'Evening Snack',
      items: [],
      recommendedCalories: 247,
    ),
    'Dinner': MealData(
      name: 'Dinner',
      items: [],
      recommendedCalories: 547,
    ),
  };

  List<FoodItem> availableFoods = [
    FoodItem(name: 'Coffee with milk', quantity: 100, unit: 'g', calories: 95),
    FoodItem(name: 'Sandwich', quantity: 100, unit: 'g', calories: 265),
    FoodItem(name: 'Tomato', quantity: 1, unit: 'piece', calories: 95),
    FoodItem(name: 'Cucumber', quantity: 1, unit: 'piece', calories: 30),
    FoodItem(name: 'Tea without sugar', quantity: 100, unit: 'ml', calories: 0),
    FoodItem(name: 'Boiled egg', quantity: 1, unit: 'piece', calories: 95),
    FoodItem(name: 'Avocado', quantity: 100, unit: 'g', calories: 205),
  ];

  List<FoodItem> favoriteFoods = [];
  List<FoodItem> customDishes = [];

  // Exercise related data
  List<ExerciseActivity> exerciseActivities = [];
  int get totalExerciseCalories => exerciseActivities
      .where((activity) => activity.date.day == DateTime.now().day)
      .fold(0, (sum, activity) => sum + activity.calories);

  final List<Map<String, dynamic>> availableExercises = [
    {
      'name': 'Skipping',
      'icon': '🏃',
      'caloriesPerMinute': 10,
      'defaultDuration': 30,
    },
    {
      'name': 'Cycling',
      'icon': '🚴',
      'caloriesPerMinute': 8,
      'defaultDuration': 30,
    },
    {
      'name': 'Running',
      'icon': '🏃‍♂️',
      'caloriesPerMinute': 11,
      'defaultDuration': 30,
    },
    {
      'name': 'Meditation',
      'icon': '🧘‍♂️',
      'caloriesPerMinute': 3,
      'defaultDuration': 20,
    },
  ];

  // Weekly exercise data for the chart
  List<int> get weeklyExerciseData {
    final now = DateTime.now();
    final List<int> weekData = List.filled(7, 0);

    for (var activity in exerciseActivities) {
      final difference = now.difference(activity.date).inDays;
      if (difference < 7) {
        weekData[6 - difference] += activity.calories;
      }
    }

    return weekData;
  }

  void addFoodToMeal(String mealType, FoodItem food, int quantity) {
    if (meals.containsKey(mealType)) {
      // Create a new food item with the specified quantity
      final newFood = food.copyWith(quantity: quantity);

      // Add to the meal's items list
      meals[mealType]!.items.add(newFood);
      notifyListeners();
    }
  }

  void removeFoodFromMeal(String mealType, FoodItem food) {
    if (meals.containsKey(mealType)) {
      meals[mealType]!.items.removeWhere(
          (item) => item.name == food.name && item.quantity == food.quantity);
      notifyListeners();
    }
  }

  void addToFavorites(FoodItem food) {
    if (!favoriteFoods.contains(food)) {
      favoriteFoods.add(food);
      notifyListeners();
    }
  }

  void removeFromFavorites(FoodItem food) {
    favoriteFoods.remove(food);
    notifyListeners();
  }

  void _initializeDemoData() {
    // Add demo exercise data for the past 4 days
    final now = DateTime.now();

    // Day 1 (Today)
    addExerciseActivity('Running', 30);
    addExerciseActivity('Meditation', 20);

    // Day 2 (Yesterday)
    _addDemoExercise('Cycling', 45, now.subtract(const Duration(days: 1)));
    _addDemoExercise('Skipping', 20, now.subtract(const Duration(days: 1)));

    // Day 3
    _addDemoExercise('Running', 25, now.subtract(const Duration(days: 2)));
    _addDemoExercise('Meditation', 15, now.subtract(const Duration(days: 2)));

    // Day 4
    _addDemoExercise('Cycling', 30, now.subtract(const Duration(days: 3)));
    _addDemoExercise('Skipping', 15, now.subtract(const Duration(days: 3)));

    // Generate random steps for past days
    steps = 3524; // Today's steps
  }

  void _addDemoExercise(String name, int duration, DateTime date) {
    final exercise = availableExercises.firstWhere((e) => e['name'] == name);
    final calories = (exercise['caloriesPerMinute'] as int) * duration;

    exerciseActivities.add(ExerciseActivity(
      name: name,
      icon: exercise['icon'],
      calories: calories,
      duration: duration,
      date: date,
    ));
  }

  // Generate realistic random data
  void _generateRandomData() {
    // Random steps between 2000 and 12000
    steps = 2000 + _random.nextInt(10000);

    // Instead of setting dailyCalories directly, let's add a random food item to lunch
    final randomCalories = 800 + _random.nextInt(1700);
    meals['Lunch']!.items.clear(); // Clear existing items
    meals['Lunch']!.items.add(
          FoodItem(
            name: 'Random meal',
            quantity: 1,
            unit: 'portion',
            calories: randomCalories,
          ),
        );

    // Rest of the random data generation
    bloodPressureSystolic = 110 + _random.nextInt(30).toDouble();
    bloodPressureDiastolic = 70 + _random.nextInt(20).toDouble();
    heartRate = 60 + _random.nextInt(40);
    spO2 = 95 + _random.nextInt(5).toDouble();
    final stressLevels = ['Relaxed', 'Normal', 'High', 'Low'];
    stressLevel = stressLevels[_random.nextInt(stressLevels.length)];

    notifyListeners();
  }

  Future<bool> requestPermissions() async {
    try {
      final types = [
        HealthDataType.WEIGHT,
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_OXYGEN,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        HealthDataType.ACTIVE_ENERGY_BURNED,
      ];

      bool? hasPermissions = await _health.hasPermissions(types);
      hasPermissions ??= false;

      if (!hasPermissions) {
        await _health.requestAuthorization(types);
      }

      return hasPermissions;
    } catch (e) {
      debugPrint('Error requesting health permissions: $e');
      return false;
    }
  }

  Future<void> fetchHealthData() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      // For demo purposes, generate random data instead of actual API calls
      _generateRandomData();

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching health data: $e');
    }
  }

  String getBloodPressureText() {
    if (bloodPressureSystolic == 0 || bloodPressureDiastolic == 0) {
      return '--/--';
    }
    return '${bloodPressureSystolic.toInt()}/${bloodPressureDiastolic.toInt()}';
  }

  String getHeartRateText() {
    if (heartRate == 0) {
      return '--';
    }
    return heartRate.toString();
  }

  String getSpO2Text() {
    if (spO2 == 0) {
      return '--';
    }
    return spO2.toStringAsFixed(0);
  }

  void addExerciseActivity(String name, int duration) {
    final exercise = availableExercises.firstWhere((e) => e['name'] == name);
    final calories = (exercise['caloriesPerMinute'] as int) * duration;

    exerciseActivities.add(ExerciseActivity(
      name: name,
      icon: exercise['icon'],
      calories: calories,
      duration: duration,
      date: DateTime.now(),
    ));

    notifyListeners();
  }

  // Get today's total steps and calories
  int get todaySteps => steps;
  int get todayCaloriesBurned => totalExerciseCalories;

  // Women's Health related data
  final List<String> availableSymptoms = [
    'Cramps',
    'Tired',
    'Bloating',
    'Back Pain',
    'Headache',
    'Nausea',
    'Tender Breasts',
    'Acne',
    'Upset Stomach',
    'Cravings',
    'Insomnia',
    'Ovulation Pain',
  ];

  final List<String> flowLevels = [
    'Light',
    'Medium',
    'Heavy',
    'Spotting',
  ];

  final List<String> moodTypes = [
    'Happy',
    'Sensitive',
    'Sad',
    'Angry',
    'Anxious',
    'Calm',
  ];

  Map<DateTime, CycleDay> cycleDays = {};
  DateTime? cycleStartDate;
  int averageCycleLength = 28;

  // Initialize with some demo data
  void _initializeWomensHealthData() {
    final now = DateTime.now();
    cycleStartDate = DateTime(
        now.year, now.month, now.day - 4); // Current cycle started 4 days ago

    // Add some demo symptoms for the past few days
    for (var i = 0; i < 5; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      if (i < 2) {
        // Last two days
        cycleDays[date] = CycleDay(
          date: date,
          hasPeriod: true,
          flow: 'Medium',
          symptoms: [
            PeriodSymptom(name: 'Cramps', intensity: 0.7, icon: '😣'),
            PeriodSymptom(name: 'Bloating', intensity: 0.5, icon: '😫'),
          ],
          mood: 'Sensitive',
        );
      } else {
        // Earlier days
        cycleDays[date] = CycleDay(
          date: date,
          hasPeriod: true,
          flow: 'Light',
          symptoms: [
            PeriodSymptom(name: 'Tired', intensity: 0.3, icon: '😴'),
          ],
          mood: 'Calm',
        );
      }
    }
  }

  void addCycleDay(
    DateTime date, {
    List<PeriodSymptom>? symptoms,
    String? flow,
    String? mood,
    String? notes,
    bool? hasPeriod,
    bool? isIntimate,
    String? intimateNotes,
  }) {
    cycleDays[date] = CycleDay(
      date: date,
      symptoms: symptoms ?? [],
      flow: flow,
      mood: mood,
      notes: notes,
      hasPeriod: hasPeriod ?? false,
      isIntimate: isIntimate ?? false,
      intimateNotes: intimateNotes,
    );
    notifyListeners();
  }

  void updateCycleStartDate(DateTime date) {
    cycleStartDate = date;
    notifyListeners();
  }

  int get currentCycleDay {
    if (cycleStartDate == null) return 0;
    return DateTime.now().difference(cycleStartDate!).inDays + 1;
  }

  String get fertilityStatus {
    if (cycleStartDate == null) return 'Unknown';
    final day = currentCycleDay;
    if (day >= 11 && day <= 17) return 'High';
    if (day >= 8 && day <= 20) return 'Medium';
    return 'Low';
  }

  CycleDay? getCycleDay(DateTime date) {
    return cycleDays[DateTime(date.year, date.month, date.day)];
  }
}
