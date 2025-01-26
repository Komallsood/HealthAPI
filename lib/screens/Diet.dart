import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';

class Diet extends StatelessWidget {
  const Diet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DietOverviewPage();
  }
}

class DietOverviewPage extends StatelessWidget {
  const DietOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final healthProvider = Provider.of<HealthDataProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 16),
                // Current Weight
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ECDC4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.monitor_weight_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Current Weight',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${healthProvider.currentWeight}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' Kgs',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Calories Progress
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ECDC4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_fire_department_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${healthProvider.dailyCalories}/${healthProvider.totalRecommendedCalories} kcal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Daily meals section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily meals',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {},
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Meal list
                ...healthProvider.meals.entries.map((meal) => _buildMealCard(
                      context,
                      meal.value,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, MealData meal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsPage(mealType: meal.name),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Recommended ${meal.recommendedCalories} Kcal',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (meal.items.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Current: ${meal.totalCalories} Kcal',
                      style: TextStyle(
                        fontSize: 12,
                        color: meal.totalCalories > meal.recommendedCalories
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealDetailsPage(mealType: meal.name),
                  ),
                );
              },
              color: const Color(0xFF4ECDC4),
            ),
          ],
        ),
      ),
    );
  }
}

// Rename the existing Diet page to MealDetailsPage
class MealDetailsPage extends StatefulWidget {
  final String mealType;

  const MealDetailsPage({
    Key? key,
    required this.mealType,
  }) : super(key: key);

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

// Rename the state class and keep all the existing meal details functionality
class _MealDetailsPageState extends State<MealDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final Map<FoodItem, int> selectedFoods = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final healthProvider = Provider.of<HealthDataProvider>(context);
    final meal = healthProvider.meals[widget.mealType]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              widget.mealType,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${meal.totalCalories} Kcal',
                style: TextStyle(
                  color: meal.totalCalories > meal.recommendedCalories
                      ? Colors.red
                      : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (meal.items.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Added Items:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...meal.items.map((food) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(food.name),
                            Text(
                              '${food.quantity}${food.unit} (${food.calories * food.quantity} kcal)',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'What did you eat?',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                color: const Color(0xFFE8F7ED),
                borderRadius: BorderRadius.circular(25),
              ),
              tabs: const [
                Tab(text: 'Foods'),
                Tab(text: 'Favorites'),
                Tab(text: 'Dishes'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFoodsList(healthProvider),
                _buildFavoritesList(healthProvider),
                _buildDishesList(healthProvider),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: selectedFoods.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total calories to add: ${selectedFoods.entries.fold(0, (sum, entry) => sum + (entry.key.calories * entry.value))} kcal',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      selectedFoods.forEach((food, quantity) {
                        healthProvider.addFoodToMeal(
                            widget.mealType, food, quantity);
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Add to ${widget.mealType.toLowerCase()} ${selectedFoods.values.fold(0, (sum, quantity) => sum + quantity)}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildFoodsList(HealthDataProvider healthProvider) {
    final filteredFoods = healthProvider.availableFoods
        .where((food) => food.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredFoods.length,
      itemBuilder: (context, index) {
        final food = filteredFoods[index];
        return _buildFoodItem(food);
      },
    );
  }

  Widget _buildFavoritesList(HealthDataProvider healthProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: healthProvider.favoriteFoods.length,
      itemBuilder: (context, index) {
        final food = healthProvider.favoriteFoods[index];
        return _buildFoodItem(food);
      },
    );
  }

  Widget _buildDishesList(HealthDataProvider healthProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: healthProvider.customDishes.length,
      itemBuilder: (context, index) {
        final food = healthProvider.customDishes[index];
        return _buildFoodItem(food);
      },
    );
  }

  Widget _buildFoodItem(FoodItem food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          food.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${food.calories} kcal',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        leading: GestureDetector(
          onTap: () => _showQuantityPicker(food),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${food.quantity}${food.unit}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            selectedFoods.containsKey(food)
                ? Icons.remove_circle_outline
                : Icons.add_circle_outline,
          ),
          color: const Color(0xFF4ECDC4),
          onPressed: () {
            setState(() {
              if (selectedFoods.containsKey(food)) {
                selectedFoods.remove(food);
              } else {
                selectedFoods[food] = 1;
              }
            });
          },
        ),
      ),
    );
  }

  void _showQuantityPicker(FoodItem food) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select quantity for ${food.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (selectedFoods[food]! > 1) {
                        selectedFoods[food] = selectedFoods[food]! - 1;
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
                Text(
                  '${selectedFoods[food] ?? 1}',
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      selectedFoods[food] = (selectedFoods[food] ?? 0) + 1;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
