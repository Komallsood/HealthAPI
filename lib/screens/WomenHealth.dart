import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class WomenHealth extends StatefulWidget {
  const WomenHealth({Key? key}) : super(key: key);

  @override
  State<WomenHealth> createState() => _WomenHealthState();
}

class _WomenHealthState extends State<WomenHealth> {
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  late PageController _pageController;
  final TextEditingController _notesController = TextEditingController();
  bool _isExpanded = false;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedDate = DateTime.now();
    _pageController = PageController(initialPage: 0);
    _loadNotes();
  }

  void _loadNotes() {
    final healthProvider =
        Provider.of<HealthDataProvider>(context, listen: false);
    final cycleDay = healthProvider.getCycleDay(_selectedDate);
    if (cycleDay?.notes != null) {
      _notesController.text = cycleDay!.notes!;
    } else {
      _notesController.clear();
    }
  }

  void _saveNotes() {
    final healthProvider =
        Provider.of<HealthDataProvider>(context, listen: false);
    healthProvider.addCycleDay(
      _selectedDate,
      notes: _notesController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notes saved successfully'),
        backgroundColor: Color(0xFFFFB6C1),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final healthProvider = Provider.of<HealthDataProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final now = DateTime.now();
    final firstDay = DateTime(now.year - 1, now.month, now.day);
    final lastDay = DateTime(now.year + 1, now.month, now.day);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          DateFormat('MMMM yyyy').format(_focusedDate),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Calendar Section
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: firstDay,
                    lastDay: lastDay,
                    focusedDay: _focusedDate,
                    currentDay: now,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDate, day),
                    calendarFormat: _calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    headerVisible: false,
                    calendarStyle: const CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFFFFB6C1),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color(0xFFFFB6C1),
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(color: Colors.red),
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDate, selectedDay)) {
                        setState(() {
                          _selectedDate = selectedDay;
                          _focusedDate = focusedDay;
                          _loadNotes();
                        });
                      }
                    },
                  ),
                  if (!_isExpanded) ...[
                    const SizedBox(height: 20),
                    // Cycle Overview
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
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
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFB6C1),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Current cycle',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'DAY ${healthProvider.currentCycleDay}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    '24 Days',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Next Period',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    healthProvider.fertilityStatus,
                                    style: const TextStyle(
                                      color: Colors.purple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Fertility',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
            // Log Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Log for ${DateFormat('MMM d').format(_selectedDate)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            if (_notesController.text.isNotEmpty)
                              TextButton(
                                onPressed: _saveNotes,
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Color(0xFFFFB6C1),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildLogSection(
                            'Period',
                            const Icon(Icons.water_drop,
                                color: Color(0xFFFFB6C1)),
                            [
                              _buildPeriodPhaseSection(healthProvider),
                              const SizedBox(height: 16),
                              _buildFlowSection(healthProvider),
                            ],
                          ),
                          _buildLogSection(
                            'Personal',
                            const Icon(Icons.person, color: Color(0xFFFFB6C1)),
                            [
                              _buildMoodSection(healthProvider),
                              const SizedBox(height: 16),
                              _buildNotesSection(),
                            ],
                          ),
                          _buildLogSection(
                            'Intimacy',
                            const Icon(Icons.favorite,
                                color: Color(0xFFFFB6C1)),
                            [
                              _buildIntimacySection(healthProvider),
                            ],
                          ),
                          _buildLogSection(
                            'Cycle',
                            const Icon(Icons.calendar_today,
                                color: Color(0xFFFFB6C1)),
                            [
                              _buildCycleSection(healthProvider),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogSection(String title, Icon icon, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: icon,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodPhaseSection(HealthDataProvider healthProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Period phase',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'When does your periods start?',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFlowSection(HealthDataProvider healthProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Flow',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Any bleeding today?',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: healthProvider.flowLevels.map((flow) {
            final cycleDay = healthProvider.getCycleDay(_selectedDate);
            final isSelected = cycleDay?.flow == flow;
            return ChoiceChip(
              label: Text(flow),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  healthProvider.addCycleDay(
                    _selectedDate,
                    flow: flow,
                    hasPeriod: true,
                  );
                }
              },
              selectedColor: const Color(0xFFFFB6C1),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMoodSection(HealthDataProvider healthProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mood',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: healthProvider.moodTypes.map((mood) {
            final cycleDay = healthProvider.getCycleDay(_selectedDate);
            final isSelected = cycleDay?.mood == mood;
            return ChoiceChip(
              label: Text(mood),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  healthProvider.addCycleDay(
                    _selectedDate,
                    mood: mood,
                  );
                }
              },
              selectedColor: const Color(0xFFFFB6C1),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: 'Add notes...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFFB6C1)),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildIntimacySection(HealthDataProvider healthProvider) {
    final cycleDay = healthProvider.getCycleDay(_selectedDate);
    return SwitchListTile(
      title: const Text(
        'Sexual Activity',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      value: cycleDay?.isIntimate ?? false,
      onChanged: (value) {
        healthProvider.addCycleDay(
          _selectedDate,
          isIntimate: value,
        );
      },
      activeColor: const Color(0xFFFFB6C1),
    );
  }

  Widget _buildCycleSection(HealthDataProvider healthProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cycle Information',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Current Day: ${healthProvider.currentCycleDay}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          'Fertility: ${healthProvider.fertilityStatus}',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
